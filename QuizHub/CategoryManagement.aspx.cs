using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuizHub
{
    public partial class CategoryManagement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnSaveCategory_Click(object sender, EventArgs e)
        {
            string categoryName = txtCategoryName.Text.Trim();
            if (!string.IsNullOrEmpty(categoryName))
            {
                // Connection string (replace with your connection details)
                string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

                SqlConnection connection = new SqlConnection(connectionString);

                string query = "INSERT INTO Category (Id,Name,Admin_Id,Created_Date) VALUES (@id,@name,@admin_id,@created_date)";
                SqlCommand cmd = new SqlCommand(query, connection);
                cmd.Parameters.AddWithValue("@id", "CID-1");
                cmd.Parameters.AddWithValue("@name", categoryName);
                cmd.Parameters.AddWithValue("@admin_id", "AID-1");
                cmd.Parameters.AddWithValue("@created_date", DateTime.Now);

                try
                {
                    connection.Open();
                    cmd.ExecuteNonQuery();
                    // Optionally, you can reload the categories table or show a success message
                    lblMessage.InnerText = "Category added successfully!";

                }
                catch (Exception ex)
                {
                    lblMessage.InnerText = "Error: " + ex.Message;
                }


                // Clear the input field
                txtCategoryName.Text = string.Empty;
                // Close the modal
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", "$('#addQuizModal').modal('hide');", true);
            }
            else
            {
                lblMessage.InnerText = "Please enter a category name.";
            }
        }
    }
}