#Version of CFH2 Script
# =1

# Set base path to prefix all installation paths.
$6400 = "C:\Admin\Hardware\6400"
$6420 = "C:\Admin\Hardware\6420"
$CFH2 = "C:\Admin\Hardware\CFH2"
$sPath = "C:\Admin\Software"

# Set base bath for Registry uninstallation Paths
$rPathX64 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
$rPathX86 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"

# Get bios information
$B = GWMI Win32_Bios

# Sets the Log Path
$D ="C:\Admin\DriverInstallation.TXT"
$S = "C:\Admin\SoftwareInstallation.TXT"

# Sets Date for Success or Failure
$Date = (Get-Date).ToString("M-d-yy H:mm:ss")

# Version of Script or Image
$Version = "Version 1.1"
# Get the computer manufacturer and model from Win32_ComputerSystem.
$computerSystem = Get-WmiObject win32_computerSystem

# Initiate new Process and ProcessStartInfo objects.
$process = New-Object system.Diagnostics.Process
$si = New-Object System.Diagnostics.ProcessStartInfo

# Define the startProcess function. This function accepts a ProcessStartInfo
# object, launches that process, and waits for its process id to exit before
# returning.
Function startProcess
{
 param ($startInfo)
 Begin 
 {
  Write-Host ""
  Write-Host "Attempting to install" $startInfo.FileName $startInfo.Arguments
 }
 Process
 {
  $process.StartInfo = $startInfo
  $process.Start()
  $processID = $process.Id
  $process.WaitForExit()
 }
 End
 {
  Write-Host ""
 }
}
 

########################################################################################
#   Hardware / Software Installation
########################################################################################

#Stop Symantec AV from running while installing Software
    $SMC = Get-Process smc -erroraction silentlycontinue
    IF($SMC -ne $null)
        {$si.FileName = 'C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\12.1.2015.2015.105\Bin64\Smc.exe'
         $si.Arguments = "-stop"
         startProcess $si
        }

Function PanaSonicCF-H2
{
#Delete Other drivers  
         Remove-item -Recurse -Path C:\Admin\Hardware\* -Exclude CFH2  -Verbose -Force
         
# INTEL Chipset INF  Drivers Injected into OS
   
       
# Intel Management
        IF ((Test-Path -Path "$rPathX86\{09536BA1-E498-4CC3-B834-D884A67D7E34}") -eq $false)
        {
         $si.FileName = $CFH2 + "\drivers\me\Setup.exe"
         $si.Arguments = "-s"
         startProcess $si
         IF ((Test-Path -Path "$rPathX86\{09536BA1-E498-4CC3-B834-D884A67D7E34}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nIntel Management Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nIntel Management Failed $Date"
         Restart-Computer
         }
         }

# USB30
        IF ((Test-Path -Path "$rPathX64\{240C3DDD-C5E9-4029-9DF7-95650D040CF2}") -eq $false)
        {
         $si.FileName = $CFH2 + "\drivers\usb30\SetupUSB3_Dell.exe"
         $si.Arguments = "-s"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\{240C3DDD-C5E9-4029-9DF7-95650D040CF2}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nUSB30 Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nUSB30 Failed $Date"
         Restart-Computer
         }
         }
         
# Intel HD Graphics
        IF ((Test-Path -Path "$rPathX64\{F0E3AD40-2BBD-4360-9C76-B9AC9A5886EA}") -eq $false)
        {
         $si.FileName = $CFH2 + "\drivers\video\Setup.exe"
         $si.Arguments = "-s"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\{F0E3AD40-2BBD-4360-9C76-B9AC9A5886EA}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nIntel HD Graphics Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nIntel HD Graphics Failed $Date"
         Restart-Computer
         }
         }
                    
# Port Replicator Driver are injected into OS

# Button Driver are injected into OS

# Panasonic Common Components
        IF ((Test-Path -Path "$rPathX64\{F8F836EB-04C1-4E9E-AEFC-D57035C8FC41}") -eq $false)
        {
         $si.FileName = $CFH2 +"\pcommon\setup.exe"
         $si.Arguments = "/S /v/qn"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\{F8F836EB-04C1-4E9E-AEFC-D57035C8FC41}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nPanasonic Common Components Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nPanasonic Common Components Failed $Date"
         Restart-Computer
         }
         }

