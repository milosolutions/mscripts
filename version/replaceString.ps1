param([string]$fileName, [string]$searchString, [string]$replaceString);
Get-Content -path $fileName | % { $_ -Replace $searchString, $replaceString } |  Out-File $fileName"_tmp";