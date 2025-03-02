using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuizHub
{
    public partial class Profile : System.Web.UI.Page
    {
        private string userId;
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if userId is available in session
            if (Session["userId"] == null)
            {
                Response.Redirect("LandingPage.aspx"); // Redirect if not logged in
            }
            userId = Session["userId"].ToString();

        }
    }
}