# Panasonic Common Components x64
        IF ((Test-Path -Path "$rPathX64\{C5AF5C30-9A05-4A31-AE65-09D8618289FF}") -eq $false)
        {
         $si.FileName = $CFH2 + "\pcomn64\setup.exe"
         $si.Arguments = "/S /v/qn"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\{C5AF5C30-9A05-4A31-AE65-09D8618289FF}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nPanasonic Common Components x64 Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nPanasonic Common Components x64 Failed $Date"
         Restart-Computer
         }
         }
# PanaSonic NewMisc Drivers are injected into OS
                      
# Sound Driver
        IF ((Test-Path -Path "$rPathX64\{F132AF7F-7BCA-4EDE-8A7C-958108FE7DBC}") -eq $false)
        {
         $si.FileName = $CFH2 + "\drivers\sound\Setup.exe"
         $si.Arguments = "-s"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\{F132AF7F-7BCA-4EDE-8A7C-958108FE7DBC}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nSound Driver Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nSound Driver Failed $Date"
         Restart-Computer
         }
         }
# USB-Serial Driver are Injected into OS

# 2nd LAN Driver are Injected into OS
                
# BlueTooth
        IF ((Test-Path -Path "$rPathX86\{CEBB6BFB-D708-4F99-A633-BC2600E01EF6}") -eq $false)
        {
         $si.FileName = $CFH2 + "\drivers\bluet\Setup.exe"
         $si.Arguments = "/S /v/qn"
         startProcess $si
         IF ((Test-Path -Path "$rPathX86\{CEBB6BFB-D708-4F99-A633-BC2600E01EF6}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nBlueTooth Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nBlueTooth Failed $Date"
         Restart-Computer
         }
         }          
         
#Application Button
        IF ((Test-Path -Path "$rPathX64\{28F5AA9E-5ED6-4EAB-8718-E4DC5AE77081}") -eq $false)
        {
         $si.FileName = $CFH2 + "\appbtn\setup.exe"
         $si.Arguments = "/S /v/qn"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\{28F5AA9E-5ED6-4EAB-8718-E4DC5AE77081}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nApplication Button Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nApplication Button Failed $Date"
         Restart-Computer
         }
         }
         
# Battery Recalibration    RECOMMENDED
#        IF ((Test-Path -Path "$rPathX64\{CD5C2205-7BAD-4B87-BF9A-2BAC626B29C8}") -eq $false)
#        {
#         $si.FileName = $CFH2 + "\brecal\setup.exe"
#         $si.Arguments = "/S /v/qn"
#         startProcess $si
#         IF ((Test-Path -Path "$rPathX64\{CD5C2205-7BAD-4B87-BF9A-2BAC626B29C8}") -eq $True)
#         {Add-Content C:\Admin\DriverInstallation.TXT "`nBattery Recalibration Installed $Date"}
#         Else
#         {Add-Content C:\Admin\DriverInstallation.TXT "`nBattery Recalibration Failed $Date"
#         Restart-Computer
#         }
#         }         

# Calibration Utility   RECOMMENDED
        IF ((Test-Path -Path "$rPathX64\{6BE9D212-A9AB-42DD-BA37-71D1299ED319}") -eq $false)
        {
         $si.FileName = $CFH2 + "\calibutl\setup.exe"
         $si.Arguments = "/S /v/qn"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\{6BE9D212-A9AB-42DD-BA37-71D1299ED319}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nCalibration Utility Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nCalibration Utility Failed $Date"
         Restart-Computer
         }
         }
         
# Cleaning utility    RECOMMENDED
#        IF ((Test-Path -Path "$rPathX64\{9B83FD9E-E2C6-42D9-8123-6508DC2185E3}") -eq $false)
#        {
#         $si.FileName = $CFH2 + "\clnutil\setup.exe"
#         $si.Arguments = "/S /v/q"
#         startProcess $si
#         IF ((Test-Path -Path "$rPathX64\{9B83FD9E-E2C6-42D9-8123-6508DC2185E3}") -eq $True)
#         {Add-Content C:\Admin\DriverInstallation.TXT "`nCleaning utility Installed $Date"}
#         Else
#         {Add-Content C:\Admin\DriverInstallation.TXT "`nCleaning utility Failed $Date"
#         Restart-Computer
#         }
#         }         
                                                                                 
