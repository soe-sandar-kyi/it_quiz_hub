<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="QuizManagement.aspx.cs" Inherits="QuizHub.QuizManagement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <h2 class="mb-4">Quiz Management</h2>
    
    <div class="container-fluid">
        <!-- Add Quiz Button -->
        <button class="btn btn-success mb-3" data-toggle="modal" data-target="#addQuizModal">Create New Quiz</button>
        
        <!-- Quizzes Table -->
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Topic</th>
                    <th>Difficulty</th>
                    <th>Duration</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>1</td>
                    <td>Basic Math Quiz</td>
                    <td>Mathematics</td>
                    <td>Easy</td>
                    <td>15 mins</td>
                    <td>Active</td>
                    <td>
                        <button class="btn btn-primary btn-sm">Edit</button>
                        <button class="btn btn-danger btn-sm">Delete</button>
                        <button class="btn btn-warning btn-sm">Deactivate</button>
                    </td>
                </tr>
                <!-- More quizzes will be dynamically loaded here -->
            </tbody>
        </table>
    </div>
    
    <!-- Add/Edit Quiz Modal -->
    <div class="modal fade" id="addQuizModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Create/Edit Quiz</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="form-group">
                            <label for="quizTitle">Quiz Title</label>
                            <input type="text" class="form-control" id="quizTitle" required>
                        </div>
                        <div class="form-group">
                            <label for="quizTopic">Topic</label>
                            <input type="text" class="form-control" id="quizTopic" required>
                        </div>
                        <div class="form-group">
                            <label for="quizDifficulty">Difficulty</label>
                            <select class="form-control" id="quizDifficulty">
                                <option>Easy</option>
                                <option>Medium</option>
                                <option>Hard</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="quizDuration">Duration (mins)</label>
                            <input type="number" class="form-control" id="quizDuration" required>
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


