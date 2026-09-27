#!/usr/bin/env bash
# =============================================================================
#  run_stage3.sh  -  Stage 3 (STRETCH GOAL): ionic liquid + water + Nd(III)
#  Achinivu Lab, RENEU 2026
#
#  Usage:   bash scripts/run_stage3.sh M1_butylammonium_octanoate
#           bash scripts/run_stage3.sh M1_butylammonium_octanoate --quick
#
#  --quick runs a very short simulation (about 10 minutes) just to prove the
#  pipeline works end to end. It is a pipeline test, NOT a result.
#
#  READ THIS FIRST. Stage 3 is a stretch goal. The Nd(III) Lennard-Jones
#  parameters are literature values, not CL&P values, and they are NOT
#  validated until step 3a below reproduces the known Nd-O distance in pure
#  water. Until that check passes, anything you compute here is a pipeline
#  test and must be labelled as such on any slide (research plan Section 5.2).
#
#  The script runs 3a (Nd + water only) then 3b (Nd + water + the ionic liquid).
# =============================================================================
set -euo pipefail

SYS="${1:-}"
QUICK="${2:-}"
if [ -z "$SYS" ]; then
    echo "Usage: bash scripts/run_stage3.sh <system folder name> [--quick]"
    echo "Your systems are:"; ls systems; exit 1
fi

HERE="$(cd "$(dirname "$0")/.." && pwd)"
SYSDIR="$HERE/systems/$SYS"
[ -d "$SYSDIR" ] || { echo "ERROR: no system folder called $SYS in $HERE/systems"; \
                      echo "Your systems are:"; ls "$HERE/systems"; exit 1; }

# shellcheck disable=SC1090
source "$HERE/scripts/env.sh"
source "$SYSDIR/system.cfg"


# =============================================================================
#  3a  -  validate the ion parameters in pure water, before the IL is added
# =============================================================================
RUN="$SYSDIR/stage3a_ion_water"
mkdir -p "$RUN"; cd "$RUN"

echo "============================================================"
echo " Stage 3a  -  $ION(III) + $ANION + water   (parameter validation)"
echo " system: $NAME     target element(s) in the real process: $TARGETS"
echo "============================================================"

cp "$HERE/molecules/$ANION.zmat" "$HERE/molecules/spce.zmat" "$HERE/molecules/$ION.zmat" .
cp "$HERE/forcefield/reneu.ff" "$HERE/forcefield/spce.ff" "$HERE/forcefield/$ION.ff" .

NANION3A=3   # 1 x M(3+) needs 3 x anion(1-) to make the box neutral

echo; echo ">>> [1/6] box size for a starting density of 0.85 g/cm3 (mostly water)"
BOX=$(python3 "$HERE/scripts/boxlen.py" reneu.ff 0.85 \
        1 "$ION.zmat" "$NANION3A" "$ANION.zmat" "$NWATER3A" spce.zmat)
echo "    cubic box = $BOX A"

echo; echo ">>> [2/6] fftool: assign types and CHECK THE CHARGES"
FFARGS=(1 "$ION.zmat" "$NANION3A" "$ANION.zmat" "$NWATER3A" spce.zmat)
$FFTOOL "${FFARGS[@]}" --box "$BOX" --tol 2.0 | tee fftool_charges.txt
python3 "$HERE/scripts/checkcharge.py" fftool_charges.txt || exit 1

echo; echo ">>> [3/6] packmol"
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

echo; echo ">>> [4/6] fftool --lmp"
$FFTOOL "${FFARGS[@]}" --box "$BOX" --lmp > /dev/null
python3 "$HERE/scripts/prep_lmp.py" in.lmp --label "stage3a $NAME" ${QUICK:+--quick}

echo; echo ">>> [5/6] LAMMPS   ($LMPRUN)"
$LMPRUN -in in.lmp | tail -20

echo; echo ">>> [6/6] analysis - THE VALIDATION CHECK"
python3 "$HERE/scripts/analyze.py" --dump dump.lammpstrj --data data.lmp \
        --stage 3 --out analysis --title "$NAME stage 3a"
echo
echo "    Look at the metal ion - O(water) row of analysis/summary.md."
echo "    The research plan expects the first peak near 2.4-2.5 A and a"
echo "    first-shell coordination number near 8-9. If your numbers are outside"
echo "    that, STOP and tell Alex before running 3b: it means the ion"
echo "    parameters or the combining rule need to be checked, not that you"
echo "    have discovered something."
echo

# =============================================================================
#  3b  -  the full system: ionic liquid + water + the ion
# =============================================================================
RUN="$SYSDIR/stage3b_IL_water_ion"
mkdir -p "$RUN"; cd "$RUN"

NANION3B=$((NPAIR + 3))   # extra anions balance the 3+ charge of the ion

echo "============================================================"
echo " Stage 3b  -  $NAME + water + $ION(III)"
echo " $NPAIR $CATION  +  $NANION3B $ANION  +  $NWATER water  +  1 $ION"
echo "============================================================"

cp "$HERE/molecules/$CATION.zmat" "$HERE/molecules/$ANION.zmat" \
   "$HERE/molecules/spce.zmat" "$HERE/molecules/$ION.zmat" .
cp "$HERE/forcefield/reneu.ff" "$HERE/forcefield/spce.ff" "$HERE/forcefield/$ION.ff" .

echo; echo ">>> [1/6] box size"
BOX=$(python3 "$HERE/scripts/boxlen.py" reneu.ff "$RHO_START" \
        "$NPAIR" "$CATION.zmat" "$NANION3B" "$ANION.zmat" "$NWATER" spce.zmat 1 "$ION.zmat")
echo "    cubic box = $BOX A"

echo; echo ">>> [2/6] fftool: CHECK THE CHARGES"
FFARGS=("$NPAIR" "$CATION.zmat" "$NANION3B" "$ANION.zmat" "$NWATER" spce.zmat 1 "$ION.zmat")
$FFTOOL "${FFARGS[@]}" --box "$BOX" --tol 2.0 | tee fftool_charges.txt
python3 "$HERE/scripts/checkcharge.py" fftool_charges.txt || exit 1

echo; echo ">>> [3/6] packmol"
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

echo; echo ">>> [4/6] fftool --lmp"
$FFTOOL "${FFARGS[@]}" --box "$BOX" --lmp > /dev/null
python3 "$HERE/scripts/prep_lmp.py" in.lmp --label "stage3b $NAME" ${QUICK:+--quick}

echo; echo ">>> [5/6] LAMMPS   ($LMPRUN)"
$LMPRUN -in in.lmp | tail -20

echo; echo ">>> [6/6] analysis"
python3 "$HERE/scripts/analyze.py" --dump dump.lammpstrj --data data.lmp \
        --stage 3 --out analysis --title "$NAME stage 3b"

echo
echo "============================================================"
echo " Stage 3 finished for $NAME"
echo " 3a (validation) : $SYSDIR/stage3a_ion_water/analysis/summary.md"
echo " 3b (full system): $SYSDIR/stage3b_IL_water_ion/analysis/summary.md"
echo
echo " ONE ION IS ONE ION. A coordination number from a single ion in a"
echo " single box has no error bar. Report it as preliminary, exactly as"
echo " Section 5.2 of the research plan requires."
echo "============================================================"
