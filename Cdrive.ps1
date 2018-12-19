$servers = Get-content -path D:\servers\servers.txt 

$limit = (Get-Date).AddDays(-90)
$path = 'C:\msnipak\msnpatch\'
$path1 = 'C:\temp\'
$path2 = 'C:\windows\temp\'
foreach ($server in $servers)
{
write-host $server
invoke-command -computername $server -ScriptBlock {

   
    write-host $server
    # to delete msnpatches
    get-childitem C:\msnipak\msnpatch\* -recurse | where-object { $_.LastAccessTime -lt (Get-Date).AddDays(-90) -and $_.LastWriteTime -lt (Get-Date).AddDays(-90) } | remove-item -ErrorAction SilentlyContinue -Confirm:$false

    # To delete empty folders 
    Get-ChildItem -Path C:\msnipak\msnpatch\ -Recurse -Force | Where-Object { $_.PSIsContainer -and (
    Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

   

    #To delete C:\temp - 
 

    get-childitem C:\temp\* -recurse | where-object { $_.LastAccessTime -lt (Get-Date).AddDays(-90) -and $_.LastWriteTime -lt (Get-Date).AddDays(-90) } | remove-item -ErrorAction SilentlyContinue -Confirm:$false

    # To delete empty folders in C temp -  
    Get-ChildItem -Path C:\temp\* -Recurse -Force | Where-Object { $_.PSIsContainer -and (
    Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse
    

    #To delete windir files - 
   
    get-childitem C:\windows\temp\* -recurse | remove-item -ErrorAction SilentlyContinue -Confirm:$false  -Force -Recurse

    Get-ChildItem -Path C:\windows\temp\ -Recurse -Force | Where-Object { $_.PSIsContainer -and (
    Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue -Confirm:$false
  
    }
}



