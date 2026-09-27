# Example output - what a finished analysis folder looks like

These files came from a real run of **M1 butylammonium octanoate, Stage 1**, using
the same scripts you have. They are here so you can see the shape of the output
before you have produced any of your own.

**This is a `--quick` run, so it is a pipeline test and not a result.** The
give-away is in `summary.md`: the density has not finished rising, because a
ten-picosecond run does not give the box time to reach its equilibrium volume.
Your real runs, without `--quick`, will show a density that is flat over the last
third of `density.dat`. Do not copy any number out of this folder into a slide.

What each file is:

| File | What it holds |
|---|---|
| `summary.md` | the tables you read first, including the plan checks |
| `coordination_numbers.csv` | first peak, first minimum and coordination number for every pair |
| `rdf_*.csv` | r, g(r) and the running coordination number, one row per bin |
| `fig_rdf_*.png` | the figure for each pair, first-peak and first-minimum marked |
| `fftool_charges.txt` | the charge check that let this run start |

Every number in `summary.md` can be traced to one of the CSV files, and every
figure has the CSV that produced it sitting beside it. That is the standard your
own results have to meet.
