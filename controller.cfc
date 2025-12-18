<!--- /CRM/controller.cfc --->
<cfcomponent output="false" hint="Main CRM Controller">
<!-- CUSTOMER SERVICE -->
<cfset variables.customerService =
    createObject("component", "CRM.components.CustomerService")>

    <!-- HOME -->
    <cffunction name="home" access="public" returntype="struct">
        <cfset var data = {} />
        <cfset data.message = "Welcome to the home" />
        <cfreturn data />
    </cffunction>

    <!-- MYPROFILE -->
    <!-- ================= MY PROFILE ================= -->
<cffunction name="myprofile" access="public" returntype="struct">
    <cfset var data = {} />

    <!-- Default image logic -->
    <cfset data.defaultImage = "uploads/default piture image.png">

    <cfif structKeyExists(session,"profilepath")
        AND len(session.profilepath)
        AND fileExists(expandPath("uploads/#session.profilepath#"))>
        <cfset data.imageURL = "uploads/#session.profilepath#">
    <cfelse>
        <cfset data.imageURL = data.defaultImage>
    </cfif>

    <cfreturn data />
</cffunction>
<cffunction name="uploadProfilePic" access="public" returntype="void">

    <cfset var uploadPath = expandPath("uploads")>

    <cftry>

        <cffile
            action="upload"
            fileField="uploadFile"
            destination="#uploadPath#"
            nameConflict="makeUnique"
            result="fileDetails">

        <!-- Resize & crop -->
        <cfset img = imageRead(fileDetails.serverDirectory & "/" & fileDetails.serverFile)>
        <cfset imageScaleToFit(img,500,500)>

        <cfset size = min(img.width,img.height)>
        <cfset x = int((img.width-size)/2)>
        <cfset y = int((img.height-size)/2)>
        <cfset imageCrop(img,x,y,size,size)>
        <cfset imageWrite(img,fileDetails.serverDirectory & "/" & fileDetails.serverFile)>

        <!-- Save session -->
        <cfset session.profilepath = fileDetails.serverFile>

        <!-- Save DB -->
        <cfquery datasource="#application.datasource#">
            UPDATE users
            SET profile_image_path =
            <cfqueryparam value="#fileDetails.serverFile#" cfsqltype="cf_sql_varchar">
            WHERE username =
            <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cflocation url="index.cfm?fuse=myprofile&msg=upload_success" addtoken="false">

        <cfcatch>
            <cflocation url="index.cfm?fuse=myprofile&msg=upload_fail" addtoken="false">
        </cfcatch>

    </cftry>
</cffunction>
<cffunction name="deleteProfilePic" access="public" returntype="void">

    <cfif structKeyExists(session,"profilepath") AND len(session.profilepath)>

        <cftry>
            <cffile action="delete" file="#expandPath('uploads/#session.profilepath#')#">

            <cfquery datasource="#application.datasource#">
                UPDATE users
                SET profile_image_path = NULL
                WHERE username =
                <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
            </cfquery>

            <cfset session.profilepath = "">

            <cflocation url="index.cfm?fuse=myprofile&msg=delete_success" addtoken="false">

            <cfcatch>
                <cflocation url="index.cfm?fuse=myprofile&msg=delete_fail" addtoken="false">
            </cfcatch>

        </cftry>
    </cfif>
</cffunction>
<cffunction name="updateAbout" access="public" returntype="void">
    <cfargument name="aboutText" required="true">

    <cfquery datasource="#application.datasource#">
        UPDATE users
        SET about =
        <cfqueryparam value="#arguments.aboutText#" cfsqltype="cf_sql_varchar">
        WHERE username =
        <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfset session.about = arguments.aboutText>

    <cflocation url="index.cfm?fuse=myprofile&msg=about_success" addtoken="false">
