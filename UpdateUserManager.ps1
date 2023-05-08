# Connect to AzureAD
Connect-AzureAD

# Get CSV content
$CSVrecords = Import-Csv "C:\Windows\Temp\UserManager.csv" -Delimiter ";"

# Create array for status result
$UpdateResult = @()

# Loop through CSV records (users) and set manager for users
foreach ($CSVrecord in $CSVrecords) {
    $UserUPN = $CSVrecord.UserUPN
    $ManagerUPN = $CSVrecord.ManagerUPN

    try{
        # Get the Manager's ObjectId
        $ManagerObj = Get-AzureADUser -ObjectId $ManagerUPN

        # Set the manager for the user
        Set-AzureADUserManager -ObjectId $UserUPN -RefObjectId $ManagerObj.ObjectId
        
        # Set update status
        $UpdateStatus = "Success"
    } catch {
        $UpdateStatus = "Failed: $($_.Exception.Message)"
    }

    # Add update status to the result array
    $UpdateResult += [PSCustomObject]@{
        UserUPN = $UserUPN
        ManagerUPN = $ManagerUPN
        Status = $UpdateStatus
    }
}

# Display the update status result 
$UpdateResult | Select-Object UserUPN, ManagerUPN, Status
