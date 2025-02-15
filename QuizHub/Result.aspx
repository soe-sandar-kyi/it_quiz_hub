<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Result.aspx.cs" Inherits="QuizHub.Result" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <h2 class="mb-4">Results & Reports</h2>
    
    <div class="container-fluid">
        <!-- Filters -->
        <div class="row mb-3">
            
            <div class="col-md-3">
                <label for="filterQuiz">Quiz</label>
                <input type="text" class="form-control" id="filterQuiz" placeholder="Enter quiz title">
            </div>
            
        </div>
        
        <!-- Results Table -->
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>User</th>
                    <th>Quiz</th>
                    <th>Score</th>                    
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>John Doe</td>
                    <td>Basic Math Quiz</td>
                    <td>85%</td>
                </tr>
                <!-- More results will be dynamically loaded here -->
            </tbody>
        </table>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>
