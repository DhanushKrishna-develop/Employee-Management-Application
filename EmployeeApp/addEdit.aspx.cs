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

namespace EmployeeApp
{
    public partial class addEdit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                EmployeeBL bus = new EmployeeBL();
                List<DivisionObject> list = new List<DivisionObject>();
                List<ManagerObject> managers = new List<ManagerObject>();
                list = bus.GetDivisionDetails();
                managers = bus.GetManagerDetails();
                foreach (var div in list)
                {
                    employeeDivision.Items.Add(new ListItem(div.divisionName, div.divisionName));
                }
                foreach (var man in managers)
                {
                    manager.Items.Add(new ListItem(man.managerName, man.managerName));
                }
                employeeDivision.Items.FindByText("Transportation").Selected = true;
                manager.Items.FindByText("Jitendra").Selected = true;
            }
        }
        protected void SelectedIndexChanged(object sender, EventArgs e)
        {
            manager.ClearSelection();
            EmployeeBL bus = new EmployeeBL();
            /*
            string selectedValue = employeeDivision.SelectedValue;
            string managerValue=bus.selectValue(selectedValue);
            manager.Items.FindByText(managerValue).Selected = true;
            */
            List<ManagerObject> _managers = new List<ManagerObject>();
            _managers = bus.GetManagerDetails();
            int index = employeeDivision.SelectedIndex;
            manager.SelectedIndex = _managers.ElementAt(index).managerId - 1;
        }

        }
    }