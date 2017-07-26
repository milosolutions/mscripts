# Template increment version script file from Milo Solutions. Copyright 2016.
#
# Load version number from file, increment it and save to text file.
# Usage: incrementVersion.ps1 FILE_NAME
#
param([string]$fileName)
if([string](Get-Content -path $fileName) -match '([0-9]+\.*)+')
{
	$VERSION = $matches[0]
	$tokens = $VERSION.Split(".")
	
	For ($i = $tokens.count - 1; $i -ge 0; $i--) {
		$val = [int] $tokens[$i]
		$length_before = [string] $val
		$length_before = $length_before.Length
		
		$val++
		
		$length_after = [string] $val
		$length_after = $length_after.Length
		
		if ($length_after -gt $length_before -And $i -gt 0)
		{
			$tokens[$i] = 0
		}
		else
		{
			$tokens[$i] = $val
			break
		}
    }	
	
	$VERSION = $tokens -join "."
	
	$VERSION | Out-File new_version.txt
	
}