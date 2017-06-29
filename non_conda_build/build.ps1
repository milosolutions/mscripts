#---------------------------------------
#
#  MILO @ 2016
#  build.ps1 script for Milo Code Database
#  
#  Description:
#    This script is intended to run only on windows.
#    Script should be run only from main directory of repository
#
#  Usage:
#    build.ps1 qmake make proFile releaseDir packageDir
#
#    qmake      - path to qmake [ default = C:\Tools\Qt-OpenSource\5.7\mingw53_32\bin\qmake ]
#    make       - path to make  [ default = C:\Tools\Qt-OpenSource\Tools\mingw530_32\bin\mingw32-make ]
#    proFile    - path to qtcreator project file
#    releaseDir - path where exe was generated [ default = build\bin ]
#    packageDir - path to folder where generated exe will be moved 
#
#  Dependency:
#    qmake      - > https://wiki.milosolutions.com/index.php/Gitlab_CI_runners#Windows_.231
#    make       - > https://wiki.milosolutions.com/index.php/Gitlab_CI_runners#Windows_.231
#
#---------------------------------------
[CmdletBinding(PositionalBinding=$false)]
param(
    [Parameter(Mandatory=$false)]
    [string]$qmake,
    [Parameter(Mandatory=$false)]
    [string]$make,
    [Parameter(Mandatory=$true)]
    [string]$proFile,
    [Parameter(Mandatory=$false)]
    [string]$releaseDir,
    [Parameter(Mandatory=$true)]
    [string]$packageDir
)

class ScriptArgs {
    static [void] validate() {
        # check if $proFile exists
        if( !(Test-Path $script:proFile) ) {
            Write-Host "Cannot find file: $script:proFile" -foreground red
            exit
        }
    }
}

class Builder {
    [string] $qmake = "C:\Tools\Qt-OpenSource\5.7\mingw53_32\bin\qmake";
    [string] $make  = "C:\Tools\Qt-OpenSource\Tools\mingw530_32\bin\mingw32-make";
    [string] $proFile;
    [string] $releaseDir = "build\bin";
    [string] $packageDir;

    Builder([string] $qmake, [string] $make, [string] $proFile, [string] $releaseDir, [string] $packageDir) {
        # if option is set - overwrite default value, otherwise use default
        if( ![string]::IsNullOrEmpty( $qmake )) {    
            $this.qmake = $qmake;
        }
        if( ![string]::IsNullOrEmpty( $make )) {
            $this.make = $make;
        }
        if( ![string]::IsNullOrEmpty( $releaseDir )) {
            $this.releaseDir = $releaseDir;
        }
        
        # required values
        $this.proFile    = $proFile;
        $this.packageDir = $packageDir;
        
        # retrieve path to compiler bin directory
        $compilerBinPath = Split-Path -Path $this.make
        
        # need to avoid conflicts with other binaries in the PATH
        [Environment]::SetEnvironmentVariable( "Path", "C:\Windows\System32;" + $compilerBinPath, 
                                               [System.EnvironmentVariableTarget]::Process );
    }

    # create package dir ( should be outside repo )
    [void] createPackageDir() {
        if( ( Test-Path $this.packageDir )) {
            rmdir -Recurse -Force $this.packageDir;
        }
        mkdir $this.packageDir;
        Write-Host $this.packageDir "directory was created"
    }

    [void] run() {
        $this.createPackageDir();
        
        Write-Host "run qmake..."
        # run qmake
        & $this.qmake $this.proFile;
        
        Write-Host "run make..."
        # run make
        & $this.make -j4

        # move binary to package directory (replace if exist)
        mv  $this.releaseDir -Destination $this.packageDir -Force
    
        Write-Host "binary was moved to" $this.packageDir "directory";
    }
}

function main() {
    
    # validate script args
    [ScriptArgs]::validate();
    
    # run builder with script args
    [Builder]::new($qmake,$make,$proFile,$releaseDir,$packageDir).run();
}

# main
main;