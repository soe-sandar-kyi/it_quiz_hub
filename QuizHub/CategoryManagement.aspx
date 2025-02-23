<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="CategoryManagement.aspx.cs" Inherits="QuizHub.CategoryManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <h2 class="mb-4">Categories</h2>

    <div class="container-fluid">
        <!-- Add Quiz Button -->
        <div class="d-flex justify-content-end mb-3">
            <button class="btn btn-success" data-toggle="modal" data-target="#addQuizModal">Create Category</button>
        </div>
        <!-- Quizzes Table -->
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>

                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>1</td>
                    <td>Basic Math Quiz</td>

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
                    <h5 class="modal-title">Create New Category</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control" placeholder="Enter Category Name" required></asp:TextBox>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSaveCategory" runat="server" Text="Save" CssClass="btn btn-success" OnClick="btnSaveCategory_Click" />
                </div>
            </div>
        </div>
    </div>
    <label id="lblMessage" runat="server"></label>


    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>
