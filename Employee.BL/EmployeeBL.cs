using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EmployeeDTO;
using DivisionDTO;
using ManagerDTO;
using Employee.DL;

namespace Employee.BL
{
    public class EmployeeBL
    {
        public List<DivisionObject> GetDivisionDetails()
        {
            EmployeeDL empdl = new EmployeeDL();
            List<DivisionObject> div = new List<DivisionObject>();
            div=empdl.GetDivisions();
            return div;
        }
        public List<ManagerObject> GetManagerDetails()
        {
            EmployeeDL empdl = new EmployeeDL();
            List<ManagerObject> man = new List<ManagerObject>();
            man = empdl.GetManagers();
            return man;
        }
        public void saveEmployeeDetails(DTOEmployee obj)
        {
                EmployeeDL data = new EmployeeDL();
                data.AddEmployee(obj);
        }
        public List<DTOEmployee> getEmployees()
        {
            EmployeeDL data = new EmployeeDL();
            return data.getEmp();
        }
        public string selectValue(string division)
        {
            EmployeeDL data = new EmployeeDL();
            return data.valueSelect(division);
        }
        public string deleteEmp(List<string> idlist)
        {
            EmployeeDL data = new EmployeeDL();
            string msg=data.delete(idlist);
            return msg;
        }
        /*
        public string updateEmp(DTOEmployee emp)
        {
            EmployeeDL data = new EmployeeDL();
            string msg = data.AddEmployee(emp);
            return msg;
        }
        */
    }
}
