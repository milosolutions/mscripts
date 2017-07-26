# Template replace string script file from Milo Solutions. Copyright 2016.
#
# Replace all string occurences in file.
# Usage: replaceString.ps1 FILE_NAME SEARCH_STRING REPLACE_STRING
#

param([string]$fileName, [string]$searchString, [string]$replaceString);
Get-Content -path $fileName | % { $_ -Replace $searchString, $replaceString } |  Out-File $fileName".tmp";