# Device information Library X64/86 Drivers are Injected in OS

# Display Switch
        IF ((Test-Path -Path "$rPathX64\{7A263B09-0EE9-415E-A704-4F13864CBB00}") -eq $false)
        {
         $si.FileName = $CFH2 + "\dspswth2\setup.exe"
         $si.Arguments = "/S /v/qn"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\{7A263B09-0EE9-415E-A704-4F13864CBB00}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nDisplay Switch Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nDisplay Switch Failed $Date"
         Restart-Computer
         }
         }
                  
# Hand writing Utility  RECOMMENDED
#        IF ((Test-Path -Path "$rPathX64\{F4CCDC20-7345-4E2C-B744-623B8FE02E16}") -eq $false)
#        {
#         $si.FileName = $CFH2 +"\writing\setup.exe"
#         $si.Arguments = "/S /v/qn"
#         startProcess $si
#         IF ((Test-Path -Path "$rPathX64\{F4CCDC20-7345-4E2C-B744-623B8FE02E16}") -eq $True)
#         {Add-Content C:\Admin\DriverInstallation.TXT "`nHand writing Utility Installed $Date"}
#         Else
#         {Add-Content C:\Admin\DriverInstallation.TXT "`nHand writing Utility Failed $Date"
#         Restart-Computer
#         }
#         }
         
# HotKey Drivers are Injected into OS
         
# Panasonic Dashboard
        IF ((Test-Path -Path "$rPathX64\{5F8F5B2F-91DD-4409-A609-11A23BEAC9DA}") -eq $false)
        {
         $si.FileName = $CFH2 + "\dashbrd\setup.exe"
         $si.Arguments = "/S /v/qn"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\{5F8F5B2F-91DD-4409-A609-11A23BEAC9DA}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nPanasonic Dashboard Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nPanasonic Dashboard Failed $Date"
         Restart-Computer
         }
         }
       
 # Right Click    RECOMMENDED
        IF ((Test-Path -Path "$rPathX64\{0EC869B6-B1FA-4580-8559-88583481C7B1}") -eq $false)
        {
         $si.FileName = $CFH2 + "\rclick\setup.exe"
         $si.Arguments = "/S /v/qn"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\{0EC869B6-B1FA-4580-8559-88583481C7B1}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nRight Click Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nRight Click Failed $Date"
         Restart-Computer
         }
         }        
  
# BarCode Reader Drivers are injected into OS

#GPS Registry Change
        New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Enum\ACPI\PNP0501\a\Device Parameters" -Name "SkipEnumerations" -PropertyType Dword -Value "0xfffffffe" -ErrorAction silentlycontinue

# FingerPrint 
#        IF ((Test-Path -Path "$rPathX86\{343ECC49-09E4-4E4B-88A3-93F03B1E2714}")-eq $false)
#        {
#         $si.FileName = $CFH2 + "\drivers\fngprint\install\64-bit\Setup.exe"
#         $si.Arguments = "/Passive"
#         startProcess $si
#         IF ((Test-Path -Path "$rPathX86\{343ECC49-09E4-4E4B-88A3-93F03B1E2714}") -eq $True)
#         {Add-Content C:\Admin\DriverInstallation.TXT "`nFingerPrint  Installed $Date"}
#         Else
#         {Add-Content C:\Admin\DriverInstallation.TXT "`nFingerPrint Failed $Date"}
#         }

# Lan Driver are injected into OS
#RFID Driver are injected into OS

# 2D BarCode Setting Utility
        IF ((Test-Path -Path "$rPathX64\{F1F089FD-B02E-4AC0-A5A3-B42D32991B90}") -eq $false)
        {
         $si.FileName = $CFH2 + "\bcrh_set\setup.exe"
         $si.Arguments = "/S /v/qn"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\{F1F089FD-B02E-4AC0-A5A3-B42D32991B90}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`n2D BarCode Setting Utility Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`n2D BarCode Setting Utility Failed $Date"
         Restart-Computer
         }
         }
         
