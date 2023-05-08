# Connect to AzureAD
Connect-AzureAD

# Get CSV content
$CSVrecords = Import-Csv C:\Windows\Temp\Users.csv -Delimiter ";"

# Create arrays for skipped and failed users
$SkippedUsers = @()
$FailedUsers = @()

# Loop through CSV records (users)
foreach ($CSVrecord in $CSVrecords) {
    $upn = $CSVrecord.UserPrincipalName
    $user = Get-AzureADUser -Filter "userPrincipalName eq '$upn'"  
    if ($user) {
        try{
        $user | Set-AzureADUser -JobTitle $CSVrecord.JobTitle -Department $CSVrecord.Department -CompanyName $CSVrecord.CompanyName
        } catch {
        $FailedUsers += $upn
        Write-Warning "$upn user found, but FAILED to update."
        }
    }
    else {
        Write-Warning "$upn not found, skipped"
        $SkippedUsers += $upn
    }
}

# Array skipped users
# $SkippedUsers

# Array failed users
# $FailedUsers