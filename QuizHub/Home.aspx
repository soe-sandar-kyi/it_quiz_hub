<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="QuizHub.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <style>
    .custom-jumbotron {
        background-color: #4BA3E2 !important; /* Custom background color */
        height: 250px; /* Adjust the height as needed */
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }

    .custom-jumbotron h1 {
        font-size: 2.5rem; /* Custom font size */
        font-weight: bold;
    }

    .custom-jumbotron p {
        font-size: 1.2rem;
        margin-bottom: 20px;
    }

</style>


    <div class="container-fluid mt-4">
        <!-- Welcome Message -->
        <div class="jumbotron text-center custom-jumbotron text-white">
            <h1>Welcome to QuizHub!</h1>
            <p>Test your IT knowledge with exciting quizzes on different topics. Improve your skills and challenge yourself today!</p>
            <asp:Button ID="btnTakeQuiz" runat="server" CssClass="btn btn-light btn-lg mt-2" Text="Take a Quiz" OnClick="btnTakeQuiz_Click" />
        </div>

        <div class="row">
            <!-- Popular Quizzes -->
            <div class="col-md-6">
                <div class="card shadow-lg">
                    <div class="card-body">
                        <h5 class="card-title">Popular Quizzes</h5>
                        <ul class="list-group" id="popularQuizzes">
                            <asp:Repeater ID="rptPopularQuizzes" runat="server">
                                <ItemTemplate>
                                    <li class="list-group-item"><%# Eval("CategoryName") %> - <%# Eval("QuizCount") %> Users</li>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Recent Quiz Results -->
            <div class="col-md-6">
                <div class="card shadow-lg">
                    <div class="card-body">
                        <h5 class="card-title">Recent Quiz Results</h5>
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Subject</th>
                                    <th>Level</th>
                                    <th>Score</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptRecentResults" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("CategoryName") %></td>
                                            <td><%# Eval("LevelName") %></td>
                                            <td><%# Eval("Score") %>%</td>
                                            <td><%# Eval("Attempted_Date", "{0:MMM dd, yyyy}") %></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>