# BarCode Configuration Utility
#        IF ((Test-Path -Path "$rPathX64\{7CE610A8-26B0-4E99-A409-7BE9C004928C}") -eq $false)
#       {
#         $si.FileName = $CFH2 + "\bcr_cfg\setup.exe"
#         $si.Arguments = "/S /v/qn"
#         startProcess $si
#         IF ((Test-Path -Path "$rPathX64\{7CE610A8-26B0-4E99-A409-7BE9C004928C}") -eq $True)
#         {Add-Content C:\Admin\DriverInstallation.TXT "`nBarCode Configuration Utility Installed $Date"}
#         Else
#         {Add-Content C:\Admin\DriverInstallation.TXT "`nBarCode Configuration Utility Failed $Date"
#         Restart-Computer
#         }
#         }
         
# Camera Light Switch   !!! not on Original Image  !!!
        IF ((Test-Path -Path "$rPathX64\{363570D9-A1B1-4B82-800F-86A385C65BD2}") -eq $false)
        {
         $si.FileName = $CFH2 + "\lightsw\setup.exe"
         $si.Arguments = "/S /v/qn"
         startProcess $si
        IF ((Test-Path -Path "$rPathX64\{363570D9-A1B1-4B82-800F-86A385C65BD2}") -eq $True)
        {Add-Content C:\Admin\DriverInstallation.TXT "`nCamera Light Switch Installed $Date"}
        Else
        {Add-Content C:\Admin\DriverInstallation.TXT "`nCamera Light Switch Failed $Date"
        Restart-Computer
        }
       }
         
# Camera Utility   !!!! Not installed on Original Image  !!!
        IF ((Test-Path -Path "$rPathX64\{4D298345-7A92-47F9-BC09-353577EC01EF}") -eq $false)
        {
         $si.FileName = $CFH2 + "\pcam\setup.exe"
         $si.Arguments = "-s"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\{4D298345-7A92-47F9-BC09-353577EC01EF}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nCamera Utility Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nCamera Utility Failed $Date"
         Restart-Computer
         }
         }
         
# Dual Touch Screen Driver  
        IF ((Test-Path -Path "$rPathX86\ISD Tablet Driver") -eq $false)
        {
         $si.FileName = $CFH2 + "\drivers\dtouch\Setup.exe"
         $si.Arguments = "/S /v/qn"
         startProcess $si
         IF ((Test-Path -Path "$rPathX86\ISD Tablet Driver") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nISD Tablet Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nISD Tablet Failed $Date"
         Restart-Computer
         }
         }
         
# MCA PlatForm Driver
        IF ((Test-Path -Path "$rPathX86\{BFACD0D1-D6F4-45E4-A019-7359BAC83C00}") -eq $false)
        {
         $si.FileName = $CFH2 + "\drivers\mca\MCAPD_Setup.exe"
         $si.Arguments = "/qn /norestart"
         startProcess $si
         IF ((Test-Path -Path "$rPathX86\{BFACD0D1-D6F4-45E4-A019-7359BAC83C00}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nMCA PlatForm Driver Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nMCA PlatForm Driver Failed $Date"
         Restart-Computer
         }
         }
           
# Intel Thermal Framework
        IF ((Test-Path -Path "$rPathX64\FFD10ECE-F715-4a86-9BD8-F6F47DA5DA1C") -eq $false)
        {
         $si.FileName = $CFH2 + "\drivers\etm\Setup.exe"
         $si.Arguments = "-s"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\FFD10ECE-F715-4a86-9BD8-F6F47DA5DA1C") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nIntel Thermal Framework Installed $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nIntel Thermal Framework Failed $Date"
         Restart-Computer
         }
         }
             
# Manuals
        IF ((Test-Path -Path "C:\Users\Public\Desktop\Important Tips.lnk") -eq $false)
        {
         Copy-item "C:\Admin\Hardware\CFH2\Manual\Important Tips.lnk" "C:\Users\Public\Desktop"
         Copy-item "C:\Admin\Hardware\CFH2\Manual\Reference Manual.lnk"  "C:\Users\Public\Desktop"
         IF ((Test-Path -Path "C:\Users\Public\Desktop\Important Tips.lnk") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nManuals Copied $Date"}
         else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nManuals Not Copied $Date"
         Restart-Computer
         }
         }
                    
