using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
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
            if (!IsPostBack)
            {
                LoadCategories();
            }
        }
        private void LoadCategories()
        {
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT Id, Name FROM Category";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptCategories.DataSource = dt;
                rptCategories.DataBind();
            }
        }
        protected void btnSaveCategory_Click(object sender, EventArgs e)
        {
            string categoryName = txtCategoryName.Text.Trim();
            if (!string.IsNullOrEmpty(categoryName))
            {
                string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

                SqlConnection connection = new SqlConnection(connectionString);
                connection.Open();

                // Step 1: Get the latest Category ID
                string getMaxIdQuery = "SELECT TOP 1 Id FROM Category ORDER BY Created_Date DESC";
                SqlCommand getMaxIdCmd = new SqlCommand(getMaxIdQuery, connection);
                object maxIdObj = getMaxIdCmd.ExecuteScalar();

                // Step 2: Determine the new Category ID
                int newIdNumber = 1; // Default if no existing category
                if (maxIdObj != null)
                {
                    string maxId = maxIdObj.ToString(); // e.g., "CID-10"
                    int lastNumber;
                    if (int.TryParse(maxId.Replace("CID-", ""), out lastNumber))
                    {
                        newIdNumber = lastNumber + 1;
                    }
                }
                string newCategoryId = "CID-" + newIdNumber; // Generate new ID

                string query = "INSERT INTO Category (Id,Name,Admin_Id,Created_Date) VALUES (@id,@name,@admin_id,@created_date)";
                SqlCommand cmd = new SqlCommand(query, connection);
                cmd.Parameters.AddWithValue("@id", newCategoryId);
                cmd.Parameters.AddWithValue("@name", categoryName);
                cmd.Parameters.AddWithValue("@admin_id", "AID-1");
                cmd.Parameters.AddWithValue("@created_date", DateTime.Now);

                try
                {
                    cmd.ExecuteNonQuery();

                    // Reload the categories immediately
                    LoadCategories();

                    // Show SweetAlert2 success message
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowSweetAlert",
                        "Swal.fire({ title: 'Success!', text: 'Category added successfully!', icon: 'success', confirmButtonText: 'OK' });", true);
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowErrorAlert",
    "Swal.fire({ title: 'Error!', text: '" + ex.Message + "', icon: 'error', confirmButtonText: 'OK' });", true);

                }


                // Clear the input field
                txtCategoryName.Text = string.Empty;
                // Close the modal
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", "$('#addQuizModal').modal('hide');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowErrorAlert",
    "Swal.fire({ title: 'Error!', text: '" +"Please enter category name" + "', icon: 'error', confirmButtonText: 'OK' });", true);

            }
        }
    }
}