</cffunction>


    <!-- VIEWLOGS -->
    <cffunction name="viewlogs" access="public" returntype="struct">
        <cfset var data = {} />
        <cfquery name="logs" datasource="#application.datasource#">
            SELECT id, userName, action, description, action_time
            FROM action_logs
            ORDER BY action_time DESC
        </cfquery>
        <cfset data.logs = logs />
        <cfreturn data />
    </cffunction>

    <!-- REGISTERLIST -->
    <cffunction name="registerlist" access="public" returntype="struct">
        <cfset var data = {} />
        <cfquery name="list" datasource="#application.datasource#">
            SELECT id, username, email, isadmin
            FROM users
        </cfquery>
        <cfset data.list = list />
        <cfreturn data />
    </cffunction>

    <!-- SUBMITREQUEST (existing behavior) -->
    <cffunction name="submitrequest" access="public" returntype="struct">
        <cfset var data = {} />
        <cfset data.result = "" />

        <cfif structKeyExists(form, "submit")>
            <cftry>
                <cfif len(trim(form.department)) EQ 0 
                   OR len(trim(form.title)) EQ 0 
                   OR len(trim(form.description)) EQ 0>
                    <cfset data.result = "error">
                <cfelse>
                    <cfquery datasource="#application.datasource#">
                        INSERT INTO requests (username, department, title, description, action_time)
                        VALUES (
                            <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#form.department#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#form.title#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#form.description#" cfsqltype="cf_sql_longvarchar">,
                            NOW()
                        )
                    </cfquery>

                    <cfquery datasource="#application.datasource#">
                        INSERT INTO action_logs (username, action, description)
                        VALUES (
                            <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="CREATE" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="Created new request in #form.department#" cfsqltype="cf_sql_varchar">
                        )
                    </cfquery>

                    <cfset data.result = "success">
                </cfif>
                <cfcatch>
                    <cfset data.result = "error">
                </cfcatch>
            </cftry>
        </cfif>

        <cfreturn data />
    </cffunction>

    <!-- VIEWREQUESTS -->
    <cffunction name="viewrequests" access="public" returntype="struct">
        <cfset var data = {} />
        <cfquery name="requests" datasource="#application.datasource#">
            SELECT id, username, department, title, description, action_time
            FROM requests
            ORDER BY id DESC
        </cfquery>
        <cfset data.requests = requests />
        <cfreturn data />
    </cffunction>

    <!-- EDITREQUEST (return single request query in data.req) -->
    <cffunction name="editrequest" access="public" returntype="struct">
        <cfargument name="id" type="numeric" required="false" default="0">
        <cfset var data = {} />
        <cfparam name="url.id" default="#arguments.id#">
        <cfquery name="req" datasource="#application.datasource#">
            SELECT *
            FROM requests
            WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfset data.req = req />
        <cfreturn data />
    </cffunction>

    <!-- UPDATEREQUEST (used when form posts update) -->
    <cffunction name="updaterequest" access="public" returntype="struct">
        <cfargument name="id" type="numeric" required="false" default="0">
        <cfargument name="form" type="struct" required="false" default="#form#">
        <cfset var data = {} />
        <cfset data.result = "">

        <cfif NOT structKeyExists(arguments.form, "department") OR len(trim(arguments.form.department)) EQ 0
            OR NOT structKeyExists(arguments.form, "title") OR len(trim(arguments.form.title)) EQ 0
            OR NOT structKeyExists(arguments.form, "description") OR len(trim(arguments.form.description)) EQ 0>
            <cfset data.result = "failed">
            <cfreturn data />
        </cfif>

        <cftry>
            <cfquery datasource="#application.datasource#">
                UPDATE requests
                SET department  = <cfqueryparam value="#arguments.form.department#" cfsqltype="cf_sql_varchar">,
                    title       = <cfqueryparam value="#arguments.form.title#" cfsqltype="cf_sql_varchar">,
                    description = <cfqueryparam value="#arguments.form.description#" cfsqltype="cf_sql_longvarchar">
                WHERE id = <cfqueryparam value="#(isNumeric(arguments.id) and arguments.id GT 0 ? arguments.id : url.id)#" cfsqltype="cf_sql_integer">
            </cfquery>

            <cfquery datasource="#application.datasource#">
                INSERT INTO action_logs (userName, action, description)
                VALUES (
                    <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="EDIT" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="Edited request ID # (isNumeric(arguments.id) and arguments.id GT 0 ? arguments.id : url.id) #" cfsqltype="cf_sql_varchar">
                )
            </cfquery>

            <cfset data.result = "success">
            <cfcatch>
                <cfset data.result = "failed">
            </cfcatch>
        </cftry>

        <cfreturn data />
    </cffunction>

    <!-- DELETEREQUEST -->
    <cffunction name="deleterequest" access="public" returntype="struct">
        <cfargument name="id" type="numeric" required="true">
        <cfset var data = {} />
        <cfset data.result = "">
        <cftry>
            <cfquery datasource="#application.datasource#">
                DELETE FROM requests
                WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
            </cfquery>

            <cfquery datasource="#application.datasource#">
                INSERT INTO action_logs (userName, action, description)
                VALUES (
                    <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="DELETE" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="Deleted request ID: #arguments.id#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>

            <cfset data.result = "success">
            <cfcatch>
                <cfset data.result = "failed">
            </cfcatch>
        </cftry>

        <cfreturn data />
    </cffunction>

    <!-- REQUESTSAJAX (returns array of structs for JS) -->
    <cffunction name="requestsajax" access="public" returntype="array">
        <cfargument name="department" type="string" required="false" default="">
        <cfargument name="searchText" type="string" required="false" default="">
        <cfset var result = [] />
        <cfquery name="q" datasource="#application.datasource#">
            SELECT id, username, department, title, description, action_time
            FROM requests
            WHERE 1=1
            <cfif len(trim(arguments.department))>
                AND department = <cfqueryparam value="#arguments.department#" cfsqltype="cf_sql_varchar">
            </cfif>
            <cfif len(trim(arguments.searchText))>
                AND (
                    title LIKE <cfqueryparam value="%#arguments.searchText#%" cfsqltype="cf_sql_varchar">
                    OR description LIKE <cfqueryparam value="%#arguments.searchText#%" cfsqltype="cf_sql_varchar">
                )
            </cfif>
            ORDER BY id DESC
        </cfquery>

        <cfloop query="q">
            <cfset arrayAppend(result, {
                "id" = q.id,
                "username" = q.username,
                "department" = q.department,
                "title" = q.title,
                "description" = q.description,
                "date" = q.action_time
            })>
        </cfloop>

        <cfreturn result />
    </cffunction>

    <!-- GET ADMIN EMAIL -->
    <cffunction name="getAdminEmail" access="public" returntype="string">
        <cfquery name="q" datasource="#application.datasource#">
            SELECT email
            FROM users
            WHERE isadmin = 1
            LIMIT 1
        </cfquery>
        <cfreturn (q.recordCount ? q.email : "") />
    </cffunction>

    <cffunction name="getAllRequests" access="public" returntype="query">
    <cfargument name="department" required="false" default="">
    <cfargument name="searchText" required="false" default="">

    <cfquery name="q" datasource="#application.datasource#">
        SELECT
            id,
            department,
            title,
            description,
            action_time
        FROM requests
        WHERE 1 = 1

        <cfif trim(arguments.department) NEQ "">
            AND department = <cfqueryparam value="#arguments.department#" cfsqltype="cf_sql_varchar">
        </cfif>

        <cfif trim(arguments.searchText) NEQ "">
            AND (
                title LIKE <cfqueryparam value="%#arguments.searchText#%" cfsqltype="cf_sql_varchar">
                OR description LIKE <cfqueryparam value="%#arguments.searchText#%" cfsqltype="cf_sql_varchar">
            )
        </cfif>

        ORDER BY id DESC
    </cfquery>

    <cfreturn q>
</cffunction>




   <cffunction name="sendPDFMailToAdmin" access="public" returntype="void">
    <cfargument name="accessType" type="string" required="true">

    <!-- Get admin email -->
    <cfquery name="q" datasource="#application.datasource#">
        SELECT email FROM users WHERE isadmin = 1 LIMIT 1
    </cfquery>

    <cfif q.recordCount EQ 0>
        <cfreturn>
    </cfif>

    <cfset adminEmail = q.email>

    <!-- Send email -->
    <cfmail 
        to="#adminEmail#" 
        from="#session.email#" 
        subject="User PDF Access: #session.username#"
        type="html">

        <cfoutput>
            Hello Admin,<br><br>
            The user <strong>#session.username#</strong> has accessed the View Requests PDF.<br><br>
            Access Type : <strong>#arguments.accessType#</strong><br><br>
            Email : #session.email#<br>
            Date  : #dateFormat(now(),"dd-MM-yyyy")#<br>
            Time  : #timeFormat(now(),"hh:mm:ss tt")#
        </cfoutput>

    </cfmail>
   </cffunction>

           <!-- ================= CUSTOMERS (PDF ONLY) ================= -->

    <!-- USED BY customersPDF.cfm -->
    <cffunction name="getAllCustomers" access="public" returntype="query">
        <cfquery name="q" datasource="#application.datasource#">
            SELECT id, username, name, email, phone, created_at
            FROM customers
            ORDER BY id DESC
        </cfquery>
        <cfreturn q>
    </cffunction>

    <!-- USED BY customersPDF.cfm -->
    
<cffunction name="getCustomers" access="remote" returnFormat="json" output="false">
    <cfargument name="search" default="">
    <cfargument name="page" default="1">
    <cfargument name="pageSize" default="5">

    <cfreturn variables.customerService.getCustomers(
        search = arguments.search,
        page = arguments.page,
        pageSize = arguments.pageSize
    )>
</cffunction>
<cffunction name="getCustomer" access="remote" returnFormat="json" output="false">
    <cfargument name="id" required="true">

    <cfreturn variables.customerService.getCustomer(arguments.id)>
</cffunction>
<cffunction name="saveCustomer" access="remote" returnFormat="json" output="false">
    <cfargument name="id" default="">
    <cfargument name="name" required="true">
    <cfargument name="email" required="true">
    <cfargument name="phone" required="true">

    <cfreturn variables.customerService.saveCustomer(
        id = arguments.id,
        name = arguments.name,
        email = arguments.email,
        phone = arguments.phone
    )>
</cffunction>
<cffunction name="deleteCustomer" access="remote" returnFormat="json" output="false">
    <cfargument name="id" required="true">

    <cfreturn variables.customerService.deleteCustomer(arguments.id)>
</cffunction>

    <cffunction name="emailExists" access="remote" returnFormat="json" output="false">
    <cfargument name="email" required="true">
    <cfargument name="id" default="0">

    <cfreturn variables.customerService.emailExists(
        email = arguments.email,
        id = arguments.id
    )>
</cffunction>



</cfcomponent>
