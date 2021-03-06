<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeePage.aspx.cs" Inherits="EmployeePage.EmployeePage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Application</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://kendo.cdn.telerik.com/2021.1.119/styles/kendo.default-v2.min.css"/>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script src="https://kendo.cdn.telerik.com/2021.1.119/js/kendo.all.min.js"></script> 
    <link rel="stylesheet" href="style.css" />
    <script>
        var selectedCells = [];
        var grid;
        //Resetting the field values
        function resetValues() { 
            employeeID.value = "";
            employeeName.value = "";
            project.value = "";
            joinDate.value = "";
            employeeDivision.value = "";
            manager.value = "";
        }
        // Save the Employee Record and save it in the Database
        function SavePersonRecord() { 
            console.log('Script loaded');
            var id = $.trim($('#<%=employeeID.ClientID %>').val());
            var name = $.trim($('#<%=employeeName.ClientID %>').val());
            var project = $.trim($('#<%=project.ClientID %>').val());
            var division = $.trim($('#<%=employeeDivision.ClientID %>').val());
            var manager = $.trim($('#<%=manager.ClientID %>').val());
            var date = $.trim($('#<%=joinDate.ClientID %>').val());
            var jsonText = JSON.stringify({
                id: id,
                name: name,
                project: project,
                division: division,
                manager: manager,
                date: date,
            });
            console.log(manager);
            if (id == '' || name == '' || project == '' || division == '' || manager == '' || date == '') {
                alert('Fill all the fields');
            }
            else {
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeePage.aspx/saveEmployee",
                    data: jsonText,
                    success: function () {
                        alert('Employee Inserted');
                        resetValues();
                        modal.style.visibility = 'hidden';
                        GridLayout();
                    },
                    Error: function () {
                        alert('Error');
                    }
                });
            }
        }
        //Displaying the added employee details in grid.
        function GridLayout() { 
            //resetValues();
            $.ajax({
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                url: "EmployeePage.aspx/getDetails",
                data: "{}",
                success: function (data) {
                    //console.log(data);
                    var emp = JSON.parse(data.d);
                    console.log(emp);
                    var datasource = new kendo.data.DataSource({
                        data: emp,
                        schema: {
                            model: {
                                id: "id"
                            }
                        }
                    });
                    grid.setDataSource(datasource);
                }
            });
            //var url = "http://jsonplaceholder.typicode.com/posts";
        }
        //Add and edit pop up window
        function Popup(key) { 
            if (key == 1) {
                resetValues();
                modal.style.visibility = 'visible';
            }
            else if (key == 2) {
                if (selectedCells.length == 1) {
                    modal.style.visibility = 'visible';
                    let selected = selectedCells[0];
		    let date=new Date(selected.date);
                    employeeID.value = selected.id;
                    employeeName.value = selected.name;
                    project.value = selected.project;
                    joinDate.value = date.getFullYear()+'-'+date.getMonth()+1+'-'+('0'+date.getDate()).slice(-2);
                    employeeDivision.value = selected.division;
                    manager.value = selected.manager;
                    console.log(selected);
                    var update = JSON.stringify(selected);
                }
                else {
                    alert('Select one row');
                }
            }
            /*
            var kendoWindowAssign = $('#addEdit');
            var title = "Add/Edit Employee";
            kendoWindowAssign.kendoWindow({
                width: "650px",
                modal: true,
                height: "500px",
                iframe: true,
                resizable: true,
                title: title,
                //content: url,
                visible: false,
                animation: {
                    open: {
                        effects: "fade:in",
                        durration: 1000
                    },
                    close: {
                        effects: 'fade:out',
                        duration: 1000
                    }
                },
                content: {
                    url: "addEdit.aspx",
                    datatype: "json",
                    iframe: false,
                }
            });
            var Popup = $('#addEdit').data('kendoWindow');
            Popup.open();
            Popup.center();
            */
            
        }
        //Selecting the rows which the user selected
        function GridChanged() {
            selectedCells = [];
            let selected = this.select();
            for (let i = 0; i < selected.length; i++) {
                selectedCells.push(this.dataItem(selected[i].closest('tr')));
            }
            console.log(selectedCells);
        }
        //Deleting the selected rows
        function DeleteRow() {
            var list =[];
            for (let i = 0; i < selectedCells.length; i++) {
                list.push(selectedCells[i].id);
            }
            if (selectedCells.length > 0) {
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    url: "EmployeePage.aspx/deleteEmployees",
                    data: "{empid:'" + (list.join(',')) + "'}",
                    success: function (data) {
                        GridLayout();
                        if (data.d === "msg") {
                            if (selectedCells.length > 1)
                                alert(selectedCells.length + ' Rows Deleted Successfully');
                            else
                                alert(selectedCells.length + ' Row Deleted Successfully');
                        }
                    },
                    Error: function () {
                        alert('Error');
                    }
                });
            }
            else {
                alert('Select the rows to be deleted');
            }
        }
        //Grid initialization
        window.onload = () => {
            grid = $("#grid").kendoGrid({
                selectable: "multiple",
                persistSelection: true,
                change: GridChanged,
                columns: [
                    { selectable: true, width: '50px' },
                    { field: "name", title: "Employee Name" },
                    { field: "project", title: "Project", width: 100 },
                    { field: "date", title: "Joining Date" },
                    { field: "division", title: "Division" },
                    { field: "manager", title: "Manager" }
                ]
            }).data("kendoGrid");
            GridLayout();
        }
        function close_modal() {
            modal.style.visibility = 'hidden';
        }
    </script>
