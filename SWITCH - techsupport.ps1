# Script to get Switch techsupport.txt files

$content = Invoke-WebRequest -Uri "https://10.0.1.5/techsupport.txt" -SkipCertificateCheck

# trying to get system log from content
$tempArray = $content.Content.Split("- System Log -")

# currently ends with </pre>
#$tempArray[1].Trim()

# messy but clears </pre> and all white space at front and end
# (($array[1].Trim()).TrimEnd("</pre>")).Trim()

# splits each line into an object with three headers, ID, Date and Status (`t is TAB)
$objects = (($tempArray[1].Trim()).TrimEnd("</pre>")).Trim() | ConvertFrom-Csv -Delimiter "`t" -Header "ID", "Date", "Status"
$sObjects = $objects | Sort-Object -Property ID

# The System restared abnormally
$abnormal = $sObjects | Where-Object {$_.Status -eq "The System restared abnormally"} | Select-Object ID

#326 restarted abnormally so looking for time from ID 328
ForEach ($a in $abnormal) {
    $sObjects[([int]$a.ID) + 1]
}