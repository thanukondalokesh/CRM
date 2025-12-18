<!-- /CRM/Downloads/customersPDF.cfm -->

<cfsetting showdebugoutput="false">
<cfcontent reset="true">

<!-- GET DATA THROUGH CONTROLLER -->
<cfset customers = application.controller.getAllCustomers()>
<cfset adminEmail = application.controller.getAdminEmail()>

<!-- Notify admin -->
<cfmail to="#adminEmail#" from="#session.email#"
    subject="Customer PDF accessed by #session.username#" type="html">

    <cfoutput>
        User <strong>#session.username#</strong> accessed the Customer PDF.<br><br>

        Access:
            <strong>Downloaded</strong>

        <br><br>
        Email: #session.email#<br>
        Date: #dateFormat(now(),"dd-MM-yyyy")#
        Time: #timeFormat(now(),"hh:mm:ss tt")#
    </cfoutput>

</cfmail>

<!-- LOGGING -->
    <cfquery datasource="#application.datasource#">
        INSERT INTO pdf_download_logs (username)
        VALUES (<cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">)
    </cfquery>


<!-- PDF -->
<cfset pdfFile = expandPath("CustomerReport.pdf")>

    <cfset currentDay  = dayOfWeekAsString(dayOfWeek(now()))>
    <cfset currentDate = dateFormat(now(), "dd-MM-yyyy")>
    <cfset currentTime = timeFormat(now(), "hh:mm:ss tt")>

<cfdocument format="PDF" filename="#pdfFile#" overwrite="yes">

    <h2 style="text-align:center;">Customer List</h2>

    <cfoutput>
        <div style="text-align:right; font-family:Arial; font-size:12px;">
            #currentDay#, #currentDate# | #currentTime#
        </div>
    </cfoutput>  
    <br>  


    <table border="1" width="100%" cellpadding="6">
        <tr bgcolor="#eeeeee">
            <th>ID</th><th>User</th><th>Name</th>
            <th>Email</th><th>Phone</th><th>Created</th>
        </tr>

        <cfoutput query="customers">
            <tr>
                <td>#id#</td>
                <td>#username#</td>
                <td>#name#</td>
                <td>#email#</td>
                <td>#phone#</td>
                <td>#dateFormat(created_at,"dd-MM-yyyy")#</td>
            </tr>
        </cfoutput>
    </table>

</cfdocument>

<cfheader name="Content-Disposition" value="inline; filename=CustomerReport.pdf">
<cfheader name="Content-Type" value="application/pdf">
<cfcontent type="application/pdf" file="#pdfFile#" deletefile="false">
