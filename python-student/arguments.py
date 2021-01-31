#!/usr/bin/python3
import argparse
import sys
# Build the parser

parser = argparse.ArgumentParser(description='Read a file in reverse')
parser.add_argument('filename', help='the file to read')
parser.add_argument('--limit', '-l', type=int, help='The number of lines to read')
parser.add_argument('--version', '-v', action='version',  version='%(prog)s 1.0')


# Parse the arguments
args = parser.parse_args()

try:
    f = open(args.filename)
    limit = args.limit
except FileNotFoundError as err:
    print(f"Error: {err}")
    sys.exit(1) # Change the exit status from 0 to 1
else:
    with f:
        lines = f.readlines()
        lines.reverse()

        if args.limit:
            lines = lines[:args.limit]

# Read the file, reverse the contents and print
        for line in lines:
            print(line.strip()[::-1])

# Anyway finally will be printed (with or without err)
finally:
    print('Finally')




