#!/bin/bash
now=$(date +%b" "%d" "%Y)
sed -i "s/update was.*(/update was $now (/" index.md
