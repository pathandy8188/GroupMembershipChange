$GroupName = “Domain Admins”
$Groupfile = "C:\scripts\$GroupName.txt"
$Groupfilenew = "C:\scripts\$GroupName-new.txt"
$date=Get-Date -Format F
$smtpserver = "mail.smtp2go.com"
$fromemail = "alerts@domainname.com"
$toemail = "rcptname@domainname.com"
#check if Groupfile exists, if not create one
if (-not(Test-Path -Path $Groupfile -PathType Leaf)) {
  try {
    (Get-ADGroupMember -Identity $GroupName).Name | Out-File $Groupfile
    }
    catch {
    throw $_.Exception.Message
    }
}
#write contents of Members to new file to compare
(Get-ADGroupMember -Identity $GroupName).Name | Out-File $Groupfilenew
#Get contents of both files
$GroupFileContent = Get-Content $Groupfile
$GroupFilenewContent = Get-Content $Groupfilenew

$resultadd=(Compare-Object -ReferenceObject $Groupfilecontent -DifferenceObject $Groupfilenewcontent | Where-Object {$_.SideIndicator -eq "=>"} | Select-Object -ExpandProperty InputObject) -join ", "
If ($resultadd) 
{
#Someone was added to the Group $_.SideIndicator -eq "=>"
$body = "<font face=""verdana"">
<p>This alert was generated at $date</p>
<p>$resultadd was added to the group $GroupName<br /> 
</font>"
Send-MailMessage -From $fromemail -To $toemail -SmtpServer $smtpserver -port 2525 -Subject "$GroupName Membership Changed | $result was added to the Group $GroupName" -Body $body -BodyAsHtml -Priority High
(Get-ADGroupMember -Identity $GroupName).Name | Out-File $Groupfile
}
$resultremove=(Compare-Object -ReferenceObject $Groupfilecontent -DifferenceObject $Groupfilenewcontent | Where-Object {$_.SideIndicator -eq "<="} | Select-Object -ExpandProperty InputObject) -join ", "
If ($resultremove) 
{
#Someone was removed from the Group $_.SideIndicator -eq "<="
$body = "<font face=""verdana"">
<p>This alert was generated at $date</p>
<p>$resultremove was removed from the group $GroupName<br /> 
</font>"
Send-MailMessage -From $fromemail -To $toemail -SmtpServer $smtpserver -port 2525 -Subject "$Groupname Membership Changed | $result was removed from the Group $GroupName" -Body $body -BodyAsHtml -Priority High
#Set new Group Members to compare
(Get-ADGroupMember -Identity $GroupName).Name | Out-File $Groupfile
}