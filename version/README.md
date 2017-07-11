# Deployment

When not added with project template in installer:
* Include version.pri to your project.
* Add version.cpp to your .gitignore.

# Scripts

| Name | Discription | Run directory |
| - | - | - |
| bumpVersion.sh | Shell script. Change project version in .pro, .doxyfile, .plist, .nsi, .rc, AndroidManifest.xml files. Additional options: commit, save git SHA to source file. | Project directory |
| bumpVersion.bat | Batch script. Change project version in .pro, .doxyfile, .plist, .nsi, .rc, AndroidManifest.xml files. Additional options: commit, save git SHA to source file. | Project directory |
| version.sh | Shell script. Save git SHA to source file. Usage: ./version.sh | Project directory |
| version.bat | Batch script. Save git SHA to source file. Usage: version.bat | Project directory |
| replaceString.ps1 | Powershell script. Helper script, replace string in file. Usage: replaceString FILENAME REGEX REPLACE_STRING | Any |
