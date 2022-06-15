#!/bin/bash -i

echo Starting download
/usr/bin/aria2c -q --allow-overwrite=true --continue=true --file-allocation=none --log-level=error --max-tries=2 --max-connection-per-server=16 --max-file-not-found=5 --min-split-size=1M --no-conf --remote-time=true --summary-interval=0 --timeout=3 --on-download-complete="/usr/bin/echo 'Completed downloading $3'" --on-download-error="/usr/bin/echo 'Error downloading $3'" --on-download-start="/usr/bin/echo 'Started downloading $3'" --dir=/ --out %o %u

