<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="QuizHub.Settings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <h2 class="mb-4">Settings</h2>
    
    <div class="container-fluid">
        <div class="row">
            <!-- System Preferences -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">System Preferences</h5>
                        <form>
                            <div class="form-group">
                                <label for="quizTimer">Quiz Timer (minutes)</label>
                                <input type="number" class="form-control" id="quizTimer" value="30">
                            </div>
                            <div class="form-group">
                                <label for="gradingSystem">Grading System</label>
                                <select class="form-control" id="gradingSystem">
                                    <option>Percentage</option>
                                    <option>Letter Grade</option>
                                    <option>Pass/Fail</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </form>
                    </div>
                </div>
            </div>
            
            <!-- User Authentication -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">User Authentication</h5>
                        <form>
                            <div class="form-group">
                                <label for="passwordPolicy">Password Policy</label>
                                <select class="form-control" id="passwordPolicy">
                                    <option>Standard</option>
                                    <option>Strong (8+ chars, special chars, numbers)</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="twoFactor">Two-Factor Authentication</label>
                                <select class="form-control" id="twoFactor">
                                    <option>Disabled</option>
                                    <option>Enabled</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary">Update Settings</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        
    
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>
