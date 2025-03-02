<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="QuizHub.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- SweetAlert2 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

    <!-- SweetAlert2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .btn-custom {
            background-color: #5A9BC5;
            border-color: #5A9BC5;
            color: white;
            transition: background-color 0.3s, border-color 0.3s;
        }

            .btn-custom:hover {
                background-color: #3D7199; /* Darker shade for hover */
                border-color: #3D7199;
            }
    </style>


    <div class="container">
        <!-- Profile Details Section -->
        <div class="card mb-3">
            <div class="card-header">👤 View/Edit Profile</div>
            <div class="card-body">
                <div class="form-group">
                    <label for="userName">Name</label>
                    <input type="text" class="form-control" id="userName" runat="server">
                </div>
                <div class="form-group">
                    <label for="userEmail">Email</label>
                    <input type="email" class="form-control" id="userEmail" runat="server">
                </div>
                <asp:Button ID="btnSaveChanges" runat="server" CssClass="btn btn-custom btn-block"
                    Text="Save Changes" OnClientClick="return validateProfile();"
                    OnClick="btnSaveChanges_Click" />
            </div>
        </div>

        <!-- Change Password Section -->
        <div class="card">
            <div class="card-header">🔒 Change Password</div>
            <div class="card-body">
                <div class="form-group">
                    <label for="currentPassword">Current Password</label>
                    <input type="password" class="form-control" id="currentPassword" runat="server">
                </div>
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" class="form-control" id="newPassword" runat="server">
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" class="form-control" id="confirmPassword" runat="server">
                </div>
                <asp:Button ID="btnUpdatePassword" runat="server" CssClass="btn btn-custom btn-block"
                    Text="Update Password" OnClientClick="return validatePassword();"
                    OnClick="btnUpdatePassword_Click" />
            </div>
        </div>
    </div>
    <script>
        document.getElementById('<%= btnSaveChanges.ClientID %>').addEventListener('click', function (event) {
            let emailField = document.getElementById('<%= userEmail.ClientID %>');
            let email = emailField.value;
            let isValid = true;

            // Email Validation (Simple Regex)
            let emailPattern = /^[a-zA-Z][a-zA-Z0-9._%+-]*@gmail\.com$/;
            if (!emailPattern.test(email)) {
                emailField.style.borderColor = "red";
                emailField.style.backgroundColor = "#FFCCCC"; // Light red for invalid
                isValid = false;
            } else {
                emailField.style.borderColor = "#ced4da";
                emailField.style.backgroundColor = "white"; // Light green for valid
            }

            if (!isValid) {
                event.preventDefault(); // Prevent form submission if invalid
            }
        });

        document.getElementById('<%= btnUpdatePassword.ClientID %>').addEventListener('click', function (event) {
            let passwordField = document.getElementById('<%= newPassword.ClientID %>');
            let confirmPasswordField = document.getElementById('<%= confirmPassword.ClientID %>');
            let password = passwordField.value;
            let confirmPassword = confirmPasswordField.value;
            let isValid = true;



            // Password Validation (At least 8 chars, 1 uppercase, 1 lowercase, 1 number)
            let passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;

            if (!passwordPattern.test(password)) {
                passwordField.style.borderColor = "red";
                passwordField.style.backgroundColor = "#FFCCCC"; // Light red for invalid
                isValid = false;
            } else {
                passwordField.style.borderColor = "#ced4da";
                passwordField.style.backgroundColor = "white";
            }

            // Confirm Password Check
            if (password !== confirmPassword) {
                confirmPasswordField.style.borderColor = "red";
                confirmPasswordField.style.backgroundColor = "#FFCCCC"; // Light red for mismatch
                isValid = false;
                confirmPasswordField.value = "";
            } else {
                confirmPasswordField.style.borderColor = "#ced4da";
                confirmPasswordField.style.backgroundColor = "white";
            }

            // If validation fails, prevent form submission
            if (!isValid) {
                event.preventDefault();
            }
        });

    </script>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>
