Dism /Image:"C:\mount\windows" /Set-AllIntl:nb-NO /Set-TimeZone:"W. Europe Standard Time"

${MaxSize} = (Get-PartitionSupportedSize -DriveLetter c).sizeMax
Resize-Partition -DriveLetter c -Size ${MaxSize}
