#!/bin/python

import os
import stat
import sys

if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit("usage: md2src [input.md] [output.*]")

    with open(sys.argv[1], "r", encoding="utf-8") as infile, open(sys.argv[2], "w", encoding="utf-8", newline="\n") as outfile:
        while line := infile.readline():
            if "```" in line:
                indent = line.count(" ", 0, line.find("```"))

                while code := infile.readline():
                    if "```" in code:
                        break

                    if "\n" == code:
                        print("", file=outfile, end="")

                    print(code[indent:], end="", file=outfile)

                print("", file=outfile)

        st = os.stat(sys.argv[2])
        os.chmod(sys.argv[2], st.st_mode | stat.S_IEXEC)
