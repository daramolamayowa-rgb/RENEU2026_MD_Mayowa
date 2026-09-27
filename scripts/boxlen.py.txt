#!/usr/bin/env python3
"""
boxlen.py - cubic box edge (A) for a given composition and target MASS density.

    python3 boxlen.py <ff file> <rho g/cm3> n1 file1.zmat [n2 file2.zmat ...]

fftool's own --rho option is a MOLAR concentration (mol/L), which is easy to get
wrong and was the cause of the collapsed, 1.5 %-density box in the first RENEU
runs. This helper works in g/cm3, the density you can actually look up, and
prints the --box value to hand to fftool.
"""
import sys, math

NA = 6.02214076e23


def masses(fffile):
    m, sec = {}, None
    for line in open(fffile):
        line = line.split('#')[0].strip()
        if not line:
            continue
        if line in ('ATOMS', 'BONDS', 'ANGLES', 'DIHEDRALS', 'IMPROPER'):
            sec = line
            continue
        if sec == 'ATOMS':
            t = line.split()
            if len(t) >= 4:
                m[t[0]] = float(t[2])
    return m


def ff_of(zmat):
    """The force-field file named on the last non-empty line of a .zmat."""
    lines = [l.strip() for l in open(zmat) if l.strip()]
    return lines[-1] if lines and lines[-1].endswith('.ff') else None


def atom_types(zmat):
    """Atom type names from a .zmat, with or without the leading index column."""
    raw = [l.rstrip() for l in open(zmat)]
    # skip the title line and the blank line after it
    i = 1
    while i < len(raw) and not raw[i].strip():
        i += 1
    types = []
    for l in raw[i:]:
        t = l.split()
        if not t:
            break
        if t[0].endswith('.ff'):
            break
        types.append(t[1] if t[0].isdigit() and len(t) > 1 else t[0])
    return types


def molar_mass(zmat, m):
    tot = 0.0
    for ty in atom_types(zmat):
        if ty not in m:
            raise SystemExit(f'atom type {ty} in {zmat} is not in any force field '
                             f'that was loaded. Check the last line of {zmat}.')
        tot += m[ty]
    return tot


if __name__ == '__main__':
    ff, rho = sys.argv[1], float(sys.argv[2])
    args = sys.argv[3:]
    import os
    m = masses(ff)
    for i in range(1, len(args), 2):                 # merge in each molecule's own ff
        extra = ff_of(args[i])
        if extra:
            path = os.path.join(os.path.dirname(os.path.abspath(args[i])), extra)
            if os.path.exists(path):
                m.update(masses(path))
    total = 0.0
    parts = []
    for i in range(0, len(args), 2):
        n, f = int(args[i]), args[i + 1]
        mm = molar_mass(f, m)
        total += n * mm
        parts.append(f'{n} x {f} ({mm:.2f} g/mol)')
    vol_cm3 = total / NA / rho
    L = vol_cm3 ** (1 / 3) * 1e8
    print(f'{L:.2f}')
    print(f'# {" + ".join(parts)} = {total:.1f} g/mol at {rho} g/cm3 '
          f'-> cubic box {L:.2f} A', file=sys.stderr)
