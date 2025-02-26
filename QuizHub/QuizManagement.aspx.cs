using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuizHub
{
    public partial class QuizManagement : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadQuestions();
                LoadCategories();
                LoadDifficultyLevels();
            }
        }
        private void LoadQuestions()
        {
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT Id,Question_Text,OptionA,OptionB,OptionC,OptionD,Correct_Answer,Category_Id,Level_Id FROM Question";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptCategories.DataSource = dt;
                rptCategories.DataBind();
            }
        }
        private void LoadCategories()
        {
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT Id, Name FROM Category";
                SqlCommand cmd = new SqlCommand(query, connection);

                try
                {
                    connection.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlCategory.DataSource = reader;
                    ddlCategory.DataTextField = "Name";
                    ddlCategory.DataValueField = "Id";
                    ddlCategory.DataBind();
                    reader.Close();
                }
                catch (Exception ex)
                {
                    // Handle the error
                }
            }
            //ddlCategory.Items.Insert(0, new ListItem("-- Select Category --", ""));
        }

        private void LoadDifficultyLevels()
        {
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT Id, Name FROM Level";
                SqlCommand cmd = new SqlCommand(query, connection);

                try
                {
                    connection.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlDifficulty.DataSource = reader;
                    ddlDifficulty.DataTextField = "Name";
                    ddlDifficulty.DataValueField = "Id";
                    ddlDifficulty.DataBind();
                    reader.Close();
                }
                catch (Exception ex)
                {
                    // Handle the error
                }
            }
            //ddlDifficulty.Items.Insert(0, new ListItem("-- Select Difficulty --", ""));
        }
        protected void btnSaveQuestion_Click(object sender, EventArgs e)
        {
            string questionText = txtQuestion.Text.Trim();
            string optionA = txtOptionA.Text.Trim();
            string optionB = txtOptionB.Text.Trim();
            string optionC = txtOptionC.Text.Trim();
            string optionD = txtOptionD.Text.Trim();
            string correctAnswer = ddlCorrectAnswer.SelectedValue;
            string categoryId = ddlCategory.SelectedValue;
            string levelId = ddlDifficulty.SelectedValue;

            if (!string.IsNullOrEmpty(questionText) && !string.IsNullOrEmpty(categoryId) && !string.IsNullOrEmpty(levelId))
            {
                string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO Question (Category_Id,Question_Text,OptionA,OptionB,OptionC,OptionD,Correct_Answer,Admin_Id,Created_Date,Level_Id) 
                             VALUES (@CategoryId,@QuestionText, @OptionA, @OptionB, @OptionC, @OptionD, @CorrectAnswer, @AdminId, @CreatedDate, @LevelId)";

                    SqlCommand cmd = new SqlCommand(query, connection);
                    cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                    cmd.Parameters.AddWithValue("@QuestionText", questionText);
                    cmd.Parameters.AddWithValue("@OptionA", optionA);
                    cmd.Parameters.AddWithValue("@OptionB", optionB);
                    cmd.Parameters.AddWithValue("@OptionC", optionC);
                    cmd.Parameters.AddWithValue("@OptionD", optionD);
                    cmd.Parameters.AddWithValue("@CorrectAnswer", correctAnswer);
                    cmd.Parameters.AddWithValue("@AdminId", "AID-1");
                    cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                    cmd.Parameters.AddWithValue("@LevelId", levelId);

                    try
                    {
                        connection.Open();
                        cmd.ExecuteNonQuery();

                        LoadQuestions();

                        ScriptManager.RegisterStartupScript(this, GetType(), "ShowSweetAlert",
                        "Swal.fire({ title: 'Success!', text: 'Category added successfully!', icon: 'success', confirmButtonText: 'OK' });", true);

                    }
                    catch (Exception ex)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "ShowErrorAlert",
     "Swal.fire({ title: 'Error!', text: '" + ex.Message + "', icon: 'error', confirmButtonText: 'OK' });", true);
                    }
                }

                // Clear fields
                txtQuestion.Text = txtOptionA.Text = txtOptionB.Text = txtOptionC.Text = txtOptionD.Text = "";
                ddlCorrectAnswer.SelectedIndex = 0;
                ddlCategory.SelectedIndex = 0;
                ddlDifficulty.SelectedIndex = 0;

                // Close the modal
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", "$('#addQuestionModal').modal('hide');", true);
            }
        }

    }
}
