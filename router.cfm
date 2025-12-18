<cfsetting enablecfoutputonly="yes">
<cfsetting showdebugoutput="false">


<cfset fuse = structKeyExists(url,"fuse") ? url.fuse : "home">
<cfset data = {} />


<!-- =========================== -->
<!--      AJAX JSON BLOCK        -->
<!-- =========================== -->
<cfif fuse EQ "requestsajax">
    <cfparam name="url.department" default="">
    <cfparam name="url.searchText" default="">

    <cfset result = application.controller.requestsajax(url.department, url.searchText) />

    <cfcontent type="application/json" reset="true">
    <cfoutput>#serializeJSON(result)#</cfoutput>
    <cfabort>
</cfif>


        


<!-- =========================== -->
<!--     NORMAL PAGE OUTPUT      -->
<!-- =========================== -->

<cfsetting enablecfoutputonly="no">

<cfoutput>

    <cfif fuse EQ "home">
        <cfset data = application.controller.home() />
        <cfinclude template="views/home.cfm" />

    <!-- ================= MY PROFILE ================= -->

<cfelseif fuse EQ "myprofile">
    <cfset data = application.controller.myprofile() />
    <cfinclude template="views/myprofile.cfm" />

<cfelseif fuse EQ "uploadProfilePic">
    <cfset application.controller.uploadProfilePic() />

<cfelseif fuse EQ "deleteProfilePic">
    <cfset application.controller.deleteProfilePic() />

<cfelseif fuse EQ "updateAbout">
    <cfset application.controller.updateAbout(form.aboutText) />


    <cfelseif fuse EQ "viewlogs">
        <cfset data = application.controller.viewlogs() />
        <cfinclude template="views/viewLogs.cfm" />

    <cfelseif fuse EQ "registerlist">
        <cfset data = application.controller.registerlist() />
        <cfinclude template="views/registerList.cfm" />

    <cfelseif fuse EQ "submitrequest">
        <cfset data = application.controller.submitrequest() />
        <cfinclude template="views/submitRequest.cfm" />

    <cfelseif fuse EQ "viewrequests">
        <cfset data = application.controller.viewrequests() />
        <cfinclude template="views/viewRequests.cfm" />

    <!-- =========================== -->
    <!--        EDIT REQUEST         -->
    <!-- =========================== -->
    <cfelseif fuse EQ "editrequest">

        <cfparam name="url.id" default="0">

        <cfif structKeyExists(form,"update")>

            <!-- FIXED ERROR: removed extra "/" -->
            <cfset resp = application.controller.updaterequest(url.id, form) />

            <cfif resp.result EQ "success">
                <cflocation url="index.cfm?fuse=viewrequests&msg=updated" addtoken="false">
            <cfelse>
                <cflocation url="index.cfm?fuse=viewrequests&msg=update_failed" addtoken="false">
            </cfif>

        <cfelse>
            <cfset data = application.controller.editrequest(url.id) />
            <cfinclude template="views/editRequest.cfm" />
        </cfif>

    <!-- =========================== -->
    <!--        DELETE REQUEST        -->
    <!-- =========================== -->
    <cfelseif fuse EQ "deleterequest">
        <cfparam name="url.id" default="0">

        <cfif isNumeric(url.id) AND url.id GT 0>

            <cfset resp = application.controller.deleterequest(url.id) />

            <cfif resp.result EQ "success">
                <cflocation url="index.cfm?fuse=viewrequests&msg=deleted" addtoken="false">
            <cfelse>
                <cflocation url="index.cfm?fuse=viewrequests&msg=delete_failed" addtoken="false">
            </cfif>

        <cfelse>
            <h3>Invalid Request ID</h3>
        </cfif>

    <!-- =========================== -->
    <!--             PDF             -->
    <!-- =========================== -->
    <cfelseif fuse EQ "requestspdf">
        <cfinclude template="Downloads/viewrequests_pdf.cfm" />

   <cfelseif fuse EQ "customers">
    <!-- CUSTOMER MAIN PAGE -->
    <cfinclude template="views/customers.cfm">

<cfelseif fuse EQ "customerspdf">
    <cfinclude template="Downloads/customersPDF.cfm">
        

    <cfelse>
        <h2>Invalid Fuse: #fuse#</h2>

    </cfif>

</cfoutput>
