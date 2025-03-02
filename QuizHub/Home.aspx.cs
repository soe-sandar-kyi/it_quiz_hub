using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace QuizHub
{
    public partial class Home : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["QuizHubDB"].ConnectionString;
        private string userId;
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if userId is available in session
            if (Session["userId"] == null)
            {
                Response.Redirect("LandingPage.aspx"); // Redirect if not logged in
            }
            userId = Session["userId"].ToString();

            if (!IsPostBack)
            {
                LoadPopularQuizzes();
                LoadRecentResults();
            }
        }

        private void LoadPopularQuizzes()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"SELECT c.Name AS CategoryName, COUNT(r.User_Id) AS QuizCount 
                                 FROM Category c 
                                 INNER JOIN Result r ON c.Id = r.Category_Id 
                                 GROUP BY c.Name 
                                 ORDER BY COUNT(r.User_Id) DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptPopularQuizzes.DataSource = dt;
                rptPopularQuizzes.DataBind();
            }
        }

        private void LoadRecentResults()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"SELECT TOP 5 l.Name AS LevelName, c.Name AS CategoryName, r.Score, r.Attempted_Date 
                 FROM Result r 
                 INNER JOIN Level l ON r.Level_Id = l.Id 
                 INNER JOIN Category c ON r.Category_Id = c.Id 
                 WHERE r.User_Id = @UserId 
                 ORDER BY r.Attempted_Date DESC";


                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId); // Assuming user is logged in
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptRecentResults.DataSource = dt;
                rptRecentResults.DataBind();
            }
        }

        protected void btnTakeQuiz_Click(object sender, EventArgs e)
        {
            Response.Redirect("Quizzes.aspx");
        }
    }
}
