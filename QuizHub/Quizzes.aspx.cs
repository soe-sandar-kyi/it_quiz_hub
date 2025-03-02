using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuizHub
{
    public partial class Quizzes : System.Web.UI.Page
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
                LoadLevels();
                LoadCategories();
                levelContainer.Visible = false;
                quizContainer.Visible = false;
                noDataAlert.Visible = false;
                btnSubmit.Visible = false;
            }
        }
        private void LoadCategories()
        {
            string query = "SELECT Id,Name FROM Category";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                rptSubjects.DataSource = reader;
                rptSubjects.DataBind();
            }
        }

        private void LoadLevels()
        {
            string query = "SELECT Id,Name FROM Level";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                rptLevels.DataSource = reader;
                rptLevels.DataBind();
            }
        }

        protected void selectCategory_Click(object sender, CommandEventArgs e)
        {
            string[] args = e.CommandArgument.ToString().Split(',');
            if (args.Length == 1)
            {
                categoryContainer.Visible = false;
                levelContainer.Visible = true;
                quizContainer.Visible = false;
                hiddenCategoryId.Value = args[0];
                noDataAlert.Visible = false;
                btnSubmit.Visible = false;
            }
        }

        protected void rptLevels_ItemCommand(object source, CommandEventArgs e)
        {
            string[] args = e.CommandArgument.ToString().Split(',');

            if (e.CommandName == "Select")
            {
                string levelName = e.CommandArgument.ToString();
                hiddenLevelId.Value = args[0];
                categoryContainer.Visible = false;
                levelContainer.Visible = false;
                quizContainer.Visible = true;
                noDataAlert.Visible = false;
                btnSubmit.Visible = true;

                LoadQuestions();
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            categoryContainer.Visible = true;
            levelContainer.Visible = false;
            quizContainer.Visible = false;
            hiddenCategoryId.Value = "";
            hiddenLevelId.Value = "";
            noDataAlert.Visible = false;
        }

        private void LoadQuestions()
        {
            string categoryId = hiddenCategoryId.Value;
            string levelId = hiddenLevelId.Value;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT Id, Question_Text, OptionA, OptionB, OptionC, OptionD FROM Question WHERE Category_Id = @CategoryId AND Level_Id = @LevelId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                    cmd.Parameters.AddWithValue("@LevelId", levelId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    if (da == null)
                    {
                        noDataContainer.Visible = true;
                        quizContainer.Visible = false;
                        btnSubmit.Visible = false;
                        noDataAlert.InnerText = "Here is no question";
                        return;
                    }
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    // ✅ Check if there are no questions
                    if (dt.Rows.Count == 0)
                    {
                        noDataContainer.Visible = true; // Show the no-data message
                        noDataAlert.Visible = true;
                        quizContainer.Visible = false;
                        btnSubmit.Visible = false;
                        noDataAlert.InnerText = "Here is no question";
                    }
                    else
                    {
                        noDataContainer.Visible = false;
                        quizContainer.Visible = true;
                        btnSubmit.Visible = true;
                        noDataAlert.Visible = false;
                        lvQuestions.DataSource = dt;
                        lvQuestions.DataBind();
                    }
                }
            }
        }


        // ✅ Bind Options Inside `ItemDataBound`
        protected void lvQuestions_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            if (e.Item.ItemType == ListViewItemType.DataItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                RadioButtonList rblOptions = (RadioButtonList)e.Item.FindControl("rblOptions");
                HiddenField hfQuestionId = (HiddenField)e.Item.FindControl("hfQuestionId");

                hfQuestionId.Value = row["Id"].ToString(); // Set question ID

                // Bind options
                rblOptions.Items.Add(new ListItem(row["OptionA"].ToString(), "A"));
                rblOptions.Items.Add(new ListItem(row["OptionB"].ToString(), "B"));
                rblOptions.Items.Add(new ListItem(row["OptionC"].ToString(), "C"));
                rblOptions.Items.Add(new ListItem(row["OptionD"].ToString(), "D"));
            }
        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int correctCount = 0;
            int totalQuestions = lvQuestions.Items.Count;
            int scorePercentage;
            DateTime attemptedDate = DateTime.Now;
            string levelId = hiddenLevelId.Value.ToString();
            string categoryId = hiddenCategoryId.Value.ToString();


            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                foreach (ListViewItem item in lvQuestions.Items)
                {
                    // Get Question ID
                    HiddenField hfQuestionId = (HiddenField)item.FindControl("hfQuestionId");
                    int questionId = Convert.ToInt32(hfQuestionId.Value);

                    // Get selected answer
                    RadioButtonList rblOptions = (RadioButtonList)item.FindControl("rblOptions");
                    string selectedAnswer = rblOptions.SelectedValue;

                    if (!string.IsNullOrEmpty(selectedAnswer))
                    {
                        // Retrieve correct answer from database
                        string query = "SELECT Correct_Answer FROM Question WHERE Id = @QuestionId";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@QuestionId", questionId);
                            string correctAnswer = cmd.ExecuteScalar().ToString();

                            // Compare answers
                            if (selectedAnswer == correctAnswer)
                            {
                                correctCount++;
                            }
                        }
                    }
                }

                // Calculate score percentage
                scorePercentage = (totalQuestions > 0) ? (correctCount * 100) / totalQuestions : 0;

                // 🔹 Insert quiz result into Result table
                string insertQuery = @"INSERT INTO Result (User_Id, Level_Id, Total_Question, Correct_Answer, Score, Attempted_Date, Category_Id)
                               VALUES (@UserId, @LevelId, @TotalQuestion, @CorrectAnswer, @Score, @AttemptedDate, @CategoryId)";
                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@LevelId", levelId);
                    cmd.Parameters.AddWithValue("@TotalQuestion", totalQuestions);
                    cmd.Parameters.AddWithValue("@CorrectAnswer", correctCount);
                    cmd.Parameters.AddWithValue("@Score", scorePercentage);
                    cmd.Parameters.AddWithValue("@AttemptedDate", attemptedDate);
                    cmd.Parameters.AddWithValue("@CategoryId", categoryId);

                    cmd.ExecuteNonQuery();
                }
            }


            // Set a hidden field value to trigger postback
            hfShowCategory.Value = "true";

            //Use Dummy Button Click to Force Postback
            string script = $"Swal.fire({{ " +
                            $"title: 'Quiz Completed!', " +
                            $"text: 'You scored {correctCount} out of {totalQuestions} ({scorePercentage}%)', " +
                            $"icon: 'success', " +
                            $"confirmButtonText: 'OK' " +
                            $"}}).then(function() {{ document.getElementById('{btnPostback.ClientID}').click(); }});";


            ScriptManager.RegisterStartupScript(this, GetType(), "ShowQuizResult", script, true);

        }
        protected void btnPostback_Click(object sender, EventArgs e)
        {
            if (hfShowCategory.Value == "true")
            {
                categoryContainer.Visible = true; // Show category container
                quizContainer.Visible = false;
                btnSubmit.Visible = false;
                hfShowCategory.Value = "";
            }
        }

    }
}