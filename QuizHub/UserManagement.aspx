<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="UserManagement.aspx.cs" Inherits="QuizHub.UserManagement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <h2 class="mb-4">User Management</h2>
    
    <div class="container-fluid">
        <!-- Users Table -->
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>1</td>
                    <td>John Doe</td>
                    <td>john@example.com</td>
                    <td>Student</td>
                    <td>
                        <button class="btn btn-primary btn-sm">Edit</button>
                        <button class="btn btn-danger btn-sm">Delete</button>
                    </td>
                </tr>
                <!-- More users will be dynamically loaded here -->
            </tbody>
        </table>
    </div>
    
    <!-- Add/Edit User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add/Edit User</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="form-group">
                            <label for="userName">Name</label>
                            <input type="text" class="form-control" id="userName" required>
                        </div>
                        <div class="form-group">
                            <label for="userEmail">Email</label>
                            <input type="email" class="form-control" id="userEmail" required>
                        </div>
                        <div class="form-group">
                            <label for="userRole">Role</label>
                            <select class="form-control" id="userRole">
                                <option>Admin</option>
                                <option>Teacher</option>
                                <option>Student</option>
                                <option>Guest</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-success">Save</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>

