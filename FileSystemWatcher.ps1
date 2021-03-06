#By BigTeddy 05 September 2011

#This script uses the .NET FileSystemWatcher class to monitor file events in folder(s).
#The advantage of this method over using WMI eventing is that this can monitor sub-folders.
#The -Action parameter can contain any valid Powershell commands.  I have just included two for example.
#The script can be set to a wildcard filter, and IncludeSubdirectories can be changed to $true.
#You need not subscribe to all three types of event.  All three are shown for example.
# Version 1.1

$folder = 'c:\IT\Raw GoPro Vids' # Enter the root path you want to monitor.
$filter = '*.*'  # You can enter a wildcard filter here.

# In the following line, you can change 'IncludeSubdirectories to $true if required.                          
$fsw = New-Object IO.FileSystemWatcher $folder, $filter -Property @{IncludeSubdirectories = $true;NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'}

# Here, the event is registerd. 

Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -Action {
$name = $Event.SourceEventArgs.Name
$changeType = $Event.SourceEventArgs.ChangeType
$timeStamp = $Event.TimeGenerated
Write-Host "The file '$name' was $changeType at $timeStamp" -fore green
#Out-File -FilePath c:\scripts\filechange\outlog.txt -Append -InputObject "The file '$name' was $changeType at $timeStamp"}

# Wait for all videos to import from GoPro Application (10 minutes) so the rotate script doesn't interfere mid-file transfer and 
#Start-Sleep -s 600;
Start-Sleep -s 10;

# Run my video rotate script (which then calls other script also)

   C:\IT\auto_rotate_vids.ps1 -Wait

# also sleep again so the watcher script doesn't activate for each new video file. This gives the other script a chance to delete the files first.
   
#   Start-Sleep -s 2000;


# To stop the monitoring, run the following commands:
# Unregister-Event FileDeleted
# Unregister-Event FileCreated
# Unregister-Event FileChanged
}