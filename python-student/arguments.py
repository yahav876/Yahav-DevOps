#!/usr/bin/python3
import argparse

# Build the parser

parser = argparse.ArgumentParser(description='Read a file in reverse')
parser.add_argument('filename', help='the file to read')
parser.add_argument('--limit', '-l', type=int, help='The number of lines to read')
parser.add_argument('--version', '-v', action='version',  version='%(prog)s 1.0')


# Parse the arguments
args = parser.parse_args()

with open(args.filename) as f:
    lines = f.readlines()
    lines.reverse()

    if args.limit:
        lines = lines[:args.limit]

    for line in lines:
        print(line.strip()[::-1])


# Read the file, reverse the contents and print

