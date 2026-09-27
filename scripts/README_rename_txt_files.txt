If you received these scripts by email, the .py files may have been
stripped and only the .py.txt copies survived. Rename them back with:

    cd scripts
    for f in *.py.txt; do mv "$f" "${f%.txt}"; done

Then run: bash scripts/check_setup.sh
