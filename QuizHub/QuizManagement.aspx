<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="QuizManagement.aspx.cs" Inherits="QuizHub.QuizManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- SweetAlert2 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

    <!-- SweetAlert2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <h2 class="mb-4">Quiz Management</h2>

    <div class="container-fluid">
        <!-- Add Quiz Button -->
        <div class="d-flex justify-content-end mb-3">
            <button class="btn btn-success mb-3" data-toggle="modal" data-target="#addQuestionModal">Create Quiz</button>
        </div>

        <!-- Quizzes Table -->
        <table class="table table-bordered table-hover">
            <thead class="text-white" style="background-color:#1abc9c">
                <tr>
                    <th style="width: 5%;">No</th>
                    <th style="width: 20%;">Question</th>
                    <th style="width: 10%;">Option A</th>
                    <th style="width: 10%;">Option B</th>
                    <th style="width: 10%;">Option C</th>
                    <th style="width: 10%;">Option D</th>
                    <th style="width: 5%;">Answer</th>
                    <th style="width: 5%;">Category</th>
                    <th style="width: 10%;">Level</th>
                    <th style="width: 15%;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="rptCategories" runat="server">
                    <ItemTemplate>
                        <tr style="height: 5%">
                            <td><%# Eval("Id") %></td>
                            <td><%# Eval("Question_Text") %></td>
                            <td><%# Eval("OptionA") %></td>
                            <td><%# Eval("OptionB") %></td>
                            <td><%# Eval("OptionC") %></td>
                            <td><%# Eval("OptionD") %></td>
                            <td><%# Eval("Correct_Answer") %></td>
                            <td><%# Eval("Category_Id") %></td>
                            <td><%# Eval("Level_Id") %></td>
                            <td>
                                <button class="btn btn-primary btn-sm" title="Edit" onclick="editCategory('<%# Eval("Id") %>')">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-danger btn-sm" title="Delete" onclick="deleteCategory('<%# Eval("Id") %>')">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                                <button class="btn btn-warning btn-sm" title="Deactivate" onclick="toggleCategoryStatus('<%# Eval("Id") %>')">
                                    <i class="fas fa-ban"></i>
                                </button>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
    </div>

    <!-- Add/Edit Question Modal -->
    <div class="modal fade" id="addQuestionModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Create New Question</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <!-- Question Input -->
                    <div class="form-group">
                        <label for="txtQuestion">Question</label>
                        <asp:TextBox ID="txtQuestion" runat="server" CssClass="form-control" required></asp:TextBox>
                    </div>

                    <!-- Options Row 1: Option A & Option B -->
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Option A</label>
                            <asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control" required></asp:TextBox>
                        </div>
                        <div class="form-group col-md-6">
                            <label>Option B</label>
                            <asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control" required></asp:TextBox>
                        </div>
                    </div>

                    <!-- Options Row 2: Option C & Option D -->
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Option C</label>
                            <asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control" required></asp:TextBox>
                        </div>
                        <div class="form-group col-md-6">
                            <label>Option D</label>
                            <asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control" required></asp:TextBox>
                        </div>
                    </div>

                    <!-- Correct Answer Dropdown -->
                    <div class="form-group">
                        <label>Correct Answer</label>
                        <asp:DropDownList ID="ddlCorrectAnswer" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Option A" Value="A"></asp:ListItem>
                            <asp:ListItem Text="Option B" Value="B"></asp:ListItem>
                            <asp:ListItem Text="Option C" Value="C"></asp:ListItem>
                            <asp:ListItem Text="Option D" Value="D"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Category & Difficulty in One Row -->
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Category</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control"></asp:DropDownList>
                        </div>
                        <div class="form-group col-md-6">
                            <label>Difficulty</label>
                            <asp:DropDownList ID="ddlDifficulty" runat="server" CssClass="form-control"></asp:DropDownList>
                        </div>
                    </div>
                </div>

                <!-- Modal Footer with Save Button -->
                <div class="modal-footer">
                    <asp:Button ID="btnSaveQuestion" runat="server" Text="Save" CssClass="btn btn-success" OnClick="btnSaveQuestion_Click" />
                </div>
            </div>
        </div>
    </div>


    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>
