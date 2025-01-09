# TEST Script to clear SoftwareDistribution folder which is stopping updates.
# Download file names are too long for Powershell to remove so need to use RoboCopy for this one folder
try {
    # Create (temporary) empty folder
    New-Item -ItemType Directory -Path ".\Empty" -ErrorAction SilentlyContinue
    # Mirror the empty directory to the folder to delete; this will effectively empty the folder.
    robocopy /MIR ".\Empty" "$env:SystemRoot\SoftwareDistribution\Download" /njh /njs /ndl /nc /ns /np /nfl #>nul 2>&1
    # Delete the folder now that it's empty
    Remove-Item "$env:SystemRoot\SoftwareDistribution\Download" -Force
    # Delete our temporary empty folder
    Remove-Item ".\Empty" -Force
}
catch {
    Write-Error $_
}

#Then remove all the other folders
Write-Verbose 'Clearing SoftwareDistribution\Download folder...'
Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\*" -Force -Verbose -Confirm:$false -Recurse -ErrorAction 'SilentlyContinue' -WarningAction 'SilentlyContinue'