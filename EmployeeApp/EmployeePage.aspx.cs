using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EmployeeDTO;
using Employee.BL;
using DivisionDTO;
using ManagerDTO;
using System.Web.Services;
using Newtonsoft.Json;

namespace EmployeePage
{
    public partial class EmployeePage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "close_modal()", true);
                EmployeeBL bus = new EmployeeBL();
                List<DivisionObject> list = new List<DivisionObject>();
                List<ManagerObject> managers = new List<ManagerObject>();
                list = bus.GetDivisionDetails();
                managers = bus.GetManagerDetails();
                foreach(var div in list)
                {
                    employeeDivision.Items.Add(new ListItem(div.divisionName, div.divisionName));
                }
                foreach(var man in managers)
                {
                    manager.Items.Add(new ListItem(man.managerName, man.managerName));
                }
                employeeDivision.Items.FindByText("Transportation").Selected = true;
                manager.Items.FindByText("Jitendra").Selected = true;
            }
        }
        //Storing Employee details in DTO and sending to DL
        [WebMethod]
        public static void saveEmployee(int id,string name,string project,string division,string manager,string date)
        {
            EmployeeBL bus = new EmployeeBL();
            DTOEmployee obj = new DTOEmployee();
            obj.id = id;
            obj.name = name;
            obj.project = project;
            obj.division = division;
            obj.manager = manager;
            obj.date = date;
            bus.saveEmployeeDetails(obj);
        }
        //Change the dropdown list values o be cascaded
        protected void SelectedIndexChanged(object sender, EventArgs e)
        {
            manager.ClearSelection();
            EmployeeBL bus = new EmployeeBL();
            modal.Visible = true;
            string selectedValue = employeeDivision.SelectedValue;
            string managerValue=bus.selectValue(selectedValue);
            manager.Items.FindByText(managerValue).Selected = true;
            /*
            List<ManagerObject> _managers = new List<ManagerObject>();
            _managers = bus.GetManagerDetails();
            int index = employeeDivision.SelectedIndex;
            manager.SelectedIndex = _managers.ElementAt(index).managerId;
            */
            manager.DataBind();
        }
        //Returning the Employee details from the DL as Serialized object 
        [WebMethod]
        public static string getDetails()
        {
            List<DTOEmployee> list = new List<DTOEmployee>();
            EmployeeBL bus = new EmployeeBL();
            list = bus.getEmployees();
            return JsonConvert.SerializeObject(list);
        }
        //Deleting Employees of the Employee ID List
        [WebMethod]
        public static string deleteEmployees(string empid)
        {
            EmployeeBL bus = new EmployeeBL();
            List<string> idlist = empid.Split(',').ToList();
            string msg=bus.deleteEmp(idlist);
            return msg;
        }
        /*
        [WebMethod]
        public static string updateEmployees(int id, string name, string project, string division, string manager, string date)
        {
            EmployeeBL businessLayer = new EmployeeBL();
            DTOEmployee obj = new DTOEmployee();
            obj.id = id;
            obj.name = name;
            obj.project = project;
            obj.division = division;
            obj.manager = manager;
            obj.date = date;
            string msg = businessLayer.updateEmp(obj);
            return msg;
        }
        */
    }
}