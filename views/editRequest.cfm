<!--- LOG: Edit Request Page Opened --->
<cflog
    file="crmRequestLog"
    type="information"
    text="Edit Request page opened. RequestID=#url.id#, User=#session.username#">

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Request</title>
    <link rel="stylesheet" href="css/editRequest.css">
</head>
<body>

<cfsetting showDebugOutput="false">

<!-- If controller passed data.req -->
<cfif structKeyExists(data, "req") AND isDefined("data.req.recordCount")>
    <cfset getRequest = data.req>
<cfelse>
    <!-- Fallback to query by url.id -->
    <cfparam name="url.id" default="0">
    <cfquery name="getRequest" datasource="#application.datasource#">
        SELECT * FROM requests 
        WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
    </cfquery>
</cfif>

<cfif NOT structKeyExists(getRequest, "recordCount") OR getRequest.recordCount EQ 0>
    <h3>Request not found</h3>
    <a href="../index.cfm?fuse=viewrequests">Back to requests</a>
    <cfabort>
</cfif>

<cfoutput query="getRequest">
<div class="container">
    <div class="form-box">
        <h2>Edit Request</h2>

        <form method="post" action="index.cfm?fuse=editrequest&id=#id#">
            <!-- Department -->
            <label for="department">Department</label>
            <select name="department" id="department" required>
                <option value="">--Select Department--</option>
                <option value="HR" <cfif department EQ "HR">selected</cfif>>HR</option>
                <option value="IT" <cfif department EQ "IT">selected</cfif>>IT</option>
                <option value="Finance" <cfif department EQ "Finance">selected</cfif>>Finance</option>
                <option value="Sales" <cfif department EQ "Sales">selected</cfif>>Sales</option>
                <option value="Admin" <cfif department EQ "Admin">selected</cfif>>Admin</option>
            </select>

            <!-- Title -->
            <label>Title</label>
            <input type="text" name="title" value="#title#" required>

            <!-- Description -->
            <label>Description</label>
            <textarea name="description" required>#description#</textarea>

            <!-- BUTTON ROW -->
            <div class="button-row">
                <button type="submit" name="update" class="btn-update">Update</button>
                <a href="index.cfm?fuse=viewrequests" class="btn-cancel">Cancel</a>
            </div>
        </form>

        <cfif structKeyExists(request, "updateStatus") AND request.updateStatus EQ "failed">

            <!--- LOG: Update Failed --->
            <cflog
                file="crmRequestLog"
                type="error"
                text="Request update failed. RequestID=#id#, User=#session.username#">

            <div class="error">Update failed. Try again.</div>
        </cfif>

    </div>
</div>
</cfoutput>

</body>
</html>
