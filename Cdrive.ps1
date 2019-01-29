$servers = Get-content -path D:\servers\servers.txt 

#$limit = (Get-Date).AddDays(-90)


 function CleanupFolders {
        
$PathLocal = "\\"+$server+"\"

    $Paths = @(
    'C$\msnipak\msnpatch\*',
    'C$\temp\*',
    'C$\Windows\SoftwareDistribution\Download\*'
    )
    $Paths1 = "\\"+$server+"\"+'C$\windows\temp\*'
   foreach($Path in $Paths)
   {
    $Path = $PathLocal + $Path
    write-host $Path
    # to delete msnpatches
     get-childitem $Path -Recurse | where-object { $_.LastWriteTime -lt (Get-Date).AddDays(-90) } | remove-item -Force -Recurse -ErrorAction SilentlyContinue -Confirm:$false

    # To delete empty folders 
    Get-ChildItem -Path $Path -Recurse -Force | Where-Object { $_.PSIsContainer -and (
    Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue -Confirm:$false
   
           
    }

  get-childitem $Paths1 -recurse | remove-item -ErrorAction SilentlyContinue -Confirm:$false  -Force -Recurse

    Get-ChildItem -Path $Paths1 -Recurse -Force | Where-Object { $_.PSIsContainer -and (
    Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue -Confirm:$false
       
     }
     
foreach ($server in $servers)
{
        $Disks = Get-wmiobject  Win32_LogicalDisk -ComputerName $server  -filter "deviceid='C:'"
        $Servername = (Get-wmiobject  CIM_ComputerSystem -ComputerName $server).Name 
        $out=New-Object PSObject 
        $total=“{0:N0}” -f ($Disks.Size/1GB)  
        $free=($Disks.FreeSpace/1GB)  
        $freePercent=“{0:P0}” -f ([double]$Disks.FreeSpace/[double]$Disks.Size)  
           
        $out | Add-Member -MemberType NoteProperty -Name "Servername" -Value $Servername 
        $out | Add-Member -MemberType NoteProperty -Name "Drive" -Value $Disks.DeviceID  
        $out | Add-Member -MemberType NoteProperty -Name "Total size (GB)" -Value $total 
        $out | Add-Member -MemberType NoteProperty -Name “Free Space (GB)” -Value $free 
        $out | Add-Member -MemberType NoteProperty -Name “Free Space (%)” -Value $freePercent 
     #   $out | Add-Member -MemberType NoteProperty -Name "Name " -Value $Disks.volumename 
        $out | Add-Member -MemberType NoteProperty -Name "DriveType" -Value $Disks.DriveType 
 
 
    CleanupFolders{}


        $Disks1 = Get-wmiobject  Win32_LogicalDisk -ComputerName $server  -filter "deviceid='C:'" 
        $total1=“{0:N0}” -f ($Disks1.Size/1GB)  

        $free1=($Disks1.FreeSpace/1GB)  
        $freePercent1=“{0:P0}” -f ([double]$Disks1.FreeSpace/[double]$Disks1.Size)  
  

        $out | Add-Member -MemberType NoteProperty -Name “Free Space After (GB)” -Value $free1 -force
        $out | Add-Member -MemberType NoteProperty -Name “Free Space After (%)” -Value $freePercent1 -force
 
        $out | export-csv H:\Diskspace_Report.csv -NoTypeInformation -Append -force   
        

}




