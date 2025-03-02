using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuizHub
{
    public partial class Result : System.Web.UI.Page
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
                LoadResults();
            }
            else
            {
                // Retrieve page number from ViewState on postbacks
                currentPage = (int)ViewState["CurrentPage"];
            }
        }

        public int CurrentPage
        {
            get { return currentPage; }
        }

        private void LoadResults()
        {
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=C:\Users\SoeSandarKyi\Desktop\Online Quiz\it_quiz_hub\QuizHub\App_Data\QuizHub.mdf;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string filter = txtFilterQuiz.Text.Trim();
                bool isFiltering = !string.IsNullOrEmpty(filter); // Check if filter is applied

                // Build WHERE clause dynamically
                string filterCondition = isFiltering ? "WHERE c.Name LIKE @Filter" : "";

                // Count total records based on filter
                string countQuery = $@"
            SELECT COUNT(*) FROM Result r 
            JOIN Category c ON r.Category_Id = c.Id 
            {filterCondition}";

                SqlCommand countCmd = new SqlCommand(countQuery, conn);
                if (isFiltering)
                {
                    countCmd.Parameters.AddWithValue("@Filter", "%" + filter + "%");
                }

                totalRecords = (int)countCmd.ExecuteScalar();
                totalPages = (int)Math.Ceiling((double)totalRecords / pageSize);
                int startRow = (currentPage - 1) * pageSize;

                // Query with pagination & filter
                string query = $@"
            SELECT ROW_NUMBER() OVER (ORDER BY r.Attempted_Date DESC) AS RowNum, 
                   r.Id, 
                   c.Name AS CategoryName, 
                   l.Name AS LevelName, 
                   r.Total_Question, 
                   r.Correct_Answer, 
                   r.Score, 
                   CONVERT(VARCHAR, r.Attempted_Date, 23) AS AttemptedDate
            FROM Result r
            JOIN Category c ON r.Category_Id = c.Id
            JOIN Level l ON r.Level_Id = l.Id
            {filterCondition}
            ORDER BY r.Attempted_Date DESC
            OFFSET @StartRow ROWS FETCH NEXT @PageSize ROWS ONLY";

                SqlCommand cmd = new SqlCommand(query, conn);
                if (isFiltering)
                {
                    cmd.Parameters.AddWithValue("@Filter", "%" + filter + "%");
                }
                cmd.Parameters.AddWithValue("@StartRow", startRow);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptCategories.DataSource = dt;
                rptCategories.DataBind();

                UpdatePaginationUI();
            }
        }


        protected void btnSearch_Click(object sender, EventArgs e)
        {
            currentPage = 1; // Reset pagination when searching
            LoadResults();
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
            LoadResults();
        }
    }
}