<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="QuizHub.Notifications" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <h2 class="mb-4">Notifications</h2>
    
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Recent Notifications</h5>
                        <ul class="list-group">
                            <li class="list-group-item">New quiz available: "Advanced Mathematics"</li>
                            <li class="list-group-item">Your quiz "Science Quiz" has been graded</li>
                            <li class="list-group-item">Reminder: "History Quiz" is due tomorrow</li>
                            <li class="list-group-item">System maintenance scheduled for this weekend</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>

