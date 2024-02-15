 ##Read the JSON file and convert it to an object
$jsonFile = "siteserverconfig.json"
$json = Get-Content $jsonFile | ConvertFrom-Json -AsHashtable -Depth 100

# Read the text file and store the values in an array
$textFile = "aaiairports.txt"
$values = Get-Content $textFile

# Loop through the values and create new key value pairs
foreach ($value in $values) {
    # Copy the key value pairs that you want to create
    $siteCode = $json.DataReceiver.ReceiverQueue.SiteCode
    $readQueuePath = $json.DataReceiver.ReceiverQueue.ReadQueuePath

    # Replace the VAL with the value from the text file
    $siteCode = $siteCode -replace "VAL", $value
    $readQueuePath = $readQueuePath -replace "VAL", $value

    # Add the new key value pairs to the JSON object
    $json.DataReceiver.ReceiverQueue | Add-Member -Type NoteProperty -Name $siteCode -Value $readQueuePath
}

# Convert the JSON object back to a string and save it to the file
$json | ConvertTo-Json -Depth 100| Set-Content $jsonFile