<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="UserManagement.aspx.cs" Inherits="QuizHub.UserManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- SweetAlert2 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

    <!-- SweetAlert2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .table-row-height {
            height: 10px;
        }

        .custom-table {
            border-collapse: collapse;
            width: 100%;
            border: 2px solid #ddd; /* Outside border */
            height: 90%;
        }

            .custom-table th,
            .custom-table td {
                border: none; /* Remove all inner borders */
                padding: 4px 0px 4px 0px;
                vertical-align: middle;
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

    <h4 class="mb-4">User Management</h4>

    <div class="container-fluid">
        <asp:HiddenField ID="hiddenUserId" runat="server" />

        <!-- Add Quiz Button -->
        <div class="d-flex justify-content-end mb-3">
            <button class="btn btn-outline-primary mb-3" data-toggle="modal" data-target="#addAdminModal" style="background-color:white;color:#34729C;border-color:#34729C;">Add User</button>
        </div>

        <!-- USers Table -->
        <div class="fixed-table-container">
            <table class="custom-table table-hover">
                <thead class="text-white" style="background-color: #34729C;">
                    <tr>
                        <th style="width: 8%; text-align: center">Id No</th>
                        <th style="width: 35%; text-align: left; padding-left: 16px;">Name</th>
                        <th style="width: 51%; text-align: left">Email</th>
                        <th style="width: 8%; text-align: left">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptUser" runat="server">
                        <ItemTemplate>
                            <tr style="height: 5%">
                                <td style="text-align: center"><%# Container.ItemIndex+1 %></td>
                                <td style="padding-left: 16px;""><%# Eval("Name") %></td>
                                <td><%# Eval("Email") %></td>
                                <td>
                                    <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn btn-outline-primary btn-sm"
                                        CommandName="EditUser" CommandArgument='<%# Eval("Id") + "," + Eval("Name") + "," + Eval("Email")%>'
                                        OnCommand="EditUser_Click"><i class="fas fa-edit"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-outline-danger btn-sm"
                                        OnClientClick='<%# "return confirmDelete(\"" + Eval("Id") + "\");" %>'
                                        CommandName="DeleteUser" CommandArgument='<%# Eval("Id") %>'><i class="fas fa-trash-alt"></i>
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
    <!-- Add/Edit Question Modal -->
    <div class="modal fade" id="addAdminModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Create New User</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <!-- Name Input -->
                    <div class="form-group">
                        <label for="txtName">Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                    </div>
                    <!-- Email Input -->
                    <div class="form-group">
                        <label for="txtEmail">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" required="required"></asp:TextBox>
                        <small id="emailError" class="text-danger"></small>
                    </div>

                    <!-- Password Input -->
                    <div class="form-group" id="password" runat="server">
                        <label for="txtPassword">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" required="required" TextMode="Password"></asp:TextBox>
                        <small id="passwordError" class="text-danger"></small>
                    </div>

                </div>

                <!-- Modal Footer with Save Button -->
                <div class="modal-footer">
                    <asp:Button ID="btnSaveUser" runat="server" Text="Save" CssClass="btn btn-success" OnClick="btnSaveUser_Click" />
                </div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('<%= btnSaveUser.ClientID %>').addEventListener('click', function (event) {
            let email = document.getElementById('<%= txtEmail.ClientID %>').value;
            let password = document.getElementById('<%= txtPassword.ClientID %>').value;
            let emailError = document.getElementById('emailError');
            let passwordError = document.getElementById('passwordError');
            let isValid = true;

            // Email Validation (Simple Regex)
            let emailPattern = /^[a-zA-Z][a-zA-Z0-9._%+-]*@gmail\.com$/;
            if (!emailPattern.test(email)) {
                emailError.textContent = "Invalid email format.";
                isValid = false;
            } else {
                emailError.textContent = "";
            }

            // Password Validation (At least 8 chars, 1 uppercase, 1 lowercase, 1 number)
            let passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
            if (!passwordPattern.test(password)) {
                passwordError.textContent = "Password must be at least 8 characters and contain uppercase, lowercase, and a number.";
                isValid = false;
            } else {
                passwordError.textContent = "";
            }

            if (!isValid) {
                event.preventDefault(); // Prevent form submission if invalid
            }
        });
</script>
    <script>
        function confirmDelete(categoryId) {
            Swal.fire({
                title: "Are you sure?",
                text: "You want to delete this admin!",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#d33",
                cancelButtonColor: "#3085d6",
                confirmButtonText: "Delete"
            }).then((result) => {
                if (result.isConfirmed) {
                    // Perform postback if confirmed
                    __doPostBack('<%= rptUser.UniqueID %>', categoryId);
                }
            });

            return false; // Prevent default postback
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>
