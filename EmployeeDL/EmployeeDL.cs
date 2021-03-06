using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EmployeeDTO;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using DivisionDTO;
using ManagerDTO;

namespace Employee.DL
{
    public class EmployeeDL
    {
        string constr = ConfigurationManager.ConnectionStrings["Dhanush"].ConnectionString;
        //Adding Employee Details to the Employee table.
        public void AddEmployee(DTOEmployee emp)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                con.Open();
                SqlCommand sql = new SqlCommand("select * from Employee where EmployeeID=" + emp.id, con);
                SqlDataReader data = sql.ExecuteReader();
                if(data.Read())
                {
                    data.Close();
                    SqlCommand cmd = new SqlCommand("update Employee set EmployeeName='" + emp.name + "',Project='" + emp.project + "',Division='" + emp.division + "',Manager='" + emp.manager + "' where EmployeeID=" + emp.id, con);
                    cmd.ExecuteNonQuery();
                    
                }
                else
                {
                    data.Close();
                    using (SqlCommand cmd = new SqlCommand("AddNewEmployee", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@ID", emp.id);
                        cmd.Parameters.AddWithValue("@Name", emp.name);
                        cmd.Parameters.AddWithValue("@Project", emp.project);
                        cmd.Parameters.AddWithValue("@Division", emp.division);
                        cmd.Parameters.AddWithValue("@Manager", emp.manager);
                        cmd.Parameters.AddWithValue("@Date", emp.date);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }
        //Retrieving the divisions from database and storing it in Division DTO Object.
        public List<DivisionObject> GetDivisions()
        {
            List<DivisionObject> _divisions = new List<DivisionObject>();
            SqlConnection con = new SqlConnection(constr);
            con.Open();
            SqlCommand cmd = new SqlCommand("select * from Division", con);
            SqlDataReader data = cmd.ExecuteReader();
            while (data.Read())
            {
                DivisionObject div = new DivisionObject();
                div.divisionId = data.GetInt32(0);
                div.divisionName = data.GetString(1);
                _divisions.Add(div);
            }
            return _divisions;
        }
        //Retrieving the managers from database and storing it in Manager DTO Object.
        public List<ManagerObject> GetManagers()
        {
            List<ManagerObject> managers = new List<ManagerObject>();
            SqlConnection con = new SqlConnection(constr);
            con.Open();
            SqlCommand cmd = new SqlCommand("select * from Manager", con);
            SqlDataReader data = cmd.ExecuteReader();
            while (data.Read())
            {
                ManagerObject man = new ManagerObject();
                man.managerId = data.GetInt32(0);
                man.managerName = data.GetString(1);
                managers.Add(man);
            }
            return managers;
        }
        //Retrieving the fields from database and storing it in Employee DTO Object.
        public List<DTOEmployee> getEmp()
        {
            SqlConnection con = new SqlConnection(constr);
            con.Open();
            SqlCommand cmd = new SqlCommand("select * from Employee", con);
            SqlDataReader data = cmd.ExecuteReader();
            List<DTOEmployee> list = new List<DTOEmployee>();
            while (data.Read())
            {
                DTOEmployee obj = new DTOEmployee();
                obj.id = Convert.ToInt32(data["EmployeeID"]);
                obj.name = (string)data["EmployeeName"];
                obj.project = (string)data["Project"];
                obj.division = (string)data["Division"];
                obj.manager = (string)data["Manager"];
                obj.date =data.GetDateTime(5).ToString("dd-MM-yyyy");
                list.Add(obj);
            }
            return list;
        }
        public string valueSelect(string division)
        {
            try {
            string manager = "";
            SqlConnection con = new SqlConnection(constr);
            con.Open();
            SqlCommand cmd = new SqlCommand("select * from Manager", con);
            SqlDataReader myReader = cmd.ExecuteReader();
            while (myReader.Read())
            {
                if (myReader.GetString(2).Equals(division))
                {
                    manager = myReader.GetString(1);
                    break;
                }
            }
            return manager;
            }
            catch(Exception e) {
                return "none";
            }
        }
        //Deleting the employees contained in the List.
        public string delete(List<string> idlist)
        {
            try {
            SqlConnection con = new SqlConnection(constr);
            con.Open();
                foreach (var id in idlist)
                {
                    SqlCommand cmd = new SqlCommand("delete Employee where EmployeeID like '"+id+"'", con);
                    cmd.ExecuteReader();
                }
                return "msg";
            }
            catch(Exception e) {
                return "none";
            }
        }
        /*
        public string update(DTOEmployee emp)
        {
            SqlConnection con = new SqlConnection(constr);
            con.Open();
            SqlCommand cmd = new SqlCommand("update Employee set EmployeeName='" + emp.name + "'Project='" + emp.project + "'Division='" + emp.division + "'Manager='" + emp.manager + "'where EmployeeID="+emp.id, con);
            cmd.ExecuteReader();
            return "updated";
        }
        */
    }
}
