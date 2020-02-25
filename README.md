MScripts
===

[Online documentation](https://docs.milosolutions.com/milo-code-db/mscripts)

[Source code](https://github.com/milosolutions/mscripts)

# Description

This repository contains example/ template scripts that can help when setting up project.

Feel free to use them - well tested are ones located in "version", "hooks", "others", "mobile" folders.

# Scripts

## Version

Please read [version/versionReadme.md](\ref versions)

## Hooks

| Name | Discription | Run directory |
| - | - | - |
| mgit-hooks-installer.py | Python script. Install pre-commit hook in git folder. | Project directory |
| mclang-format.py | Python script. Called by installed hook. Checks formatting in changed code. | - |
| mclang-tidy.py | Python script. Called by installed hook. Checks for compilation errors. | - |

For a tutorial on how to use these hooks, see the [documentation](\ref githooks)

To quickly enable/ disable a git hook, you can use disableGitHook and enableGitHook
scripts from sierdzio's bash [scripts](https://github.com/sierdzio/sierdzios-bash-scripts).

## Mobile

| Name | Discription | Run directory |
| - | - | - |
| build_android_package.sh | Shell script. Build Android .APK package from Qt project. | any |
| build_ios_package.sh | Shell script. Build iOS package from Qt project. | any |

## Seafile

Seafile scripts were moved to [milo-qtcreator-wizard]("https://docs.milosolutions.com/milo-code-db/milo-qtcreator-wizard/")

## Others

| Name | Discription | Run directory |
| - | - | - |
| mattermost-notification.sh | Shell script. Send info message on Mattermost. Assigned to hook. | Any |

# License

This project is licensed under the MIT License - see the LICENSE-MiloCodeDB.txt file for details
