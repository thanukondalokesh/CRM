<!DOCTYPE html>
<html>
<head>
    <title>CRM Home</title>

    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Tahoma, Arial, sans-serif;
            background-color: #f4f6f9;
        }

        /* Center content */
        .welcome-container {
            height: calc(100vh - 160px);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .welcome-text {
            font-size: 32px;
            font-weight: 600;
            margin-bottom: 40px;
            color: #222;
        }

        /* Button row */
        .button-row {
            display: flex;
            gap: 25px;
        }

        /* Common button style */
        .btn {
            padding: 14px 32px;
            font-size: 16px;
            font-weight: 600;
            text-decoration: none;
            color: #fff;
            border-radius: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 6px 15px rgba(0,0,0,0.15);
        }

        /* Individual button colors */
        .btn-requests {
            background: linear-gradient(135deg, #4facfe, #00f2fe);
        }

        .btn-profile {
            background: linear-gradient(135deg, #43e97b, #38f9d7);
        }

        .btn-customers {
            background: linear-gradient(135deg, #fa709a, #fee140);
            color: #000;
        }

        /* Hover effect */
        .btn:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
    </style>
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
