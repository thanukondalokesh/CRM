<!-- MUST BE FIRST -->
<cfsetting showdebugoutput="false">

<!-- SHOW POPUP MESSAGES -->
<cfif structKeyExists(url, "msg")>
    <script>
        <cfif url.msg EQ "updated">
            alert("Request Updated Successfully!");
        <cfelseif url.msg EQ "update_failed">
            alert("Failed to Update Request!");
        <cfelseif url.msg EQ "deleted">
            alert("Request Deleted Successfully!");
        <cfelseif url.msg EQ "delete_failed">
            alert("Failed to Delete Request!");
        </cfif>
    </script>
</cfif>


<!DOCTYPE html>
<html>
<head>
    <title>View Requests</title>

    <link rel="stylesheet" href="css/viewRequests.css">
    <link rel="stylesheet" href="css/pagination.css">

    <script src="scriptjs/viewRequests.js" defer></script>
    <script src="scriptjs/pagination.js" defer></script>
    
</head>

<body>
<cfoutput>

    

    <div class="top-row">
        <a href="index.cfm?fuse=submitrequest" class="link-submit">+ Submit New Request</a>

        <form action="index.cfm?fuse=home" method="get" style="display:inline;">
            <button type="submit" class="btn-back">← Back to Home</button>
        </form>
    </div>

    <hr>

    <!-- Search / Filter -->
    <div class="filter-form">
        <label for="department">Department:</label>
        <select id="department">
            <option value="">--All Departments--</option>
            <option value="HR">HR</option>
            <option value="Finance">Finance</option>
            <option value="IT">IT</option>
            <option value="Sales">Sales</option>
            <option value="Admin">Admin</option>
        </select>

        <input type="text" id="searchText" placeholder="Search title or description">
        <button id="clearBtn" class="btn-clear">Clear</button>
    </div>

    <div style="text-align:right;">
      <button id="pdfBtn" class="pdf-btn">View & Download PDF Report</button>
    </div>

    <hr>

    <h2>All Requests</h2>

    <table id="reqTable">
        <thead>
            <tr>
                <th>ID</th>
                <th>User</th>
                <th>Department</th>
                <th>Title</th>
                <th>Description</th>
                <th>Date</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody id="reqBody"></tbody>
    </table>

    <div class="pagination"></div>

</cfoutput>
</body>
</html>
