<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="CategoryManagement.aspx.cs" Inherits="QuizHub.CategoryManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <h2 class="mb-4">Categories</h2>

    <div class="container-fluid">
        <!-- Add Category Button -->
        <div class="d-flex justify-content-end mb-3">
            <button class="btn btn-success" data-toggle="modal" data-target="#addQuizModal">Create Category</button>
        </div>

        <!-- Category Table -->

        <table class="table table-bordered table-hover">
            <thead class="bg-success text-white">
                <tr>
                    <th style="width: 10%;">Category Id</th>
                    <th style="width: 60%;">Category Name</th>
                    <th style="width: 30%;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="rptCategories" runat="server">
                    <ItemTemplate>
                        <tr style="height:5%">
                            <td><%# Eval("Id") %></td>
                            <td><%# Eval("Name") %></td>
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

        <!-- Pagination -->
        <nav>
            <ul class="pagination justify-content-end">
                <li class="page-item disabled"><a class="page-link">« Previous</a></li>
                <li class="page-item active"><a class="page-link">1</a></li>
                <li class="page-item"><a class="page-link">2</a></li>
                <li class="page-item"><a class="page-link">Next »</a></li>
            </ul>
        </nav>
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
                    <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control" placeholder="Enter Category Name" required="required"></asp:TextBox>
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
