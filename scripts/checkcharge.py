#!/usr/bin/env python3
"""checkcharge.py - stop the pipeline if the simulation box is not neutral."""
import re, sys
tot, rows = 0.0, []
for line in open(sys.argv[1]):
    t = line.split()
    if len(t) >= 8 and re.match(r'^[+-]?\d+\.\d+$', t[-1]):
        try:
            n = int(t[2])
        except ValueError:
            continue
        q = float(t[-1])
        rows.append((t[1], n, q))
        tot += n * q
for name, n, q in rows:
    ok = "ok" if abs(q - round(q)) < 1e-6 else "NOT AN INTEGER"
    print(f"    {n:>5d} x {name:<20s} {q:+.4f} e   {ok}")
print(f"    net charge of the whole box = {tot:+.4f} e")
if abs(tot) > 1e-6:
    print("    STOP. The box is not neutral, so LAMMPS cannot run PPPM and every")
    print("    electrostatic force in the run would be wrong. Check the numbers of")
    print("    cations and anions above. Do not 'just try it and see'.")
    sys.exit(1)
print("    OK, the box is neutral.")
