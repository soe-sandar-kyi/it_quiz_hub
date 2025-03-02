<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="ResultManagement.aspx.cs" Inherits="QuizHub.Results" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .custom-table {
            border-collapse: collapse;
            width: 100%;
            border: 1px solid #ced4da;
        }

            .custom-table th {
                text-align: center;
                border: 1px solid gray; /* Remove all inner borders */
                padding: 4px 10px 4px 0px;
            }

            .custom-table td {
                border: 1px solid gray; /* Remove all inner borders */
                padding: 4px 10px 4px 0px;
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
    <h4 class="mb-4">Results</h4>

    <div class="container-fluid">
        <!-- Filters -->
        <div class="row mb-3 align-items-end">
            <div class="col-md-3">
                <label for="filterUser">User</label>
                <input type="text" class="form-control" id="txtFilterUser" placeholder="Enter user name" runat="server">
            </div>
            <div class="col-md-3">
                <label for="filterQuiz">Quiz</label>
                <input type="text" class="form-control" id="txtFilterQuiz" placeholder="Enter quiz title" runat="server">
            </div>
            <!-- Search Button Aligned Right -->
            <div class="col-md-6 d-flex justify-content-end">
                <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary"
                    Style="background-color: white; border-color: #34729C; color: #34729C;"
                    Text="Search" OnClick="btnSearch_Click" />
            </div>
        </div>
        <!-- Results Table -->
        <div class="fixed-table-container">

            <table class="custom-table table-hover">
                <thead class="text-white" style="background-color: #34729C;">
                    <tr>
                        <th style="width: 5%;">No.</th>
                        <th style="width: 20%;">User</th>
                        <th style="width: 20%;">Category</th>
                        <th style="width: 15%;">Level</th>
                        <th style="width: 12%;">Total Question</th>
                        <th style="width: 8%;">Score</th>
                        <th style="width: 10%;">Correct Answer</th>
                        <th style="width: 15%;">Date</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptCategories" runat="server">
                        <ItemTemplate>
                            <tr style="height: 5%">
                                <td style="text-align: center"><%# Eval("RowNum") %></td>
                                <td style="padding-left: 10px"><%# Eval("UserName") %></td>
                                <%-- Changed from User_Id to UserName --%>
                                <td style="padding-left: 10px"><%# Eval("CategoryName") %></td>
                                <%-- Changed from Category_Id to CategoryName --%>
                                <td style="padding-left: 10px"><%# Eval("LevelName") %></td>
                                <%-- Changed from Level_Id to LevelName --%>
                                <td style="padding-right: 10px; text-align: right;"><%# Eval("Total_Question") %></td>
                                <td style="padding-right: 10px; text-align: right;"><%# Eval("Score") %></td>
                                <td style="padding-right: 10px; text-align: right;"><%# Eval("Correct_Answer") %></td>
                                <td style="padding-right: 10px; text-align: right;"><%# Eval("AttemptedDate") %></td>
                                <%-- Renamed for better readability --%>
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
    </nav>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</asp:Content>