</head>
<body>
<div class="container">
    <div class="btn-control">
        <button id="add" class="button" type="button" onclick="Popup(1)">Add</button>
        <button id="edit" class="button" type="button" onclick="Popup(2)">Edit</button>
        <button id="delete" class="button" type="button" onclick="DeleteRow()">Delete</button>
     </div>
<div id="grid" class="grid1"></div>
     <asp:Panel CssClass="modal" ID="modal" runat="server">
        <form id="form" class="form" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                <h2>Fill the Employee Details</h2>
                <div class="form-control">
                    <label for="employeeID">Employee ID</label>
                    <asp:TextBox CssClass="form-control" runat="server" ID="employeeID"></asp:TextBox><br />
                    <small>Error message</small>
                </div>
                <div class="form-control">
                    <label for="employeeName">Employee Name</label>
                    <asp:TextBox CssClass="form-control" runat="server" ID="employeeName"></asp:TextBox><br />
                    <small>Error message</small>
                </div>
                <div class="form-control">
                    <label for="joinDate">Joining Date</label>
                    <asp:TextBox CssClass="form-control" ID="joinDate" runat="server" TextMode="Date" /><br />
                    <small>Error message</small>
                </div>
                <div class="form-control">
                    <label for="project">Project</label>
                    <asp:TextBox CssClass="form-control" runat="server" ID="project"></asp:TextBox><br />
                    <small>Error message</small>
                </div>
                <div class="form-control">
                    <label for="employeeDivision">Division</label>
                        <asp:DropDownList ID="employeeDivision" runat="server" AutoPostBack="true" AppendDataBoundItems="true" OnSelectedIndexChanged="SelectedIndexChanged">                
                        </asp:DropDownList><br />
                        <small>Error message</small>
                </div>
            <div class="form-control">
                    <label for="manager">Manager</label>
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="manager" runat="server" AutoPostBack="true" AppendDataBoundItems="true">   
                                </asp:DropDownList><br />
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="employeeDivision" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                    <small>Error message</small>
                </div>
                <button id="button" class="btn btn-primary" type="button" onclick="SavePersonRecord()">Save</button>
            <button id="close" type="button" onclick="close_modal()">Close</button>
            </form>
         </asp:Panel>
             <div id="addEdit"></div>
    </div>
</body>
</html>
