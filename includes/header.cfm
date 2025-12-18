<!-- includes/header.cfm -->

<link rel="stylesheet" href="/CRM/css/header.css">
<script src="/CRM/scriptjs/header.js" defer></script>

<div class="topbar">
    <div class="menu-icon" id="menuToggle">☰</div>

    <div class="right-info">
        Logged in as |
        <cfoutput>
            <span>#session.username#</span>
        </cfoutput>
        <a href="/CRM/logout.cfm" class="logout-btn">Logout</a>
    </div>
</div>

<!-- Floating Menu -->
<div id="dropdownMenu" class="dropdown-menu">

    
    <a href="index.cfm?fuse=myprofile">Go To My Profile</a>
    <a href="index.cfm?fuse=submitrequest">Submit Request</a>
    <a href="index.cfm?fuse=viewrequests">View Requests</a>
    <cfif structKeyExists(session, "adminstatus") AND session.adminstatus EQ "1">
        <a href="index.cfm?fuse=viewlogs">View Logs</a>
        <a href="index.cfm?fuse=customers">Customers Management</a>
        <a href="index.cfm?fuse=registerlist">Users Register List</a>
    </cfif>

</div>
