Function fMain {
trap {"Error found: $_" | Out-File "x:\SearchAndApply.log"}

	Write-Output "Beginning to search for .WIM file..."
	$oWimFiles = Get-WmiObject -Query "SELECT * From Win32_LogicalDisk" | `
		Where-Object { $_.DriveType -ne "5" } | `
		foreach { Get-ChildItem -Force -Path @($_.DeviceID + "\") } | `
		Where-Object { ($_.FullName -Like "*.wim") -and ($_.Length -ge 1000000000) } | `
		Sort-Object -Descending LastWriteTime

	If ($oWimFiles -eq $null) {Write-Output "No .WIM files found..."; Exit}
	Write-Output @("Image will be applied: " + $oWimFiles[0].FullName)

	Write-Output "Beginning to clean and format disk..."
	$Disk = Get-Disk -Number 0 | Where-Object { $_.Size -gt 100000000000 }
	If ($Disk -eq $null) {Write-Output "Local Disk is not found..."; Exit}

	Clear-Disk -Number $Disk.Number -RemoveData -Confirm:$false | Out-Null
	Set-Disk -InputObject $Disk -IsOffline $false | Out-Null
	Initialize-Disk -InputObject $Disk | Out-Null
	Set-Disk -InputObject $Disk -PartitionStyle MBR | Out-Null
	New-Partition $Disk.Number -UseMaximumSize -DriveLetter C | Out-Null
	Write-Output "Formatting disk..."
	Format-Volume -DriveLetter C -FileSystem NTFS -NewFileSystemLabel OSDISK -Confirm:$false -Force | Out-Null
	Set-Partition $Disk.Number -PartitionNumber 1 -IsActive $True | Out-Null

	Start-Process "x:\windows\system32\cmd.exe" @('/C "imagex /apply "' + `
		$oWimFiles[0].FullName + '" 1 C:"') -Wait -WindowStyle Maximized | Out-Null

	Write-Output @("Image is applied(" + $oWimFiles[0].Name + ":" + $LastExitCode + ")...")

	If (Test-Path "C:\boot.ini") {
		Start-Process "x:\windows\system32\cmd.exe" @('/C "bootsect.exe /nt52 C: /force"') -Wait | Out-Null
	} else {
		Start-Process "x:\windows\system32\cmd.exe" @('/C "bcdboot c:\windows"') -Wait | Out-Null
		Start-Process "x:\windows\system32\cmd.exe" @('/C "bcdedit /store C:\Boot\BCD /timeout 0"') -Wait | Out-Null
	}
	
	Write-Output @("Boot sector is prepped... Shutting down in 5 seconds...")
	
	Sleep -Milliseconds 5000
	If (Test-Path "C:\Windows") {
		Start-Process "x:\windows\system32\wpeutil.exe" @('"shutdown"')
	} else {
		Write-Output @("ImageX did not apply image successfully.... Shutting down in 5 seconds...")
		"ImageX did not apply image successfully." | Out-File "x:\SearchAndApplyError.log"
		Exit
	}
}
fMain

<#If ((Get-WmiObject -Query "SELECT * FROM Win32_LogicalDiskToPartition" | `
	Where-Object{ $_.Antecedent -Match "Disk \#0"}).Dependent -Match "[A-Z]:" -eq "True")
	{$sTargetDriveLetter = $Matches[0]} else {}#>
