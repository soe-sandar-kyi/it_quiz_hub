using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace QuizHub
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if adminId is available in session
            if (Session["adminId"] == null)
            {
                Response.Redirect("LandingPage.aspx"); // Redirect if not logged in
            }

            string adminId = Session["adminId"].ToString();
        }
    }
}