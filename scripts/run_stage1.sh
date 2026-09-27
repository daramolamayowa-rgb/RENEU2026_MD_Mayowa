#!/usr/bin/env bash
# =============================================================================
#  run_stage1.sh  -  Stage 1 of the research plan: the pure ionic liquid
#  Achinivu Lab, RENEU 2026
#
#  Usage:   bash scripts/run_stage1.sh M1_butylammonium_octanoate
#           bash scripts/run_stage1.sh M1_butylammonium_octanoate --quick
#
#  --quick runs a very short simulation (about 10 minutes) just to prove the
#  pipeline works end to end. It is a pipeline test, NOT a result.
#
#  The script stops with a clear message if anything is wrong, rather than
#  letting a broken simulation run for hours.
# =============================================================================
set -euo pipefail

SYS="${1:-}"
QUICK="${2:-}"
if [ -z "$SYS" ]; then
    echo "Usage: bash scripts/run_stage1.sh <system folder name> [--quick]"
    echo "Your systems are:"; ls systems; exit 1
fi

HERE="$(cd "$(dirname "$0")/.." && pwd)"
SYSDIR="$HERE/systems/$SYS"
[ -d "$SYSDIR" ] || { echo "ERROR: no system folder called $SYS in $HERE/systems"; \
                      echo "Your systems are:"; ls "$HERE/systems"; exit 1; }

# shellcheck disable=SC1090
source "$HERE/scripts/env.sh"
source "$SYSDIR/system.cfg"

RUN="$SYSDIR/stage1_pure_IL"
mkdir -p "$RUN"; cd "$RUN"

echo "============================================================"
echo " Stage 1  -  $NAME"
echo " cation $CATION   anion $ANION   $NPAIR ion pairs"
echo " target element(s): $TARGETS"
echo "============================================================"

cp "$HERE/molecules/$CATION.zmat" "$HERE/molecules/$ANION.zmat" .
cp "$HERE/forcefield/reneu.ff" .

# ---------------------------------------------------------------- step 1/6
echo; echo ">>> [1/6] box size for a starting density of $RHO_START g/cm3"
BOX=$(python3 "$HERE/scripts/boxlen.py" reneu.ff "$RHO_START" \
        "$NPAIR" "$CATION.zmat" "$NPAIR" "$ANION.zmat")
echo "    cubic box = $BOX A  (deliberately expanded; the NPT run compresses it)"

# ---------------------------------------------------------------- step 2/6
echo; echo ">>> [2/6] fftool: assign CL&P types and CHECK THE CHARGES"
FFARGS=("$NPAIR" "$CATION.zmat" "$NPAIR" "$ANION.zmat")
$FFTOOL "${FFARGS[@]}" --box "$BOX" --tol 2.0 | tee fftool_charges.txt

python3 "$HERE/scripts/checkcharge.py" fftool_charges.txt || exit 1

# ---------------------------------------------------------------- step 3/6
echo; echo ">>> [3/6] packmol: place the ions in the box"
echo "    (this takes 2-5 minutes and prints nothing useful while it works)"
packmol < pack.inp > packmol.log 2>&1 || true
if ! grep -q "Success" packmol.log; then
    echo "    packmol could not meet the tolerance at this box size; retrying 10% larger"
    BOX=$(awk -v b="$BOX" 'BEGIN{printf "%.2f", b*1.10}')
    $FFTOOL "${FFARGS[@]}" --box "$BOX" --tol 2.0 > /dev/null
    packmol < pack.inp > packmol.log 2>&1 || true
fi
if [ ! -s simbox.xyz ]; then
    echo "    STOP. Packmol produced no simbox.xyz. Last lines of packmol.log:"
    tail -20 packmol.log; exit 1
fi
if ! grep -q "Success" packmol.log; then
    echo "    NOTE: packmol returned its best solution rather than a clean success."
    echo "    That is usually fine here because the next step is an energy"
    echo "    minimisation, but check that the density settles sensibly."
fi
echo "    OK, simbox.xyz written ($(head -1 simbox.xyz) atoms)."

# ---------------------------------------------------------------- step 4/6
echo; echo ">>> [4/6] fftool --lmp: write data.lmp and in.lmp"
$FFTOOL "${FFARGS[@]}" --box "$BOX" --lmp > /dev/null
grep -E "atoms|atom types" data.lmp | head -2 | sed 's/^/    /'
python3 "$HERE/scripts/prep_lmp.py" in.lmp --label "stage1 $NAME" ${QUICK:+--quick}

# ---------------------------------------------------------------- step 5/6
echo; echo ">>> [5/6] LAMMPS"
echo "    running as: $LMPRUN"
$LMPRUN -in in.lmp | tail -25

DENS=$(awk '!/^#/ && NF>=2 {s+=$2; n++} END {if (n) printf "%.4f", s/n}' density.dat 2>/dev/null || echo "")
echo "    mean density over the production run: ${DENS:-not recorded} g/cm3"
if [ -n "$DENS" ] && awk -v d="$DENS" 'BEGIN{exit !(d<0.5)}'; then
    echo "    WARNING: that density is too low for a liquid. Read TROUBLESHOOTING.md"
    echo "    before you analyse or present anything from this run."
fi

# ---------------------------------------------------------------- step 6/6
echo; echo ">>> [6/6] analysis (Part C of the research plan)"
python3 "$HERE/scripts/analyze.py" --dump dump.lammpstrj --data data.lmp \
        --stage 1 --out analysis --title "$NAME stage 1"

echo
echo "============================================================"
echo " Stage 1 finished for $NAME"
echo " trajectory : $RUN/dump.lammpstrj"
echo " analysis   : $RUN/analysis/summary.md"
echo " next       : bash scripts/run_stage2.sh $SYS"
echo "============================================================"
