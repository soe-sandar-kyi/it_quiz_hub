<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="QuizHub.Home" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <h2 class="mb-4">Welcome to QuizHub</h2>
    
    <div class="container-fluid">
        <!-- Welcome Message -->
        <div class="alert alert-info" role="alert">
            <h4 class="alert-heading">Hello, User!</h4>
            <p>Get ready to test your knowledge and improve your skills with exciting quizzes.</p>
        </div>
        
        <div class="row">
            <!-- Upcoming Quizzes -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Upcoming Quizzes</h5>
                        <ul class="list-group">
                            <li class="list-group-item">Math Quiz - Feb 20</li>
                            <li class="list-group-item">Science Quiz - Feb 25</li>
                            <li class="list-group-item">History Quiz - Mar 1</li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <!-- Recent Results -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Recent Results</h5>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Quiz</th>
                                    <th>Score</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Math Quiz</td>
                                    <td>85%</td>
                                </tr>
                                <tr>
                                    <td>Science Quiz</td>
                                    <td>90%</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Announcements -->
        <div class="mt-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Announcements</h5>
                    <p>New quiz topics coming soon! Stay tuned for exciting updates.</p>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>
