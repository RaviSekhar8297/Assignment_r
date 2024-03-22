using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;

namespace EmployeeProject
{
    public partial class EmployeeData : System.Web.UI.Page
    {
                   
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CalendarExtender1.EndDate = DateTime.Now.Date;
                BindData();
                BindName();
                BindDesignation();
            }
        }

        public void BindData()
        {
            try
            {
                SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["EmpDataString"].ConnectionString);

                SqlCommand sqlcmd = new SqlCommand("select * from EmployeeTable", connection);
                connection.Open();
                SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                DataSet ds1 = new DataSet();
                da.Fill(ds1);

                if (ds1.Tables.Count > 0 && ds1.Tables[0].Rows.Count > 0)
                {
                    gridData.DataSource = ds1;
                    gridData.DataBind();
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "NoRecordsAlert", "alert('No records found.');", true);
                }
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }
        public void BindName()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["EmpDataString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand())
                    {
                        command.Connection = connection;
                        command.CommandText = "SELECT DISTINCT Name FROM EmployeeTable";

                        connection.Open();

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            DropDownList1.Items.Clear(); 

                            while (reader.Read())
                            {
                                string role = reader["Name"].ToString();
                                DropDownList1.Items.Add(role); 
                            }
                        }
                    }
                }
                DropDownList1.Items.Insert(0, new System.Web.UI.WebControls.ListItem("", ""));
            }
            catch (Exception ex)
            {
               
                throw ex;
            }
        }
        public void BindDesignation()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["EmpDataString"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand command = new SqlCommand())
                    {
                        command.Connection = connection;
                        command.CommandText = "SELECT DISTINCT Designation FROM EmployeeTable";

                        connection.Open();

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            DropDownList2.Items.Clear();

                            while (reader.Read())
                            {
                                string role = reader["Designation"].ToString();
                                DropDownList2.Items.Add(role); 
                            }
                        }
                    }
                }
                DropDownList2.Items.Insert(0, new System.Web.UI.WebControls.ListItem("", ""));
            }
            catch (Exception ex)
            {
               
                throw ex;
            }
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {          
            try
            {
                using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["EmpDataString"].ConnectionString))
                {
                    connection.Open();
                    using (SqlCommand sqlcmd = new SqlCommand("INSERT INTO EmployeeTable(Name,Designation ,DOJ ,Salary,Gender ,State) VALUES(@Name,@Designation ,@DOJ ,@Salary,@Gender ,@State)", connection))
                    {
                        sqlcmd.Parameters.AddWithValue("@Name", txtName.Text);
                        sqlcmd.Parameters.AddWithValue("@Designation", txtDesignation.Text);

                        string dateFormat = "dd-MM-yyyy"; 

                        DateTime doj;
                        if (DateTime.TryParseExact(txtDOJ.Text, dateFormat, CultureInfo.InvariantCulture, DateTimeStyles.None, out doj))
                        {
                            sqlcmd.Parameters.AddWithValue("@DOJ", doj);
                        }
                        else
                        {
                            Response.Write("<script>alert('Invalid date format. Please enter the date in dd-MM-yyyy format.')</script>");
                        }
                        decimal salary = decimal.Parse(txtSalary.Text);
                        sqlcmd.Parameters.AddWithValue("@Salary", salary);
                        sqlcmd.Parameters.AddWithValue("@Gender", rblGender.SelectedValue);                       
                        sqlcmd.Parameters.AddWithValue("@State", ddlState.SelectedItem.Text);

                        int i = sqlcmd.ExecuteNonQuery();
                        if (i > 0)
                        {
                            Response.Write("<script>alert('Record Added Successsfully...')</script>");
                            ResetValues();
                            BindData();
                            BindName();
                            BindDesignation();
                        }
                        else
                        {
                            Response.Write("<script>alert('Record Added Successsfully...')</script>");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void gridData_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.CssClass = "clickable";

                string personId = gridData.DataKeys[e.Row.RowIndex]["Id"].ToString();               
                Label lblName = (Label)e.Row.FindControl("lblName");             
                lblName.Attributes["data-person-id"] = personId;
                lblName.CssClass = "clickable";
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            ResetValues();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["EmpDataString"].ConnectionString))
                {
                    string query = "SELECT * FROM EmployeeTable WHERE 1=1"; // Start with a base query

                    if (!string.IsNullOrEmpty(DropDownList1.SelectedItem.Text) && !string.IsNullOrEmpty(DropDownList2.SelectedItem.Text))
                    {
                        query += " AND Name = @Name AND Designation = @Designation";
                    }
                    else if (!string.IsNullOrEmpty(DropDownList1.SelectedItem.Text) && string.IsNullOrEmpty(DropDownList2.SelectedItem.Text))
                    {
                        query += " AND Name = @Name";
                    }
                    else if (string.IsNullOrEmpty(DropDownList1.SelectedItem.Text) && !string.IsNullOrEmpty(DropDownList2.SelectedItem.Text))
                    {
                        query += " AND Designation = @Designation";
                    }
                    else
                    {
                        Response.Write("<script>alert('There Is No records  found in" + DropDownList1.SelectedItem.Text + " " + DropDownList2.SelectedItem.Text + "')</script>");
                        BindData();
                    }

                    SqlCommand cmd = new SqlCommand(query, connection);

                    if (!string.IsNullOrEmpty(DropDownList1.SelectedItem.Text))
                    {
                        cmd.Parameters.AddWithValue("@Name", DropDownList1.SelectedItem.Text);
                    }

                    if (!string.IsNullOrEmpty(DropDownList2.SelectedItem.Text))
                    {
                        cmd.Parameters.AddWithValue("@Designation", DropDownList2.SelectedItem.Text);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        gridData.DataSource = ds;
                        gridData.DataBind();
                    }
                    else
                    {
                        Response.Write("<script>alert('There Is No records  found in Name " + DropDownList1.SelectedItem.Text + " And Designation " + DropDownList2.SelectedItem.Text + "')</script>");
                        DropDownList1.SelectedItem.Text = "";
                        DropDownList2.SelectedItem.Text = "";
                        BindData();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }

        public void ResetValues()
        {
            txtName.Text = "";
            txtDesignation.Text = "";
            txtDOJ.Text = "";
            txtSalary.Text = "";
            rblGender.ClearSelection();
            ddlState.SelectedItem.Text = "";
        }

        protected void btnupdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(TextBox1.Text))
                {
                    Response.Write("<script>alert('EmpId is required.')</script>");
                    return;
                }
                string inputDateFormat = "dd-MM-yyyy";
                string outputDateFormat = "yyyy-MM-dd";

                DateTime doj;

                if (DateTime.TryParseExact(txtDOJ.Text, inputDateFormat, CultureInfo.InvariantCulture, DateTimeStyles.None, out doj))
                {
                    string convertedDate = doj.ToString(outputDateFormat);

                    using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["EmpDataString"].ConnectionString))
                    {
                        connection.Open();
                        using (SqlCommand sqlcmd = new SqlCommand("UPDATE EmployeeTable SET Name=@Name, Designation=@Designation, DOJ=@DOJ, Salary=@Salary, Gender=@Gender, State=@State WHERE EmployeeID=@EmpId", connection))
                        {
                            sqlcmd.Parameters.AddWithValue("@Name", txtName.Text);
                            sqlcmd.Parameters.AddWithValue("@Designation", txtDesignation.Text);
                            decimal sal = decimal.Parse(txtSalary.Text);
                            sqlcmd.Parameters.AddWithValue("@Salary", sal);
                            sqlcmd.Parameters.AddWithValue("@Gender", rblGender.SelectedValue);
                            sqlcmd.Parameters.AddWithValue("@State", ddlState.SelectedItem.Text);
                            sqlcmd.Parameters.AddWithValue("@EmpId", HiddenField1.Value);

                            sqlcmd.Parameters.AddWithValue("@DOJ", convertedDate);

                            int i = sqlcmd.ExecuteNonQuery();
                            if (i > 0)
                            {
                                Response.Write("<script>alert('Updated Successfully...')</script>");
                                ResetValues();
                                BindData();
                                BindName();
                                BindDesignation();
                            }
                            else
                            {
                                Response.Write("<script>alert('Failed...')</script>");
                            }
                        }
                    }
                }
                else
                {
                    Response.Write("<script>alert('Invalid date format. Please enter the date in dd-MM-yyyy format.')</script>");
                    return; 
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
    }
}