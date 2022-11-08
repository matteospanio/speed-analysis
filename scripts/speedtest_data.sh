#!/bin/env bash
#
# File:   speedtest_data.sh
# Author: Matteo Spanio <matteo.spanio97@gmail.com>
#
# This script generates current internet speed stats
# It accepts the format output argument `csv` or `json`

# global variables
OPTIND=1
VERSION="0.1.0"
PRG_NAME="$(basename $0)"

function show_help() {
    printf "Usage: %s [OPTIONS]\n" "$PRG_NAME"
    printf "\n"
    printf "Options:\n"
    printf "\t-o <OUTFILE>\tThe output file name\n"
    printf "\t-f <FORMAT>\tThe output format\n"
    printf "\t-h\t\tPrint help information\n"
    printf "\t-v\t\tPrint version information\n"
}

# parse arguments
while getopts "hf:vo:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
        ;;
        v)
            printf "%s v$VERSION\n" "$PRG_NAME"
            exit 0
        ;;
        f)
            FORMAT="$OPTARG"
        ;;
        o)
            OUTPUT="$OPTARG"
        ;;
        *)
            show_help
            exit 1
        ;;
    esac
done

DATE=$(date --iso-860=ns -u | sed 's/,/./' | sed -e 's/[0-9]\{3\}+[0-9]\{2\}:[0-9]\{2\}$/Z/')
OUT_FILE="$OUTPUT.$FORMAT"
STATS=$(speedtest-cli --"$FORMAT")

# if occurs an error while running the speedtest output it
if [[ "$?" -ne 0 ]]; then
    if [[ -n "$OUTPUT" ]]; then
        # fmt: Server ID,Sponsor,Server Name,Timestamp,Distance,Ping,Download,Upload,Share,IP Address
        echo ",,,$DATE,,,0,0,," >> "$OUT_FILE"
        exit 0
    fi
    echo "$STATS"
    exit 1
fi

case "$FORMAT" in
    "csv")
        if [[ -n "$OUTPUT" ]]; then
            if [[ ! -f "$OUT_FILE" || ! -s "$OUT_FILE" ]]; then
                speedtest-cli --csv-header >> "$OUT_FILE"
            fi
            echo "$STATS" >> "$OUT_FILE"
        else
            echo "$STATS"
        fi
    ;;
    "json")
        RESULT=$(echo "$STATS" | jq)
        if [[ -n "$OUTPUT" ]]; then
            printf "%s,\n" "$RESULT" >> "$OUT_FILE"
        else
            echo "$RESULT"
        fi
    ;;
    *)
        speedtest-cli
        exit $?
    ;;
esac

exit 0
