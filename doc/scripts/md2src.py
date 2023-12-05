#!/bin/python

import sys

if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit("usage: md2src [input.md] [output.*]")

    with open(sys.argv[1], "r", encoding="utf-8") as infile, open(sys.argv[2], "w", encoding="utf-8") as outfile:
        while line := infile.readline():
            if "```" in line:
                indent = line.count(" ", 0, line.find("```"))
                while code := infile.readline():
                    if "```" in code:
                        break
                    if "\n" == code:
                        print("", file=outfile)
                    print(code[indent:], end="", file=outfile)
                print("", file=outfile)
