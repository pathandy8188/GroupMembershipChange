# GroupMembershipChange
Generate an email when Group Membership Changes<br/>
Variables to set <br />
$GroupName = “Domain Admins”<br />
$Groupfile = "C:\scripts\$GroupName.txt"<br />
$Groupfilenew = "C:\scripts\$GroupName-new.txt"<br />
$date=Get-Date -Format F<br />
$smtpserver = "smtpserver"<br />
$fromemail = "alerts@domainname.com"<br />
$toemail = "rcptname@domainname.com"<br />
