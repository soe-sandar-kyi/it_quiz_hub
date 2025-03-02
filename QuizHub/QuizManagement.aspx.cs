using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuizHub
{
    public partial class QuizManagement : Page
    {
        private int pageSize = 10;  // Number of rows per page
        private int currentPage;// Current page
        private int totalRecords = 0; // Total rows in DB
        private int totalPages = 0; // Total number of pages
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                currentPage = 1; // Initialize only on first load
                ViewState["CurrentPage"] = currentPage; // Store in ViewState
                LoadQuestions();
                LoadCategories();
                LoadDifficultyLevels();
            }
            else
            {
                // Retrieve page number from ViewState on postbacks
                currentPage = (int)ViewState["CurrentPage"];
            }

            string eventTarget = Request["__EVENTTARGET"];
            string eventArgument = Request["__EVENTARGUMENT"];

            if (!string.IsNullOrEmpty(eventTarget) && eventTarget == rptQuestions.UniqueID)
            {
                DeleteQuestion(eventArgument);
            }
        }

        public int CurrentPage
        {
            get { return currentPage; }
        }

        private void LoadQuestions()
        {
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Count total records in Question table
                string countQuery = "SELECT COUNT(*) FROM Question";
                SqlCommand countCmd = new SqlCommand(countQuery, conn);
                totalRecords = (int)countCmd.ExecuteScalar();

                totalPages = (int)Math.Ceiling((double)totalRecords / pageSize);
                int startRow = (currentPage - 1) * pageSize;

                // Add ROW_NUMBER() to generate serial numbers
                string query = $@"
            SELECT ROW_NUMBER() OVER (ORDER BY Id) AS RowNum, 
                   Id, Question_Text, OptionA, OptionB, OptionC, OptionD, Correct_Answer, Category_Id, Level_Id 
            FROM Question 
            ORDER BY Id 
            OFFSET {startRow} ROWS FETCH NEXT {pageSize} ROWS ONLY";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptQuestions.DataSource = dt;
                rptQuestions.DataBind();

                UpdatePaginationUI();
            }
        }


        private void UpdatePaginationUI()
        {
            btnPrevious.Visible = (currentPage > 1);
            btnNext.Visible = (currentPage < totalPages);

            DataTable paginationTable = new DataTable();
            paginationTable.Columns.Add("PageNumber", typeof(int));

            for (int i = 1; i <= totalPages; i++)
            {
                paginationTable.Rows.Add(i);
            }

            rptPagination.DataSource = paginationTable;
            rptPagination.DataBind();
        }

        // Handle Page Change (Previous/Next)
        protected void ChangePage(object sender, CommandEventArgs e)
        {
            if (e.CommandArgument.ToString() == "Next")
                currentPage++;
            else if (e.CommandArgument.ToString() == "Previous" && currentPage > 1)
                currentPage--;

            ViewState["CurrentPage"] = currentPage; // Store updated page number
            LoadQuestions();
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
                    ddlLevel.DataSource = reader;
                    ddlLevel.DataTextField = "Name";
                    ddlLevel.DataValueField = "Id";
                    ddlLevel.DataBind();
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
            string questionId = hiddenQuestionId.Value; // Retrieve hidden ID
            string questionText = txtQuestion.Text.Trim();
            string optionA = txtOptionA.Text.Trim();
            string optionB = txtOptionB.Text.Trim();
            string optionC = txtOptionC.Text.Trim();
            string optionD = txtOptionD.Text.Trim();
            string correctAnswer = ddlCorrectAnswer.SelectedValue;
            string categoryId = ddlCategory.SelectedValue;
            string levelId = ddlLevel.SelectedValue;

            if (!string.IsNullOrEmpty(questionText) && !string.IsNullOrEmpty(categoryId) && !string.IsNullOrEmpty(levelId))
            {
                string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string query;
                    SqlCommand cmd;

                    if (!string.IsNullOrEmpty(questionId)) // **Update existing question**
                    {
                        query = @"UPDATE Question SET 
                            Question_Text = @QuestionText, 
                            OptionA = @OptionA, 
                            OptionB = @OptionB, 
                            OptionC = @OptionC, 
                            OptionD = @OptionD, 
                            Correct_Answer = @CorrectAnswer, 
                            Category_Id = @CategoryId, 
                            Level_Id = @LevelId 
                          WHERE Id = @QuestionId";

                        cmd = new SqlCommand(query, connection);
                        cmd.Parameters.AddWithValue("@QuestionId", questionId);
                    }
                    else // **Insert new question**
                    {
                        query = @"INSERT INTO Question (Category_Id, Question_Text, OptionA, OptionB, OptionC, OptionD, Correct_Answer, Admin_Id, Created_Date, Level_Id) 
                          VALUES (@CategoryId, @QuestionText, @OptionA, @OptionB, @OptionC, @OptionD, @CorrectAnswer, @AdminId, @CreatedDate, @LevelId)";

                        cmd = new SqlCommand(query, connection);
                        cmd.Parameters.AddWithValue("@AdminId", "AID-1"); // Static Admin ID
                        cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                    }

                    // **Common Parameters for Both Insert & Update**
                    cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                    cmd.Parameters.AddWithValue("@QuestionText", questionText);
                    cmd.Parameters.AddWithValue("@OptionA", optionA);
                    cmd.Parameters.AddWithValue("@OptionB", optionB);
                    cmd.Parameters.AddWithValue("@OptionC", optionC);
                    cmd.Parameters.AddWithValue("@OptionD", optionD);
                    cmd.Parameters.AddWithValue("@CorrectAnswer", correctAnswer);
                    cmd.Parameters.AddWithValue("@LevelId", levelId);

                    try
                    {
                        cmd.ExecuteNonQuery();
                        LoadQuestions(); // Refresh table

                        string successMessage = (!string.IsNullOrEmpty(questionId)) ?
                            "Question updated successfully!" : "Question added successfully!";

                        ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
                        "Swal.fire({ title: 'Success!', text: '" + successMessage + "', icon: 'success', confirmButtonText: 'OK' });", true);
                    }
                    catch (Exception ex)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
                        "Swal.fire({ title: 'Error!', text: '" + ex.Message + "', icon: 'error', confirmButtonText: 'OK' });", true);
                    }
                }

                // **Reset Fields & Close Modal**
                hiddenQuestionId.Value = "";
                txtQuestion.Text = txtOptionA.Text = txtOptionB.Text = txtOptionC.Text = txtOptionD.Text = "";
                ddlCorrectAnswer.SelectedIndex = 0;
                ddlCategory.SelectedIndex = 0;
                ddlLevel.SelectedIndex = 0;
                btnSaveQuestion.Text = "Save"; // Reset button text

                ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", "$('#addQuestionModal').modal('hide');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
                "Swal.fire({ title: 'Error!', text: 'Please fill in all required fields!', icon: 'error', confirmButtonText: 'OK' });", true);
            }
        }


        protected void EditQuestion_Click(object sender, CommandEventArgs e)
        {
            string[] args = e.CommandArgument.ToString().Split(',');
            if (args.Length == 9) // Ensure all values are received
            {
                string questionId = args[0];
                string questionText = args[1];
                string optionA = args[2];
                string optionB = args[3];
                string optionC = args[4];
                string optionD = args[5];
                string correctAnswer = args[6];
                string categoryId = args[7];
                string levelId = args[8];

                // Store values in hidden field and text box
                hiddenQuestionId.Value = questionId;
                txtQuestion.Text = questionText;
                txtOptionA.Text = optionA;
                txtOptionB.Text = optionB;
                txtOptionC.Text = optionC;
                txtOptionD.Text = optionD;
                ddlCorrectAnswer.SelectedValue = correctAnswer;
                ddlCategory.SelectedValue = categoryId;
                ddlLevel.SelectedValue = levelId;

                // Change button text to "Update"
                btnSaveQuestion.Text = "Update";
                btnSaveQuestion.CommandName = "UpdateQuestion";

                // Show the modal
                ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal", "$('#addQuestionModal').modal('show');", true);
            }
        }


        private void DeleteQuestion(string questionId)
        {
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "DELETE FROM Question WHERE Id = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", questionId);

                try
                {
                    cmd.ExecuteNonQuery();
                    LoadQuestions(); // Refresh the table

                    // Show success alert
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
                        "Swal.fire({ title: 'Deleted!', text: 'Category deleted successfully.', icon: 'success' });",
                        true);
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
                        "Swal.fire({ title: 'Error!', text: '" + ex.Message + "', icon: 'error' });",
                        true);
                }
            }
        }
    }
}
