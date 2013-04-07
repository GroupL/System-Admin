#$strFilter = "(&(objectCategory=User)(Department=Finance))"
$strFilter = "(&(objectCategory=User))"
$objDomain = New-Object System.DirectoryServices.DirectoryEntry
#$objOU = New-Object System.DirectoryServices.DirectoryEntry("LDAP://OU=Finance,dc=fabrikam,dc=com")

$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.PageSize = 1000
$objSearcher.Filter = $strFilter
$objSearcher.SearchScope = "Subtree"

$colProplist = "name", "memberof", "samaccountname"
foreach ($i in $colPropList){$objSearcher.PropertiesToLoad.Add($i)}

$colResults = $objSearcher.FindAll()

foreach ($objResult in $colResults)
{
	$administrator = "false";
	$objItem = $objResult.Properties; 
	foreach ($member in $objItem.memberof)
		{
			if ($member -eq "CN=Administrators,CN=Builtin,DC=groupl,DC=sqrawler,DC=com")
			{
				$administrator = "true";
			}
		}
		if ($administrator -eq "false")
		{
			"Name: " + $objItem.name;
			"Username: " + $objItem.samaccountname;
		}
	
 #}
 #{$objItem = $objResult.Properties; $objItem.name}
 }