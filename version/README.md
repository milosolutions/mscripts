versions {#versions}

[TOC]
# Deployment

When not added with project template in installer:
* Include version.pri to your project.

# Scripts

| Name | Discription | Run directory |
| - | - | - |
| bumpVersion.sh | Shell script. Change project version in [version.cpp, .doxyfile, .plist, .nsi, .rc, AndroidManifest.xml] files. Additional options: commit, search and increment revision, save git SHA to source file. | Project directory |
| bumpVersion.bat | Batch script. Change project version in [version.cpp, .doxyfile, .plist, .nsi, .rc, AndroidManifest.xml] files. Additional options: commit, search and increment revision, save git SHA to source file. | Project directory |
| version.sh | Shell script. Save git SHA to source file. Usage: ./version.sh | Project directory |
| version.bat | Batch script. Save git SHA to source file. Usage: version.bat | Project directory |
| replaceString.ps1 | Powershell script. Helper script, replace string in file. Usage: replaceString.ps1 FILENAME REGEX REPLACE_STRING | Any |
| incrementVersion.ps1 | Powershell script. Helper script, search revision, increment it and save into new_version.txt. Usage: incrementVersion.ps1 FILENAME | Any |
