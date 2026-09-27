# =============================================================================
#  env.sh  -  finds the three programs the pipeline needs.
#  Sourced by every run_stage*.sh. You should not need to edit it, but if you
#  installed something in an unusual place, set the variable here.
# =============================================================================

# fftool: either on your PATH, or cloned into ~/pilmd_tools/fftool
if command -v fftool > /dev/null 2>&1; then
    FFTOOL="fftool"
elif [ -x "$HOME/pilmd_tools/fftool/fftool" ]; then
    FFTOOL="python3 $HOME/pilmd_tools/fftool/fftool"
elif [ -x "$HOME/fftool/fftool" ]; then
    FFTOOL="python3 $HOME/fftool/fftool"
else
    echo "ERROR: fftool not found."
    echo "  Clone it with:  git clone https://github.com/paduagroup/fftool ~/pilmd_tools/fftool"
    echo "  then run this script again."
    exit 1
fi

for prog in packmol; do
    command -v $prog > /dev/null 2>&1 || {
        echo "ERROR: $prog not found. See the setup guide, section B."; exit 1; }
done

if command -v lmp > /dev/null 2>&1;        then LMP="lmp"
elif command -v lmp_serial > /dev/null 2>&1; then LMP="lmp_serial"
elif command -v lmp_mpi > /dev/null 2>&1;    then LMP="lmp_mpi"
else
    echo "ERROR: LAMMPS not found (looked for lmp, lmp_serial, lmp_mpi)."
    echo "  See the setup guide, section B."; exit 1
fi

# How many MPI ranks to use.
#
# These boxes are small: about 29 A after the NPT run has compressed them. LAMMPS
# splits the box between ranks, and each rank's slice has to stay comfortably
# larger than the ghost region (real-space cutoff + neighbour skin = 12 A here).
# With too many ranks a slice becomes thinner than that as the box shrinks, and
# PPPM fails partway through an otherwise healthy run with
# "Out of range atoms - cannot compute PPPM". Capping at 4 keeps every slice at
# least 14 A wide for every system in this bundle.
MAXRANKS=4
NPROC=$( (command -v nproc > /dev/null && nproc) || echo 1 )
[ "$NPROC" -gt "$MAXRANKS" ] && NPROC=$MAXRANKS
if command -v mpirun > /dev/null 2>&1 && [ "$NPROC" -gt 1 ]; then
    LMPRUN="mpirun -np $NPROC $LMP"
else
    LMPRUN="$LMP"
fi
