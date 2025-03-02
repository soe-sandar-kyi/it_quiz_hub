using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace QuizHub
{
    public partial class UserManagement : System.Web.UI.Page
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
                LoadUsers();
            }
            else
            {
                // Retrieve page number from ViewState on postbacks
                currentPage = (int)ViewState["CurrentPage"];
            }

            string eventTarget = Request["__EVENTTARGET"];
            string eventArgument = Request["__EVENTARGUMENT"];

            if (!string.IsNullOrEmpty(eventTarget) && eventTarget == rptUser.UniqueID)
            {
                DeleteUser(eventArgument);
            }
        }

        public int CurrentPage
        {
            get { return currentPage; }
        }

        private void LoadUsers()
        {
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Count total records
                string countQuery = "SELECT COUNT(*) FROM Admin";
                SqlCommand countCmd = new SqlCommand(countQuery, conn);
                totalRecords = (int)countCmd.ExecuteScalar();

                totalPages = (int)Math.Ceiling((double)totalRecords / pageSize);

                int startRow = (currentPage - 1) * pageSize;
                string query = $"SELECT Id, Name,Email,Password FROM Admin ORDER BY CAST(SUBSTRING(Id, 5, LEN(Id) - 4) AS INT) OFFSET {startRow} ROWS FETCH NEXT {pageSize} ROWS ONLY";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptUser.DataSource = dt;
                rptUser.DataBind();

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
            LoadUsers();
        }
        protected void btnSaveUser_Click(object sender, EventArgs e)
        {
            string adminId = hiddenUserId.Value; // Retrieve hidden ID
            string adminName = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            // Email Validation (Only Gmail Allowed)
            string emailPattern = @"^[a-zA-Z][a-zA-Z0-9._%+-]*@gmail\.com$";
            if (!Regex.IsMatch(email, emailPattern))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "EmailError",
                    "Swal.fire({ title: 'Error!', text: 'Invalid email format.', icon: 'error', confirmButtonText: 'OK' });", true);
                return;
            }

            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                // Check if email already exists (for insert and update)
                string emailCheckQuery = "SELECT COUNT(*) FROM Admin WHERE Email = @email";
                if (!string.IsNullOrEmpty(adminId))
                {
                    emailCheckQuery += " AND Id <> @id"; // Exclude current admin when updating
                }

                SqlCommand emailCheckCmd = new SqlCommand(emailCheckQuery, connection);
                emailCheckCmd.Parameters.AddWithValue("@email", email);
                if (!string.IsNullOrEmpty(adminId))
                {
                    emailCheckCmd.Parameters.AddWithValue("@id", adminId);
                }

                int emailCount = (int)emailCheckCmd.ExecuteScalar();
                if (emailCount > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "EmailExists",
                        "Swal.fire({ title: 'Error!', text: 'Email is already in use. Please use a different email.', icon: 'error', confirmButtonText: 'OK' });", true);
                    return;
                }

                string query;
                SqlCommand cmd;

                if (!string.IsNullOrEmpty(adminId)) // If ID exists, update user
                {
                    query = "UPDATE Admin SET Name = @name, Email = @email WHERE Id = @id";
                    cmd = new SqlCommand(query, connection);
                    cmd.Parameters.AddWithValue("@id", adminId);
                    cmd.Parameters.AddWithValue("@name", adminName);
                    cmd.Parameters.AddWithValue("@email", email);
                }
                else // Insert new user
                {
                    // Password Validation
                    string passwordPattern = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$";
                    if (!Regex.IsMatch(password, passwordPattern))
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "PasswordError",
                            "Swal.fire({ title: 'Error!', text: 'Password must be at least 8 characters and contain uppercase, lowercase, and a number.', icon: 'error', confirmButtonText: 'OK' });", true);
                        return;
                    }

                    // Generate New Admin ID
                    string getMaxIdQuery = "SELECT TOP 1 Id FROM Admin ORDER BY Created_Date DESC";
                    SqlCommand getMaxIdCmd = new SqlCommand(getMaxIdQuery, connection);
                    object maxIdObj = getMaxIdCmd.ExecuteScalar();

                    int newIdNumber = 1;
                    if (maxIdObj != null && int.TryParse(maxIdObj.ToString().Replace("AID-", ""), out int lastNumber))
                    {
                        newIdNumber = lastNumber + 1;
                    }
                    string newAdminId = "AID-" + newIdNumber;

                    query = "INSERT INTO Admin (Id, Name, Email, Password, Created_Date) VALUES (@id, @name, @email, @password, @created_date)";
                    cmd = new SqlCommand(query, connection);
                    cmd.Parameters.AddWithValue("@id", newAdminId);
                    cmd.Parameters.AddWithValue("@created_date", DateTime.Now);
                    cmd.Parameters.AddWithValue("@name", adminName);
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@password", password);
                }
                try
                {
                    cmd.ExecuteNonQuery();
                    LoadUsers(); // Refresh table

                    string successMessage = !string.IsNullOrEmpty(adminId) ? "Admin updated successfully!" : "Admin saved successfully!";
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
                        "Swal.fire({ title: 'Success!', text: '" + successMessage + "', icon: 'success', confirmButtonText: 'OK' });", true);
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
                        "Swal.fire({ title: 'Error!', text: '" + ex.Message + "', icon: 'error', confirmButtonText: 'OK' });", true);
                }

                // Reset form fields and close modal
                hiddenUserId.Value = "";
                txtName.Text = "";
                txtEmail.Text = "";
                txtPassword.Text = "";
                btnSaveUser.Text = "Save";

                ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", "$('#addAdminModal').modal('hide');", true);
            }
        }


        protected void EditUser_Click(object sender, CommandEventArgs e)
        {
            string[] args = e.CommandArgument.ToString().Split(',');
            if (args.Length == 3)
            {
                string adminId = args[0];
                string adminName = args[1];
                string email = args[2];

                // Store values in hidden field and text box
                hiddenUserId.Value = adminId;
                txtName.Text = adminName;
                txtEmail.Text = email;

                // Change button text to "Update"
                btnSaveUser.Text = "Update";
                btnSaveUser.CommandName = "UpdateUser";

                password.Visible = false;


                // Show the modal
                ScriptManager.RegisterStartupScript(this, GetType(), "OpenModal", "$('#addAdminModal').modal('show');", true);
            }
        }
        private void DeleteUser(string categoryId)
        {
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "DELETE FROM Admin WHERE Id = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", categoryId);

                try
                {
                    cmd.ExecuteNonQuery();
                    LoadUsers(); // Refresh the table

                    // Show success alert
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
                        "Swal.fire({ title: 'Deleted!', text: 'Admin deleted successfully.', icon: 'success' });",
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