\anchor milodatabaseciscripts 

Milo Code DB main ([online](https://qtdocs.milosolutions.com/milo-code-db/main/) | [offline](\ref milodatabasemain)) 

This repository contains example/ template scripts that can help when setting up project.

Feel free to use them - well tested are ones located in "version", "hooks", "others", "mobile" folders.

# Scripts # {#scripts} 

### Version

Please read [version/README] (version/README.md)

### Hooks

| Name | Discription | Run directory |
| - | - | - |
| installHooks.sh | Shell script. Install pre-commit hook which checks code formatting. | Any |

### Mobile

| Name | Discription | Run directory |
| - | - | - |
| build_android_package.sh | Shell script. Build Android .APK package from Qt project. | any |
| build_ios_package.sh | Shell script. Build iOS package from Qt project. | any |

### Seafile

| Name | Discription | Run directory |
| - | - | - |
| upload_to_seafile.sh | Shell script. Upload file to seafile server. | any |
| upload_to_seafile.ps1 | Powershell script. Upload file to seafile server. | any |

### Others

| Name | Discription | Run directory |
| - | - | - |
| mattermost-notification.sh | Shell script. Send info message on Mattermost. Assigned to hook. | Any |

# License # {#license} 

This project is licensed under the MIT License - see the LICENSE-MiloCodeDB.txt file for details