rem *** prepare_env.sh assumes project's root as working directory ***
set platform=%1
set channel=%2

bash ssconda\prepare_env.sh %platform% %channel%
set env_dir=%CD%\build\conda\%platform%
set deploy_dir=%env_dir%\Lib\site-packages
echo off
set PATH=%env_dir%;%env_dir%\Scripts;%PATH%
echo on
