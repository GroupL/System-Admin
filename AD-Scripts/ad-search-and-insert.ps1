$strFilter = "(&(objectCategory=User))"
$objDomain = New-Object System.DirectoryServices.DirectoryEntry

$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.PageSize = 1000
$objSearcher.Filter = $strFilter
$objSearcher.SearchScope = "Subtree"

#properties to return from ad
$colProplist = "name", "memberof", "samaccountname","givenname","sn"

foreach ($i in $colPropList){$objSearcher.PropertiesToLoad.Add($i)}

$colResults = $objSearcher.FindAll()

#array to hold the existing users in ad
$ArrayOfExistingUsers

#fill the array with there names
foreach ($objResult in $colResults)
{
	$objItem = $objResult.Properties; 
	$ArrayOfExistingUsers += ($objItem.givenname);
	$ArrayOfExistingUsers += ($objItem.sn);
	 
	
		
 }
#Read in csv 
 $csv = Import-Csv c:\Scripts\addusers.csv #Path to csv here
 
 #for each line in the csv
foreach ($line in $csv) 
{
	#Set values to be false for testing if exist
	$FirstNameFound = "false";
	$LastNameFound = "false";

	#see if firstname and last name match any existing people and set found vars. 
	for ($i=0; $i -lt $ArrayOfExistingUsers.length; $i++) 
	{
		if ($line.firstname -eq $ArrayOfExistingUsers[$i])
		{
			$FirstNameFound = "true";
		}
		$i++
		if ($line.surname -eq $ArrayOfExistingUsers[$i])
		{
			$LastNameFound = "true";
		}
	}
	
	#if the user doesn't exist the create them
	if ($FirstNameFound -eq "false" -and $LastNameFound -eq "false")
	{
		#New-Mailbox -Name $line.Name -WindowsLiveID $line.Email -ImportLiveId
		$Class = "User"
		$strUserName = "CN=" + $line.firstname + " " + $line.surname;
		$objADSI = [ADSI]"LDAP://CN=Users,DC=groupl,DC=sqrawler,DC=com"
		$objUser = $objADSI.create($Class, $strUserName)
		$objUser.Put("samaccountname", $line.username)
		$objUser.Put("givenname", $line.firstname)
		$objUser.Put("sn", $line.surname)
		$objUser.setInfo()
		#set password for the user
		$objUser.SetPassword($line.password);
		$objUser.SetInfo  
	}
}
