$ProgressPreference = 'SilentlyContinue'
$SdkPath = "D:\android"
$Url = "https://dl.google.com/android/repository/commandlinetools-win-11479570_latest.zip"
$Zip = "$SdkPath\cmdline-tools.zip"

Write-Output "Downloading cmdline-tools..."
Invoke-WebRequest -Uri $Url -OutFile $Zip

Write-Output "Extracting..."
Expand-Archive -Path $Zip -DestinationPath "$SdkPath\temp-cmdline" -Force

Write-Output "Organizing directories..."
$TargetDir = "$SdkPath\cmdline-tools\latest"
if (Test-Path $TargetDir) { Remove-Item -Path $TargetDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path "$SdkPath\cmdline-tools" | Out-Null
Rename-Item -Path "$SdkPath\temp-cmdline\cmdline-tools" -NewName "latest"
Move-Item -Path "$SdkPath\temp-cmdline\latest" -Destination "$SdkPath\cmdline-tools\"
Remove-Item -Path "$SdkPath\temp-cmdline" -Recurse -Force
Remove-Item -Path $Zip

Write-Output "Done!"
