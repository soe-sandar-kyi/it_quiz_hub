<%@ Page Title="" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Quizzes.aspx.cs" Inherits="QuizHub.Quizzes" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- SweetAlert2 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

    <!-- SweetAlert2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <h4>Quizzes</h4>
    <style>
        body {
            overflow: hidden;
        }
        h4 {
            color:#2b2b2b;
            /* Sticky header */
            position: sticky;
            top: 10px; /* Stick to the top */
            background: #6CB1DA; /* Background to prevent overlap */
            padding: 12px;
            border-radius: 10px; /* Border radius for rounded corners */
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1); /* Optional shadow for better visibility */
            z-index: 1000; /* Ensure it stays above other content */
        }


        .subject-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            padding: 20px;
        }

        .subject-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            padding: 20px;
        }

        .subject-card {
            background-color: #6CB1DA;
            color: black;
            font-weight: 500;
            padding: 20px;
            border-radius: 15px;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            width: 180px; /* Adjust width */
            height: 80px; /* Adjust height */
            text-decoration: none; /* Remove link underline */
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
        }

            /* 🔥 Hover Effect: Changes color, adds shadow & slight scale */
            .subject-card:hover {
                background-color: #5A9DC8; /* Slightly darker hover effect */
                transform: translateY(-3px); /* Slight upward motion */
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2); /* Soft shadow effect */
            }

            /* Active effect for better user interaction */
            .subject-card:active {
                transform: translateY(0px); /* Reset position when clicked */
                box-shadow: none;
            }

        .content-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .number-label {
            font-size: 20px;
            margin-top: 18px; /* Space between text */
        }

        .level-container {
            margin: 3%;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 28px;
            padding: 20px;
        }

        .level-card {
            background-color: #6CB1DA; /* Soft blue */
            color: black;
            font-size: 18px;
            font-weight: 500;
            padding: 15px 30px;
            border-radius: 25px;
            text-align: center;
            width: 250px;
            cursor: pointer; /* Makes it clear that it's clickable */
            transition: background-color 0.3s ease-in-out, transform 0.2s ease-in-out;
        }

            /* Hover effect */
            .level-card:hover {
                background-color: #34729C; /* Darker blue */
                color: white;
                transform: scale(1.05); /* Slight zoom effect */
            }

        .back-button {
            margin-left: 150px;
            background-color: #5A9DC8;
            color: white;
            font-size: 16px;
            font-weight: bold;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

            .back-button:hover {
                background-color: #34729C; /* Darker shade for hover effect */
                transform: scale(1.05);
            }

            .back-button:active {
                transform: scale(1);
            }

        /* Full-width quiz container */
        .quiz-container {
            width: 100%;
            margin-top: auto;
            padding: 10px;
            position: relative;
        }

        /* Style for each question box */
        .quiz-box {
            width: 95%;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 15px;
        }

        /* Beautiful radio button styles */
        .custom-radio input[type="radio"] {
            display: none;
        }

        .custom-radio label {
            display: flex;
            align-items: center;
            padding: 10px;
            margin: 5px 0;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
            font-size: 16px;
            border: 2px solid #ddd;
        }

            .custom-radio label:hover {
                background: #f0f0f0;
            }

        /* Custom radio button appearance */
        .custom-radio input[type="radio"] + label:before {
            content: "";
            width: 18px;
            height: 18px;
            border: 2px solid #555;
            border-radius: 50%;
            margin-right: 10px;
            transition: 0.3s;
        }

        .custom-radio input[type="radio"]:checked + label:before {
            background: #007BFF;
            border: 2px solid #007BFF;
        }

        /* Submit button styles */
        .submit-container {
            text-align: center;
        }

        .submit-btn {
            background: #34729C;
            color: white;
            font-size: 18px;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
            width: 500px;
            height: 40px;
            position: sticky;
            bottom: 20px; /* Stick to the bottom of the viewport */
            left: 50%; /* Center it horizontally */
            transform: translateX(-50%); /* Adjust for centering */
            z-index: 1000; /* Keep it above other elements */
        }

            .submit-btn:hover {
                background: #0056b3;
            }

        .no-question {
            position: absolute;
            top: 50%;
            left: 55%;
            transform: translate(-50%, -50%);
            text-align: center;
            font-size: 20px;
        }
    </style>
    <asp:HiddenField ID="hiddenCategoryId" runat="server" />
    <asp:HiddenField ID="hiddenLevelId" runat="server" />
    <asp:HiddenField ID="hfShowCategory" runat="server" />
    <asp:Button ID="btnPostback" runat="server" OnClick="btnPostback_Click" Style="display: none;" />

    <div class="subject-container" id="categoryContainer" runat="server">
        <asp:Repeater ID="rptSubjects" runat="server">
            <ItemTemplate>
                <asp:LinkButton CssClass="subject-card" CommandName="selectCategory"
                    CommandArgument='<%# Eval("Id") %>' runat="server" OnCommand="selectCategory_Click">
        <div class="content-wrapper">
            <span class="name-label"><%# Eval("Name") %></span>
        <span class="number-label"><%# Container.ItemIndex + 1 %></span>
        </div>
                </asp:LinkButton>
            </ItemTemplate>
        </asp:Repeater>
    </div>


    <div id="levelContainer" runat="server">
        <div class="level-container">
            <asp:Repeater ID="rptLevels" runat="server" OnItemCommand="rptLevels_ItemCommand">
                <ItemTemplate>
                    <asp:Button ID="btnSelect" runat="server" CssClass="level-card"
                        Text='<%# Eval("Name") %>' CommandName="Select" CommandArgument='<%# Eval("Id") %>' />
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Back Button -->
        <asp:Button ID="btnBack" runat="server" CssClass="back-button"
            Text="⬅ Back" OnClick="btnBack_Click" />
    </div>

    <div class="quiz-container" id="quizContainer" runat="server">
        <div class="quiz-container-box">
            <asp:ListView ID="lvQuestions" runat="server" OnItemDataBound="lvQuestions_ItemDataBound">
                <LayoutTemplate>
                    <div id="itemPlaceholder" runat="server"></div>
                </LayoutTemplate>
                <ItemTemplate>
                    <asp:HiddenField ID="hfQuestionId" runat="server" Value='<%# Eval("Id") %>' />
                    <div class="quiz-box">
                        <h3><%# Eval("Question_Text") %></h3>
                        <asp:RadioButtonList ID="rblOptions" runat="server" RepeatLayout="Flow" RepeatDirection="Vertical" CssClass="custom-radio"></asp:RadioButtonList>
                    </div>
                </ItemTemplate>
            </asp:ListView>
        </div>

        <!-- Submit Button -->
        <div class="submit-container">
            <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="submit-btn" OnClick="btnSubmit_Click" />
        </div>
    </div>

    <div id="noDataContainer" runat="server" visible="false" class="no-question">
        <label runat="server" id="noDataAlert" visible="false"></label>
    </div>


</asp:Content>
