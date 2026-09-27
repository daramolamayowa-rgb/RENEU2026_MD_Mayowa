#!/usr/bin/env bash
# =============================================================================
#  check_setup.sh  -  run this FIRST, before any simulation.
#  It tells you, in one screen, whether your machine can run this project.
#  Nothing here changes any file. It is safe to run as many times as you like.
# =============================================================================
HERE="$(cd "$(dirname "$0")/.." && pwd)"
ok=0; bad=0
say() { printf "  %-34s %s\n" "$1" "$2"; }
good() { say "$1" "OK   $2"; ok=$((ok+1)); }
fail() { say "$1" "MISSING   $2"; bad=$((bad+1)); }

echo "============================================================"
echo " RENEU 2026 setup check"
echo "============================================================"
echo
echo "PROGRAMS"

if command -v fftool > /dev/null 2>&1; then good "fftool" "$(command -v fftool)"
elif [ -x "$HOME/pilmd_tools/fftool/fftool" ]; then good "fftool" "$HOME/pilmd_tools/fftool/fftool"
elif [ -x "$HOME/fftool/fftool" ]; then good "fftool" "$HOME/fftool/fftool"
else fail "fftool" "git clone https://github.com/paduagroup/fftool ~/pilmd_tools/fftool"; fi

command -v packmol > /dev/null 2>&1 && good "packmol" "$(command -v packmol)" \
    || fail "packmol" "conda install -c conda-forge packmol"

if command -v lmp > /dev/null 2>&1; then good "LAMMPS" "$(command -v lmp)"
elif command -v lmp_serial > /dev/null 2>&1; then good "LAMMPS" "$(command -v lmp_serial)"
elif command -v lmp_mpi > /dev/null 2>&1; then good "LAMMPS" "$(command -v lmp_mpi)"
else fail "LAMMPS" "conda install -c conda-forge lammps"; fi

command -v python3 > /dev/null 2>&1 && good "python3" "$(python3 --version 2>&1)" \
    || fail "python3" "conda install python"

echo
echo "PYTHON PACKAGES (needed by analyze.py)"
python3 -c "import numpy"      2>/dev/null && good "numpy" "" || fail "numpy" "pip install numpy"
python3 -c "import matplotlib" 2>/dev/null && good "matplotlib" "" || fail "matplotlib" "pip install matplotlib"

echo
echo "YOUR FILES"
for d in molecules forcefield scripts systems; do
    [ -d "$HERE/$d" ] && good "folder $d" "$(ls "$HERE/$d" | wc -l) files" \
                      || fail "folder $d" "this folder is missing"
done
[ -f "$HERE/forcefield/reneu.ff" ] && good "reneu.ff" "" || fail "reneu.ff" ""
n=$(ls "$HERE/systems" 2>/dev/null | wc -l)
[ "$n" -eq 7 ] && good "your 7 systems" "" || fail "your 7 systems" "found $n, expected 7"

echo
echo "CPU"
NP=$( (command -v nproc > /dev/null && nproc) || echo 1 )
say "cores available" "$NP"
command -v mpirun > /dev/null 2>&1 && say "mpirun" "found, runs will use $NP cores" \
                                   || say "mpirun" "not found, runs will use 1 core (slower but fine)"

echo
echo "============================================================"
if [ "$bad" -eq 0 ]; then
    echo " Everything is in place. Start with:"
    echo "   bash scripts/run_stage1.sh $(ls "$HERE/systems" | head -1) --quick"
else
    echo " $bad thing(s) missing. Fix those first, using the command shown"
    echo " next to each one, then run this check again."
fi
echo "============================================================"
