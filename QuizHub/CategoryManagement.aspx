<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="CategoryManagement.aspx.cs" Inherits="QuizHub.CategoryManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- SweetAlert2 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

    <!-- SweetAlert2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
       .custom-table {
    border-collapse: collapse;
    width: 100%;
    border: 2px solid #ddd; /* Outside border */
}

    .custom-table th,
    .custom-table td {
        border: none; /* Remove all inner borders */
        padding: 4px 0px 4px 0px;
    }

    /* Add bottom border to each row */
    .custom-table tr {
        border-bottom: 1px solid #ddd;
    }

    /* Optional: If you want header row to have a stronger bottom border */
    .custom-table thead tr {
        border-bottom: 2px solid #ddd;
    }

    /* Optional: Add some padding or spacing to header cells for a cleaner look */
    .custom-table th {
        padding: 8px 0px 8px 0px;
    }


        .fixed-table-container {
            height: 450px;
            overflow-y: auto; /* Enable vertical scrolling */
            display: block; /* Allows scrolling within */
        }

            .fixed-table-container table {
                width: 100%; /* Ensure table takes full width */
                border-collapse: collapse; /* Optional: Improve styling */
            }


            .fixed-table-container thead {
                position: sticky;
                top: 0;
                background: #fff; /* Keep headers visible while scrolling */
                z-index: 1;
            }
            /* Custom Scrollbar Styles */
            .fixed-table-container::-webkit-scrollbar {
                width: 4px; /* Set scrollbar width */
                height: 4px; /* Set scrollbar height (for horizontal scrolling) */
            }

            .fixed-table-container::-webkit-scrollbar-thumb {
                background: #888; /* Scrollbar color */
                border-radius: 4px; /* Rounded edges */
            }

                .fixed-table-container::-webkit-scrollbar-thumb:hover {
                    background: #555; /* Darker color on hover */
                }
    </style>

    <h4 class="mb-4">Categories</h4>

    <div class="container-fluid">
        <asp:HiddenField ID="hiddenCategoryId" runat="server" />

        <!-- Add Category Button -->
        <div class="d-flex justify-content-end mb-3">
            <button class="btn btn-primary" data-toggle="modal" data-target="#addQuizModal" style="background-color:white;color:#34729C;border-color:#34729C;">Add Category</button>
        </div>

        <!-- Category Table -->
        <div class="fixed-table-container">
            <table class="custom-table table-hover">
                <thead class="text-white" style="background-color: #34729C;">
                    <tr>
                        <th style="width: 10%;">Category Id</th>
                        <th style="width: 84%; text-align: left; padding-left: 16px;">Category Name</th>
                        <th style="width: 8%; text-align: left">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptCategories" runat="server">
                        <ItemTemplate>
                            <tr class="table-row-height">
                                <td style="text-align: center;"><%# Eval("Id") %></td>
                                <td style="padding-left: 16px;"><%# Eval("Name") %></td>
                                <td>
                                    <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn btn-outline-primary btn-sm"
                                        CommandName="EditCategory" CommandArgument='<%# Eval("Id") + "," + Eval("Name") %>'
                                        OnCommand="EditCategory_Click"><i class="fas fa-edit"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-outline-danger btn-sm"
                                        OnClientClick='<%# "return confirmDelete(\"" + Eval("Id") + "\");" %>'
                                        CommandName="DeleteCategory" CommandArgument='<%# Eval("Id") %>'><i class="fas fa-trash-alt"></i>
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>

    </div>
    <!-- Pagination -->
    <nav style="padding-top: 8px;">
        <ul class="pagination justify-content-end">
            <li class="page-item" id="btnPrevious" runat="server">
                <asp:LinkButton ID="lnkPrevious" runat="server" CssClass="page-link" CommandArgument="Previous" OnCommand="ChangePage">« Previous</asp:LinkButton>
            </li>

            <asp:Repeater ID="rptPagination" runat="server">
                <ItemTemplate>
                    <li class='page-item <%# (Eval("PageNumber").ToString() == CurrentPage.ToString()) ? "active" : "disabled" %>'>
                        <a class="page-link disabled"><%# Eval("PageNumber") %></a>
                    </li>
                </ItemTemplate>
            </asp:Repeater>

            <li class="page-item" id="btnNext" runat="server">
                <asp:LinkButton ID="lnkNext" runat="server" CssClass="page-link" CommandArgument="Next" OnCommand="ChangePage">Next »</asp:LinkButton>
            </li>
        </ul>
    </nav>

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
                    <asp:Button ID="btnSaveCategory" runat="server" Text="Save" CssClass="btn btn-success"
                        OnClick="btnSaveCategory_Click" />
                </div>
            </div>
        </div>
    </div>
     <script>
         function confirmDelete(categoryId) {
             Swal.fire({
                 title: "Are you sure?",
                 text: "You want to delete this category!",
                 icon: "warning",
                 showCancelButton: true,
                 confirmButtonColor: "#d33",
                 cancelButtonColor: "#3085d6",
                 confirmButtonText: "Delete"
             }).then((result) => {
                 if (result.isConfirmed) {
                     // Perform postback if confirmed
                     __doPostBack('<%= rptCategories.UniqueID %>', categoryId);
             }
         });

             return false; // Prevent default postback
         }
     </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> 
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>
