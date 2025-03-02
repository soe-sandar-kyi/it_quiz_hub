using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuizHub
{
    public partial class Settings : System.Web.UI.Page
    {
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
                LoadUser();
            }

        }

        private void LoadUser()
        {
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string query = "SELECT Name, Email, Password FROM Admin WHERE Id = @id";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@id", adminId); // Ensure adminId has a valid value

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read()) // Read first row
                        {
                            userName.Value = reader["Name"].ToString();
                            userEmail.Value = reader["Email"].ToString();
                            newPassword.Value = reader["Password"].ToString();
                        }
                    }
                }
            }
        }

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            string adminName = userName.Value;
            string email = userEmail.Value;
            // Email Validation
            string emailPattern = @"^[a-zA-Z][a-zA-Z0-9._%+-]*@gmail\.com$";
            if (!Regex.IsMatch(email, emailPattern))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "EmailError",
                    "Swal.fire({ title: 'Error!', text: 'Invalid email format.', icon: 'error', confirmButtonText: 'OK' });", true);
                return;
            }

            // Password Validation (At least 8 chars, 1 uppercase, 1 lowercase, 1 number)
            //string passwordPattern = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$";
            //if (!Regex.IsMatch(password, passwordPattern))
            //{
            //    ScriptManager.RegisterStartupScript(this, GetType(), "PasswordError",
            //        "Swal.fire({ title: 'Error!', text: 'Password must be at least 8 characters and contain uppercase, lowercase, and a number.', icon: 'error', confirmButtonText: 'OK' });", true);
            //    return;
            //}
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string query;
                SqlCommand cmd;
                query = "UPDATE Admin SET Name = @name, Email=@email WHERE Id = @id";
                cmd = new SqlCommand(query, connection);
                cmd.Parameters.AddWithValue("@name", adminName);
                cmd.Parameters.AddWithValue("@email", email);
                cmd.Parameters.AddWithValue("@id", adminId);

                try
                {
                    cmd.ExecuteNonQuery();
                    LoadUser(); // Refresh table

                    // Show success message
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess",
                    "Swal.fire({ title: 'Success!', text: 'Your information updated successfully!', icon: 'success', confirmButtonText: 'OK' });", true);

                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
                        "Swal.fire({ title: 'Error!', text: '" + ex.Message + "', icon: 'error', confirmButtonText: 'OK' });", true);
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", "$('#addQuizModal').modal('hide');", true);
            }
        }
        protected void btnUpdatePassword_Click(object sender, EventArgs e)
        {
            string currentPass = currentPassword.Value.Trim();
            string newPass = newPassword.Value.Trim();
            string confirmPass = confirmPassword.Value.Trim();
            string adminId = "AID-1"; // Fetch actual Admin ID based on session or login

            // Database connection
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                // Step 1: Retrieve the current password from the database
                string fetchQuery = "SELECT Password FROM Admin WHERE Id = @id";
                SqlCommand fetchCmd = new SqlCommand(fetchQuery, connection);
                fetchCmd.Parameters.AddWithValue("@id", adminId);
                string dbPassword = fetchCmd.ExecuteScalar()?.ToString();

                if (dbPassword == null || dbPassword != currentPass)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "PasswordError",
                        "Swal.fire({ title: 'Error!', text: 'Current password is incorrect.', icon: 'error', confirmButtonText: 'OK' });", true);
                    return;
                }

                // Step 2: Check if newPassword and confirmPassword match
                if (newPass != confirmPass)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "PasswordMismatch",
                        "Swal.fire({ title: 'Error!', text: 'New password and confirm password do not match.', icon: 'error', confirmButtonText: 'OK' });", true);
                    return;
                }

                // Step 3: Update password in the Admin table
                string updateQuery = "UPDATE Admin SET Password = @newPass WHERE Id = @id";
                SqlCommand updateCmd = new SqlCommand(updateQuery, connection);
                updateCmd.Parameters.AddWithValue("@newPass", newPass);
                updateCmd.Parameters.AddWithValue("@id", adminId);

                try
                {
                    updateCmd.ExecuteNonQuery();
                    ScriptManager.RegisterStartupScript(this, GetType(), "Success",
                        "Swal.fire({ title: 'Success!', text: 'Password updated successfully!', icon: 'success', confirmButtonText: 'OK' });", true);
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "DBError",
                        "Swal.fire({ title: 'Error!', text: '" + ex.Message + "', icon: 'error', confirmButtonText: 'OK' });", true);
                }
            }
        }

    }
}