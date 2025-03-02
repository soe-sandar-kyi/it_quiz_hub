using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Drawing.Printing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuizHub
{
    public partial class LandingPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

       }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string adminId = "";
            string email = "Admin@gmail.com"; 
            string password = "123456kK";

            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string query = "SELECT Id FROM Admin WHERE Email = @Email AND Password = @Password";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password); 

                    object result = cmd.ExecuteScalar();

                    if (result != null)
                    {
                        adminId = result.ToString();
                    }
                }
            }

            if (!string.IsNullOrEmpty(adminId))
            {
                Session["adminId"] = adminId; // Store admin ID in session
                Response.Redirect("CategoryManagement.aspx"); // Redirect to Admin Panel
            }
            else
            {
                lblMessage.InnerText = "Invalid credentials!";
            }

        }

    }
}