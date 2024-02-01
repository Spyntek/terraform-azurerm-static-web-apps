$jsonFile = Get-Content  "siteserverconfig.json" | ConvertFrom-Json
$newjsonFile = Get-Content "newsiteconfig.json" | ConvertFrom-Json

# Read the text file and store the items in an array
$textFile = "textitems.txt"
$textItems = Get-Content -Path $textFile

# Loop through the text items and add them as new objects to the ReceiverQueue property
foreach ($scanItem in $newjsonFile.DataReceiver.ReceiverQueue.SiteCode) {
    foreach ($item in $textItems) {
        $newObject = [PSCustomObject]@{
            SiteCode = $item
            ReadQueuePath = ".\private$\$item-AIM-SSQUEUE"    
        }

        # Check if the new object already exists in the ReceiverQueue
        if ($scanItem -eq $newObject.SiteCode) {
            Write-Host "$newObject already exists in the ReceiverQueue property. Skipping..."
            $scanItem++
            $newObject.SiteCode++
            continue
        }
      
        else {
            $newjsonFile.DataReceiver.ReceiverQueue += $newObject
            Write-Host "Added $newObject to the ReceiverQueue property"
        }
    }
}


# Convert the modified PowerShell object back to JSON and write it to the file
$newJsonString = ConvertTo-Json -InputObject $newjsonFile -Depth 5
Set-Content -Path "C:\Temp\newsiteconfig.json" -Value $newJsonString

