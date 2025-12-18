<cfsetting showdebugoutput="false">

<!-- 1️⃣ Fetch all requests from controller -->
<cfparam name="url.department" default="">
<cfparam name="url.searchText" default="">

<cfset getRequests = application.controller.getAllRequests(
    url.department,
    url.searchText
) />


<!-- 2️⃣ Check access type (download or open) -->
<cfset accessType = structKeyExists(url, "download") 
    ? "Downloaded PDF" 
    : "Opened PDF in Browser" />

<!-- 3️⃣ Send email notification -->
<cfset application.controller.sendPDFMailToAdmin(accessType) />

<!-- 4️⃣ PDF Headers -->
<cfheader name="Content-Disposition" value="inline; filename=ViewRequestsReport.pdf">

<!-- 5️⃣ Generate PDF -->
<cfdocument format="PDF" marginTop="1" marginBottom="1" marginLeft="1" marginRight="1">

    <cfset currentDay  = dayOfWeekAsString(dayOfWeek(now()))>
    <cfset currentDate = dateFormat(now(), "dd-MM-yyyy")>
    <cfset currentTime = timeFormat(now(), "hh:mm:ss tt")>

    <h2 style="text-align:center;">View Requests - PDF Report</h2>
    <br>
    <cfoutput>
        <div style="text-align:right; font-family:Arial; font-size:12px;">
            #currentDay#, #currentDate# | #currentTime#
        </div>
    </cfoutput>    

    <br><hr><br>

    <table border="1" cellpadding="6" cellspacing="0" width="100%">
        <tr style="background-color:#e0e0e0; font-weight:bold;">
            <th>ID</th>
            <th>Department</th>
            <th>Title</th>
            <th>Description</th>
            <th>Date</th>
        </tr>

        <cfoutput query="getRequests">
            <tr>
                <td>#id#</td>
                <td>#department#</td>
                <td>#title#</td>
                <td>#description#</td>
                <td>#dateFormat(action_time,'dd-MM-yyyy')#</td>
            </tr>
        </cfoutput>

    </table>

</cfdocument>
