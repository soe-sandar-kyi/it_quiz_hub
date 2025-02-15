<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="QuizHub.Profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <h2 class="mb-4">Profile</h2>
    
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">View/Edit Profile</h5>
                        <form>
                            <div class="form-group">
                                <label for="userName">Name</label>
                                <input type="text" class="form-control" id="userName" value="John Doe">
                            </div>
                            <div class="form-group">
                                <label for="userEmail">Email</label>
                                <input type="email" class="form-control" id="userEmail" value="john@example.com">
                            </div>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Change Password</h5>
                        <form>
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
                            <button type="submit" class="btn btn-primary">Update Password</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>
