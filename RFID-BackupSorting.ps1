#RFID Backup Sorting

$backupFiles = Get-ChildItem -Path "C:\Users\ewen.robinson\Downloads\ManageIT Backups"
foreach ($file in $backupFiles) {
    $myJSON = Get-Content $file.FullName -raw | ConvertFrom-Json
    
    switch ($myJSON.lms.locationcode) {
        '09261' {	Rename-Item -Path $file.FullName -NewName "Axminster Kiosk-DT-1.json"}
        '00161' {   Rename-Item -Path $file.FullName -NewName "Barnstaple Kiosk-DT-2883.json"}
        '00162' {   Rename-Item -Path $file.FullName -NewName "Barnstaple Kiosk-EYRE-2836.json"}
        '00163' {	Rename-Item -Path $file.FullName -NewName "Barnstaple Kiosk-EYRE-3.json"}
        '00164' {	Rename-Item -Path $file.FullName -NewName "Barnstaple Kiosk-DT-2.json"}
        '00961' {	Rename-Item -Path $file.FullName -NewName "Bideford Kiosk-EYRE-1.json"}
        '00962' {	Rename-Item -Path $file.FullName -NewName "Bideford Kiosk-EYRE-2.json"}
        '19761' {	Rename-Item -Path $file.FullName -NewName "Bovey Tracey Kiosk-DT-1.json"}
        '01161' {	Rename-Item -Path $file.FullName -NewName "Braunton Kiosk-EYRE-1.json"}
        '09161' {	Rename-Item -Path $file.FullName -NewName "Budleigh Salterton Kiosk-DT-1.json"}
        '18861' {	Rename-Item -Path $file.FullName -NewName "Crediton Kiosk - EYRE - 2848 - CRE2.json"}
        '18862' {	Rename-Item -Path $file.FullName -NewName "Crediton Kiosk - EYRE - 2838 - CRE1.json"}
        '09661' {	Rename-Item -Path $file.FullName -NewName "Cullompton Kiosk-EYRE-2846.json"}
        '09662' {   Rename-Item -Path $file.FullName -NewName "Cullompton Kiosk-EYRE-2.json" }
        '05761' {	Rename-Item -Path $file.FullName -NewName "Dartmouth Kiosk-EYRE-1.json"}
        '19061' {	Rename-Item -Path $file.FullName -NewName "Dawlish Kiosk - EYRE - 2839 - DAW1.json"}
        '18161' {	Rename-Item -Path $file.FullName -NewName "Exeter Kiosk - DT - 2894 - EXE5.json"}
        '18162' {	Rename-Item -Path $file.FullName -NewName "Exeter Kiosk - DT - 2893 - EXE4.json"}
        '18163' {	Rename-Item -Path $file.FullName -NewName "Exeter Kiosk - EYRE - 2847 - EXE3.json"}
        '18164' {	Rename-Item -Path $file.FullName -NewName "Exeter Kiosk - EYRE - 2837 - EXE2.json"}
        '18165' {	Rename-Item -Path $file.FullName -NewName "Exeter Kiosk - EYRE - 2841 - EXE1.json"}
        '08661' {	Rename-Item -Path $file.FullName -NewName "Exmouth Kiosk-DT-1.json"}
        '08662' {	Rename-Item -Path $file.FullName -NewName "Exmouth Kiosk-EYRE-1.json"}
        '02061' {	Rename-Item -Path $file.FullName -NewName "Holsworthy Kiosk-DT-2881.json"}
        '08961' {	Rename-Item -Path $file.FullName -NewName "Honiton Kiosk-EYRE-1.json"}
        '01061' {	Rename-Item -Path $file.FullName -NewName "Ilfracombe Kiosk-EYRE1.json"}
        '15361' {	Rename-Item -Path $file.FullName -NewName "Ivybridge Kiosk-DT-2886.json"}
        '15362' {	Rename-Item -Path $file.FullName -NewName "Ivybridge Kiosk-EYRE-1.json"}
        '05061' {	Rename-Item -Path $file.FullName -NewName "Kingsbridge Kiosk-DT-1.json"}
        '05062' {	Rename-Item -Path $file.FullName -NewName "Kingsbridge Kiosk-EYRE-1.json"}
        '05861' {	Rename-Item -Path $file.FullName -NewName "Kingsteignton Kiosk-DT-1.json"}
        '04861' {   Rename-Item -Path $file.FullName -NewName "Newton Abbot Kiosk-DT-2789.json"}
        '04862' {	Rename-Item -Path $file.FullName -NewName "Newton Abbot Kiosk-EYRE-1.json"}
        '04863' {	Rename-Item -Path $file.FullName -NewName "Newton Abbot Kiosk-EYRE-2.json"}
        '01261' {	Rename-Item -Path $file.FullName -NewName "Northam Kiosk-DT-2882.json"}
        '19161' {	Rename-Item -Path $file.FullName -NewName "Okehampton Kiosk-DT-2884.json"}
        '19162' {	Rename-Item -Path $file.FullName -NewName "Okehampton Kiosk-EYRE-1.json"}
        '09561' {	Rename-Item -Path $file.FullName -NewName "Ottery St Mary Kiosk-EYRE-1.json"}
        '09061' {	Rename-Item -Path $file.FullName -NewName "Seaton Kiosk-EYRE-1.json"}
        '08761' {	Rename-Item -Path $file.FullName -NewName "Sidmouth Kiosk-EYRE-1.json"}
        '08762' {	Rename-Item -Path $file.FullName -NewName "Sidmouth Kiosk-EYRE-2.json"}
        '01361' {   Rename-Item -Path $file.FullName -NewName "South Molton Kiosk-EYRE-1.json"}
        '19361' {	Rename-Item -Path $file.FullName -NewName "St Thomas Kiosk-EYRE-2840.json"}
        '19362' {	Rename-Item -Path $file.FullName -NewName "St Thomas Kiosk-DT-1.json"}
        '14361' {	Rename-Item -Path $file.FullName -NewName "Tavistock Kiosk-DT-2885.json"}
        '14362' {	Rename-Item -Path $file.FullName -NewName "Tavistock Kiosk-EYRE-1.json"}
        '19461' {	Rename-Item -Path $file.FullName -NewName "Teignmouth Kiosk-DT-1.json"}
        '19462' {	Rename-Item -Path $file.FullName -NewName "Teignmouth Kiosk-EYRE-1.json"}
        '08861' {	Rename-Item -Path $file.FullName -NewName "Tiverton Kiosk-DT-1.json"}
        '08862' {	Rename-Item -Path $file.FullName -NewName "Tiverton Kiosk-EYRE-1.json"}
        '02261' {	Rename-Item -Path $file.FullName -NewName "Torrington Kiosk-EYRE-1.json"}
        '05261' {	Rename-Item -Path $file.FullName -NewName "Totnes Kiosk-DT-1.json"}
        '05262' {	Rename-Item -Path $file.FullName -NewName "Totnes Kiosk-EYRE-1.json"}
        '04961' {	Rename-Item -Path $file.FullName -NewName "Brixham Kiosk-EYRE-1.json"}
        '05161' {	Rename-Item -Path $file.FullName -NewName "Churston Kiosk-DT-1.json"}
        '04761' {	Rename-Item -Path $file.FullName -NewName "Paignton Kiosk-DT-1.json"}
        '04762' {	Rename-Item -Path $file.FullName -NewName "Paignton Kiosk-EYRE-1.json"}
        '04763' {	Rename-Item -Path $file.FullName -NewName "Paignton Kiosk-EYRE2.json"}
        '04161' {	Rename-Item -Path $file.FullName -NewName "Torquay Kiosk-DT-1.json"}
        '04162' {	Rename-Item -Path $file.FullName -NewName "Torquay Kiosk-EYRE-1.json"}
        '04163' {	Rename-Item -Path $file.FullName -NewName "Torquay Kiosk-EYRE-2.json"}
    }
}





