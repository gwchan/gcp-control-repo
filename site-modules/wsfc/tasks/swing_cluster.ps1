$com = hostname

Write-Host "Attempting to Swing Cluster from $com"
$result = Get-ClusterNode $com | Get-ClusterGroup | Move-ClusterGroup
Write-Host $result
Write-Host "Done!"