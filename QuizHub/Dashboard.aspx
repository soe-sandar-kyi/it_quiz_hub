<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="QuizHub.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    

       <!--Css -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .card { margin-bottom: 20px; }
        .chart-container { height: 300px; }

        .btn-primary {
             background-color: #00cc99 !important;
             border-color: #00cc99 !important;

        }

        .btn-primary:hover {
             background-color: #009977 !important;
             border-color: #009977 !important;
        }

    </style>

    
    <h2 class="mb-4">Admin Dashboard</h2>
    <div class="container-fluid mt-4">
    
    <div class="row">
        <!-- Overview Cards -->
        <div class="col-md-4">
            <div class="card text-white bg-primary">
                <div class="card-body">
                    <h5 class="card-title">Total Users</h5>
                    <p class="card-text" id="totalUsers">Loading...</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-success">
                <div class="card-body">
                    <h5 class="card-title">Total Categories</h5>
                    <p class="card-text" id="activeQuizzes">Loading...</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-warning">
                <div class="card-body">
                    <h5 class="card-title">Total Quizzes</h5>
                    <p class="card-text" id="recentResults">Loading...</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts Section -->
    <div class="row">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Quiz Participation</h5>
                    <canvas id="quizChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="row mt-4">
        <div class="col-md-12">
            <button class="btn btn-primary">Create New Quiz</button>
            <button class="btn btn-secondary">Manage Users</button>
        </div>
    </div>
</div>

<script>
    // Sample Data for Charts
    var ctx = document.getElementById('quizChart').getContext('2d');
    var quizChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Quiz 1', 'Quiz 2', 'Quiz 3', 'Quiz 4'],
            datasets: [{
                label: 'Participants',
                data: [12, 19, 3, 5],
                backgroundColor: 'rgba(54, 162, 235, 0.6)'
            }]
        }
    });
</script>
</asp:Content>



