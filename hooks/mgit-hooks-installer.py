#!/usr/bin/env python3
import os
import stat

PRE_COMMIT_HOOK_CONTENT = """#!/usr/bin/env python3
import sys
import subprocess

res = subprocess.call(["python3", "./milo/mscripts/hooks/mclang-format.py"])
if res is 0:
    res = subprocess.call(["python3", "./milo/mscripts/hooks/mclang-tidy.py"])
sys.exit(res)
"""

class GitHooksInstaller:
    def run(self):
        os.chdir(".git/hooks")
        
        # create 'pre-commit' file and write content of hook
        with open("pre-commit","w") as pre_commit_hook:
            pre_commit_hook.write(PRE_COMMIT_HOOK_CONTENT)
            
        # make it exec, see -> https://stackoverflow.com/questions/12791997/how-do-you-do-a-simple-chmod-x-from-within-python
        st = os.stat("pre-commit")
        os.chmod("pre-commit", st.st_mode | stat.S_IEXEC)
        
        print("pre-commit hook has been installed\n")
        print("Please update API-TOKEN and GIT_URL variables in 'mclang-format.py' and 'mclang-tidy.py' files before using!")

# main
if __name__ == "__main__":
    app = GitHooksInstaller()
    app.run()