# Panasonic Run Once
#        IF ((Test-Path -Path "C:\Program Files (x86)\Panasonic\PRunOnce\PRunOnce.exe") -eq $false)
#        {
#         New-Item "C:\Program Files (x86)\Panasonic\PRunOnce" -Itemtype Directory -ErrorAction silentlycontinue
#         Copy-item "C:\Admin\Hardware\CFH2\prunonce\PRunOnce.exe" "C:\Program Files (x86)\Panasonic\PRunOnce"
#         Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "PRunonce" -Value "C:\Program Files (x86)\Panasonic\PRunOnce\PRunOnce.exe" 
#         IF ((Test-Path -Path "C:\Program Files (x86)\Panasonic\PRunOnce\PRunOnce.exe") -eq $True)
#         {Add-Content C:\Admin\DriverInstallation.TXT "`nPanasonic Run Once Copied $Date"}
#         Else
#
#         {Add-Content C:\Admin\DriverInstallation.TXT "`nPanasonic Run Once Copied Failed $Date"
#         Restart-Computer
#         }
#         }
         
# M7700 Sierra Wireless QMI Driver Package
         IF ((Test-Path -Path "$rPathX64\SWIQMIDrvInstaller") -eq $false)
        {
         $si.FileName = $CFH2 + "\MC7700 March 2013\MC7700att_QMIDriverPackage_Build3617_Win7\SWIQMISetup.exe"
         #$si.Arguments = "Silent=1"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\SWIQMIDrvInstaller") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nM7700 Sierra Wireless QMI Driver Package $Date"}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nM7700 Sierra Wireless QMI Driver Package Failed $Date"
         Restart-Computer
         }
         }
                
# M7700 Sierra Wireless AirCard Watcher
         IF ((Test-Path -Path "$rPathX64\{792227C0-A003-463F-8141-2C2196325669}") -eq $false)
        {
         $si.FileName = $CFH2 + "\MC7700 March 2013\Watcher_Build3728_Panasonic\Build3728\Watcher_Panasonic_Q.msi"
         $si.Arguments = "/passive"
         startProcess $si
         IF ((Test-Path -Path "$rPathX64\{792227C0-A003-463F-8141-2C2196325669}") -eq $True)
         {Add-Content C:\Admin\DriverInstallation.TXT "`nM7700 Sierra Wireless AirCard Watcher $Date"
         Restart-Computer}
         Else
         {Add-Content C:\Admin\DriverInstallation.TXT "`nM7700 Sierra Wireless AirCard Watcher Failed $Date"
         Restart-Computer
         }
         }
#Barcode Dll
    IF ((Test-Path -Path "C:\Windows\System32\ISDC_Rs.dll") -eq $false)
        {Copy-item "C:\Admin\Hardware\CFH2\drivers\barcode\x64\ISDC_RS.dll" "C:\Windows\System32"}
    IF ((Test-Path -Path "C:\Windows\System32\DevH1Lib.dll") -eq $false)
        {Copy-item "C:\Admin\Hardware\CFH2\drivers\09_DeviceInfoLibDLL64bit_\DevH1Lib.dll" "C:\Windows\System32"}
    IF ((Test-Path -Path "C:\Windows\SysWOW64\ISDC_Rs.dll") -eq $false)
        {Copy-item "C:\Admin\Hardware\CFH2\drivers\06_BarcodeReaderDLL_v2.5\ISDC_RS.dll" "C:\Windows\SysWOW64"}
    IF ((Test-Path -Path "C:\Windows\SysWOW64\DevH1Lib.dll") -eq $false)
        {Copy-item "C:\Admin\Hardware\CFH2\drivers\08_DeviceInfoLibDLL_v2.00\DevH1Lib.dll" "C:\Windows\SysWOW64"}

# Call software installation 
# $Software = '\\wds\SYSVOL\Deploy.LAN\scripts\Software.ps1'
#    Resolve-Path $Software
#    Invoke-Expression $Software
}

 # this Selects the computer Make and model and installs the correct drivers        
   $computersystem | select-Object {$_.Model}
   Switch -Wildcard ($computersystem.model)
    {
     "CF-H2FRPYV1M"      {PanaSonicCF-H2;break}
      Default             {Break}
    }
