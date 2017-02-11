# JavaSiteException.ps1
#
# This script will add 2 servers to the Oracle Java Exception Site List
# If the servers are already in the list, it will exit.
# More servers can be added as needed. The existing server entries can also be set to be
# empty (i.e. SERVER2='') as the script will do a check to see if either SERVER value
# is set to be null.
# Credits: https://derflounder.wordpress.com/2014/01/16/managing-oracles-java-exception-site-list/
#
# Leon Chung
# Created: 2017-02-11

# Server addresses - EDIT THESE
$server1 = "http://your.server.com"
$server2 = "https://secure.server.com"

# Look for Java install
if (Test-Path "$env:USERPROFILE\AppData\LocalLow\Sun\Java\Deployment") {

    # Script variables
    $whitelist = "$env:USERPROFILE\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"
    
    # If no list exist, create it and add our sites
    if (!(Test-Path $whitelist)) {

	    # Create file
	    New-Item -Path $whitelist -ItemType file | Out-Null

	    # Add servers
	    if ($server1) {
		    Add-Content -Path $whitelist -Value $server1
	    }
	    if ($server2) {
		    Add-Content -Path $whitelist -Value $server2
	    }
	    exit 0
    }

    # If list exists, check if server already exists, if not, add it
    if (Test-Path $whitelist) {
        
        
	    # Check list for URLs
        if ($server1) {
            $server1_whitelist_check = Select-String -Path $whitelist -Pattern $server1
	        if (!($server1_whitelist_check)) {
		    Add-Content -Path $whitelist -Value $server1
	        }
        }
        if ($server2) {
            $server2_whitelist_check = Select-String -Path $whitelist -Pattern $server2
            if (!($server2_whitelist_check)) {
		    Add-Content -Path $whitelist -Value $server2
            }
	    }
    }
}
exit 0
