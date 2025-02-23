<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="QuizManagement.aspx.cs" Inherits="QuizHub.QuizManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Font Awesome -->

    <h2 class="mb-4">Quiz Management</h2>

    <div class="container-fluid">
        <!-- Add Quiz Button -->
        <div class="d-flex justify-content-end mb-3">
            <button class="btn btn-success mb-3" data-toggle="modal" data-target="#addQuizModal">Create Quiz</button>
        </div>
        <!-- Quizzes Table -->
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Difficulty</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>1</td>
                    <td>Basic Math Quiz</td>
                    <td>Easy</td>
                    <td>Active</td>
                    <td>
                        <button class="btn btn-primary btn-sm" title="Edit"><i class="fas fa-edit"></i></button>
                        <button class="btn btn-danger btn-sm" title="Delete"><i class="fas fa-trash-alt"></i></button>
                        <button class="btn btn-warning btn-sm" title="Deactivate"><i class="fas fa-ban"></i></button>
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
                            <label for="quizTitle">Question</label>
                            <input type="text" class="form-control" id="quizTitle" required>
                        </div>
                        <div class="form-group">
                            <label for="quizCategory">Category</label>
                            <input type="text" class="form-control" id="quizCategory" required>
                        </div>
                        <div class="form-group">
                            <label for="quizDifficulty">Difficulty</label>
                            <select class="form-control" id="quizDifficulty">
                                <option>Easy</option>
                                <option>Medium</option>
                                <option>Hard</option>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="optionA">Option A</label>
                                    <input type="text" class="form-control" id="optionA" required>
                                </div>
                                <div class="form-group">
                                    <label for="optionB">Option B</label>
                                    <input type="text" class="form-control" id="optionB" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="optionC">Option C</label>
                                    <input type="text" class="form-control" id="optionC" required>
                                </div>
                                <div class="form-group">
                                    <label for="optionD">Option D</label>
                                    <input type="text" class="form-control" id="optionD" required>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="correctAnswer">Correct Answer</label>
                            <input type="text" class="form-control" id="correctAnswer" required>
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
