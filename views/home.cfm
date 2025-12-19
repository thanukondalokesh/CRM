<!DOCTYPE html>
<html>
<head>
    <title>CRM Home</title>

    
</head>

<body>

    <div class="welcome-container">

        <cfoutput>
            <h2 class="welcome-text">
                Welcome User, #session.username#!
            </h2>
        </cfoutput>

        <div class="button-row">

            <!-- First Button -->
            <a href="index.cfm?fuse=viewrequests" class="btn btn-requests">
                View Requests
            </a>

            <!-- Middle Button -->
            <a href="index.cfm?fuse=myprofile" class="btn btn-profile">
                Go To My Profile
            </a>

            <!-- Admin-only Button -->
            <cfif structKeyExists(session, "adminstatus") AND session.adminstatus EQ "1">
                <a href="index.cfm?fuse=customers" class="btn btn-customers">
                    Customers Management
                </a>
            </cfif>

        </div>
    </div>

</body>
</html>
