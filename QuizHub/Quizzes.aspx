<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Quizzes.aspx.cs" Inherits="QuizHub.Quizzes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <h2 class="mb-4">Quizzes</h2>
    
    <div class="container-fluid">
        <div class="row">
            <!-- Available Quizzes -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Available Quizzes</h5>
                        <ul class="list-group">
                            <li class="list-group-item">Math Quiz</li>
                            <li class="list-group-item">Science Quiz</li>
                            <li class="list-group-item">History Quiz</li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <!-- In-Progress Quizzes -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">In-Progress Quizzes</h5>
                        <ul class="list-group">
                            <li class="list-group-item">English Quiz - 50% completed</li>
                            <li class="list-group-item">Physics Quiz - 30% completed</li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <!-- Completed Quizzes -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Completed Quizzes</h5>
                        <ul class="list-group">
                            <li class="list-group-item">Math Quiz - 85%</li>
                            <li class="list-group-item">Biology Quiz - 90%</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>
