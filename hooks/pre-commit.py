#!/usr/bin/env python3
import os
import subprocess
class ClangFormatter:
    def run(self):
        diff = subprocess.check_output(["git", "clang-format-4.0", "--diff"], universal_newlines=True)
        if diff not in ['no modified files to format\n', 'clang-format did not modify any files\n']:
            print(diff)
            print("Run git clang-format or use Beautifier plugin, then commit.\n")
            exit(1)
        else:
            exit(0)
# main
if __name__ == "__main__":
    app = ClangFormatter()
    app.run()
