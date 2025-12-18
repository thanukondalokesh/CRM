<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
    <link rel="stylesheet" href="css/myprofile.css">
    <script src="scriptjs/myprofile.js"></script>
</head>

<body>

<div class="profile-container">
    <h2>My Profile</h2>

    <!-- ================= PROFILE IMAGE ================= -->
    <div class="image-section">
        <cfoutput>
            <img src="#data.imageURL#" class="profile-pic" onclick="viewImage()">
        </cfoutput>

        <button class="edit-btn" onclick="openModal()">Edit Photo</button>

        <a href="index.cfm?fuse=deleteProfilePic"
           onclick="return confirmDelete();"
           class="delete-photo">Remove Photo</a>
    </div>

    <!-- ================= USER INFO ================= -->
    <div class="info-section">
        <cfoutput>
            <p><b>Username:</b> #session.username#</p>
            <p><b>Email:</b> #session.email#</p>

            <div class="about-box">
                <p>
                    <b>About:</b>
                    <span id="aboutText">#session.about#</span>
                    <i class="edit-icon" onclick="editAbout()">✏️</i>
                </p>

                <form id="aboutForm"
                      method="post"
                      action="index.cfm?fuse=updateAbout"
                      style="display:none;">

                    <textarea name="aboutText" class="about-input">#session.about#</textarea>
                    <br>

                    <button type="submit" class="save-btn">Save</button>
                    <button type="button"
                            onclick="cancelAbout()"
                            class="cancel-btn">Cancel</button>
                </form>
            </div>
        </cfoutput>
    </div>

    <a href="index.cfm?fuse=home" class="forgot-link">← Back to Home</a>
</div>

<!-- ================= UPLOAD MODAL ================= -->
<div id="uploadModal" class="modal">
    <div class="modal-content">
        <h3>Change Profile Picture</h3>

        <form method="post"
              enctype="multipart/form-data"
              action="index.cfm?fuse=uploadProfilePic">

            <input type="file" name="uploadFile" accept="image/*" required><br><br>
            <button type="submit" class="save-btn">Upload</button>
        </form>

        <br>
        <button class="close-btn" onclick="closeModal()">Close</button>
    </div>
</div>

<!-- ================= VIEW FULL IMAGE ================= -->
<div id="viewImageModal" class="modal">
    <div class="image-view-box">
        <span class="close-full-img" onclick="closeImageView()">✖</span>

        <cfoutput>
            <img src="#data.imageURL#" id="fullImage" class="full-image">
        </cfoutput>
    </div>
</div>

<!-- ================= TOAST MESSAGE ================= -->
<cfif structKeyExists(url, "msg")>
    <div class="toast">
        <cfoutput>#url.msg#</cfoutput>
    </div>
</cfif>

</body>
</html>
