$strFilter = "(&(objectCategory=User))"
$objDomain = New-Object System.DirectoryServices.DirectoryEntry

$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.PageSize = 1000
$objSearcher.Filter = $strFilter
$objSearcher.SearchScope = "Subtree"

$colProplist = "name", "memberof", "samaccountname","givenname","sn"
foreach ($i in $colPropList){$objSearcher.PropertiesToLoad.Add($i)}

$colResults = $objSearcher.FindAll()

$ArrayOfExistingUsers

foreach ($objResult in $colResults)
{
	$objItem = $objResult.Properties; 
	$ArrayOfExistingUsers += ($objItem.givenname);
	$ArrayOfExistingUsers += ($objItem.sn);
	 
	
		
 }
#Read in csv 
 $csv = Import-Csv c:\path\to\your.csv #Path to csv here
foreach ($line in $csv) 
{
	$FirstNameFound = "false";
	$LastNameFound = "false";

	for ($i=0; $i -lt $ArrayOfExistingUsers.length; $i++) 
	{
		if ($line.firstname -eq $ArrayOfExistingUsers[$i])
		{
			$FirstNameFound = "true";
		}
		i++
		if ($line.surname -eq $ArrayOfExistingUsers[$i])
		{
			$LastNameFound = "true";
		}
	}
	
	if ($FirstNameFound -eq "false" -and $LastNameFound -eq "false")
	{
		#New-Mailbox -Name $line.Name -WindowsLiveID $line.Email -ImportLiveId
		$Class = "User"
		$strUserName = "CN=" + $line.firstname + " " + $line.surname;
		$objADSI = [ADSI]"LDAP://OU=Users,DC=groupl,DC=sqrawler,DC=com"
		$objUser = $objADSI.Create($Class, $strUserName)
		$objUser.Put("samaccountname", $line.username)
		$objUser.Put("password", $line.password)
		$objUser.Put("givenname", $line.firstname)
		$objUser.Put("sn", $line.surname)
		$objUser.setInfo()
	}
}


 $ArrayOfExistingUsers