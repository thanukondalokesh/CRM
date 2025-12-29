<!--- LOG: Page Access --->
<cflog
    file="crmRequestLog"
    type="information"
    text="Submit Request page opened by user: #session.username#">

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submit New Request</title>
    <link rel="stylesheet" type="text/css" href="css/submitRequest.css">
</head>

<body>

<div class="form-box">
    <h2>Submit Request</h2>

    <form method="post">
        <label>Department</label>
        <select name="department" required>
            <option value="">-- Select Department --</option>
            <option value="HR">HR</option>
            <option value="IT">IT</option>
            <option value="Finance">Finance</option>
            <option value="Sales">Sales</option>
            <option value="Admin">Admin</option>
        </select>

        <label>Title</label>
        <input type="text" name="title" required>

        <label>Description</label>
        <textarea name="description" required></textarea>

        <button type="submit" class="btn-submit" name="submit">Submit</button>
    </form>
</div>

<!-- Back Button -->
<div class="back-button">
  <a href="index.cfm?fuse=home">
    <button class="btn-back">← Back to Home</button>
  </a>
</div>

<!-- ALERT POPUPS + LOGGING -->
<cfif structKeyExists(data, "result") AND data.result EQ "success">

    <!--- LOG: Success --->
    <cflog
        file="crmRequestLog"
        type="information"
        text="Request submitted successfully by user: #session.username#">

    <script>
        alert("Request Submitted Successfully!");
        window.location.href = "index.cfm?fuse=viewrequests";
    </script>

<cfelseif structKeyExists(data, "result") AND data.result EQ "error">

    <!--- LOG: Error --->
    <cflog
        file="crmRequestLog"
        type="error"
        text="Request submission failed by user: #session.username#">

    <script>
        alert("Failed! Please fill all fields or try again.");
        window.location.href = "index.cfm?fuse=submitrequest";
    </script>

</cfif>

</body>
</html>
