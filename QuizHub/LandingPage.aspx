<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LandingPage.aspx.cs" Inherits="QuizHub.LandingPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>Landing Page</h1>
            <asp:Button ID="btnSaveCategory" runat="server" Text="Admin Login" CssClass="btn btn-success"
                OnClick="btnLogin_Click" />
            <asp:Button ID="btnUserLogin" runat="server" Text="User Login" CssClass="btn btn-success"
                OnClick="btnUserLogin_Click" />
            <label id="lblMessage" runat="server"></label>
        </div>
    </form>
</body>
</html>
