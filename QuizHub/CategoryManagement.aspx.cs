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
        string connectionString = ConfigurationManager.ConnectionStrings["QuizHubDB"].ConnectionString;

        private int pageSize = 10;  // Number of rows per page
        private int currentPage;// Current page
        private int totalRecords = 0; // Total rows in DB
        private int totalPages = 0; // Total number of pages
        private string adminId;
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if adminId is available in session
            if (Session["adminId"] == null)
            {
                Response.Redirect("LandingPage.aspx"); // Redirect if not logged in
            }
            adminId = Session["adminId"].ToString();
            if (!IsPostBack)
            {
                currentPage = 1; // Initialize only on first load
                ViewState["CurrentPage"] = currentPage; // Store in ViewState
                LoadCategories();
            }
            else
            {
                // Retrieve page number from ViewState on postbacks
                currentPage = (int)ViewState["CurrentPage"];
            }

            string eventTarget = Request["__EVENTTARGET"];
            string eventArgument = Request["__EVENTARGUMENT"];

            if (!string.IsNullOrEmpty(eventTarget) && eventTarget == rptCategories.UniqueID)
            {
                DeleteCategory(eventArgument);
            }
        }

        public int CurrentPage
        {
            get { return currentPage; }
        }

        private void LoadCategories()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Count total records
                string countQuery = "SELECT COUNT(*) FROM Category";
                SqlCommand countCmd = new SqlCommand(countQuery, conn);
                totalRecords = (int)countCmd.ExecuteScalar();

                totalPages = (int)Math.Ceiling((double)totalRecords / pageSize);

                int startRow = (currentPage - 1) * pageSize;
                string query = $"SELECT Id, Name FROM Category ORDER BY CAST(SUBSTRING(Id, 5, LEN(Id) - 4) AS INT) OFFSET {startRow} ROWS FETCH NEXT {pageSize} ROWS ONLY";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptCategories.DataSource = dt;
                rptCategories.DataBind();

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
            LoadCategories();
        }

        protected void btnSaveCategory_Click(object sender, EventArgs e)
        {
            string categoryId = hiddenCategoryId.Value; // Retrieve hidden ID
            string categoryName = txtCategoryName.Text.Trim();

            if (string.IsNullOrEmpty(categoryName))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
                    "Swal.fire({ title: 'Error!', text: 'Please enter category name', icon: 'error', confirmButtonText: 'OK' });", true);
                return;
            }


            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                // Check if category name already exists (for insert and update)
                string nameCheckQuery = "SELECT COUNT(*) FROM Category WHERE Name = @name";
                if (!string.IsNullOrEmpty(categoryId))
                {
                    nameCheckQuery += " AND Id <> @id"; // Exclude current category when updating
                }

                SqlCommand nameCheckCmd = new SqlCommand(nameCheckQuery, connection);
                nameCheckCmd.Parameters.AddWithValue("@name", categoryName);
                if (!string.IsNullOrEmpty(categoryId))
                {
                    nameCheckCmd.Parameters.AddWithValue("@id", categoryId);
                }

                int nameCount = (int)nameCheckCmd.ExecuteScalar();
                if (nameCount > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "NameExists",
                        "Swal.fire({ title: 'Error!', text: 'Category name already exists. Please use a different name.', icon: 'error', confirmButtonText: 'OK' });", true);
                    return;
                }

                string query;
                SqlCommand cmd;

                if (!string.IsNullOrEmpty(categoryId)) // If ID exists, update
                {
                    query = "UPDATE Category SET Name = @name WHERE Id = @id";
                    cmd = new SqlCommand(query, connection);
                    cmd.Parameters.AddWithValue("@id", categoryId);
                }
                else // Insert new category
                {
                    // Generate New Category ID
                    string getMaxIdQuery = "SELECT TOP 1 Id FROM Category ORDER BY Created_Date DESC";
                    SqlCommand getMaxIdCmd = new SqlCommand(getMaxIdQuery, connection);
                    object maxIdObj = getMaxIdCmd.ExecuteScalar();

                    int newIdNumber = 1;
                    if (maxIdObj != null && int.TryParse(maxIdObj.ToString().Replace("CID-", ""), out int lastNumber))
                    {
                        newIdNumber = lastNumber + 1;
                    }
                    string newCategoryId = "CID-" + newIdNumber;

                    query = "INSERT INTO Category (Id, Name, Admin_Id, Created_Date) VALUES (@id, @name, @admin_id, @created_date)";
                    cmd = new SqlCommand(query, connection);
                    cmd.Parameters.AddWithValue("@id", newCategoryId);
                    cmd.Parameters.AddWithValue("@admin_id", adminId);
                    cmd.Parameters.AddWithValue("@created_date", DateTime.Now);
                }

                // Add common parameters
                cmd.Parameters.AddWithValue("@name", categoryName);

                try
                {
                    cmd.ExecuteNonQuery();
                    LoadCategories(); // Refresh table

                    string successMessage = !string.IsNullOrEmpty(categoryId) ? "Category updated successfully!" : "Category saved successfully!";
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
                        "Swal.fire({ title: 'Success!', text: '" + successMessage + "', icon: 'success', confirmButtonText: 'OK' });", true);
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
                        "Swal.fire({ title: 'Error!', text: '" + ex.Message + "', icon: 'error', confirmButtonText: 'OK' });", true);
                }

                // Reset form fields and close modal
                hiddenCategoryId.Value = "";
                txtCategoryName.Text = "";
                btnSaveCategory.Text = "Save"; // Reset button text

                ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", "$('#addQuizModal').modal('hide');", true);
            }
        }


        protected void EditCategory_Click(object sender, CommandEventArgs e)
        {
            string[] args = e.CommandArgument.ToString().Split(',');
            if (args.Length == 2)
            {
                string categoryId = args[0];
                string categoryName = args[1];

                // Store values in hidden field and text box
                hiddenCategoryId.Value = categoryId;
                txtCategoryName.Text = categoryName;

                // Change button text to "Update"
                btnSaveCategory.Text = "Update";
                btnSaveCategory.CommandName = "UpdateCategory";

                // Show the modal
                ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal", "$('#addQuizModal').modal('show');", true);
            }
        }
        private void DeleteCategory(string categoryId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "DELETE FROM Category WHERE Id = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", categoryId);

                // Step 1: Delete related questions first
                string deleteQuestionsQuery = "DELETE FROM Question WHERE Category_Id = @id";
                SqlCommand deleteQuestionsCmd = new SqlCommand(deleteQuestionsQuery, conn);
                deleteQuestionsCmd.Parameters.AddWithValue("@id", categoryId);
                deleteQuestionsCmd.ExecuteNonQuery();

                try
                {
                    cmd.ExecuteNonQuery();
                    LoadCategories(); // Refresh the table

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