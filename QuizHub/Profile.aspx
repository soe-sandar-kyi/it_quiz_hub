<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="QuizHub.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
     <!-- SweetAlert2 CSS -->
 <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

 <!-- SweetAlert2 JS -->
 <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <h4>Profile</h4>

    <div class="container">
        <!-- Profile Details Section -->
        <div class="card mb-3">
            <div class="card-header">👤 View/Edit Profile</div>
            <div class="card-body">
                    <div class="form-group">
                        <label for="userName">Name</label>
                        <input type="text" class="form-control" id="userName" value="John Doe">
                    </div>
                    <div class="form-group">
                        <label for="userEmail">Email</label>
                        <input type="email" class="form-control" id="userEmail" value="john@example.com">
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Save Changes</button>
            </div>
        </div>

        <!-- Change Password Section -->
        <div class="card">
            <div class="card-header">🔒 Change Password</div>
            <div class="card-body">
                    <div class="form-group">
                        <label for="currentPassword">Current Password</label>
                        <input type="password" class="form-control" id="currentPassword">
                    </div>
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" class="form-control" id="newPassword">
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" class="form-control" id="confirmPassword">
                    </div>
                    <button type="submit" class="btn btn-danger btn-block">Update Password</button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>
