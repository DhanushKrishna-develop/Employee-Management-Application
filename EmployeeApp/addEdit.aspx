<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="addEdit.aspx.cs" Inherits="EmployeeApp.addEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add/Edit</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://kendo.cdn.telerik.com/2021.1.119/styles/kendo.default-v2.min.css"/>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script src="https://kendo.cdn.telerik.com/2021.1.119/js/kendo.all.min.js"></script> 
    <link rel="stylesheet" href="style.css" />
    <script>
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
                    $.ajax({
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        url: "EmployeePage.aspx/saveEmployee",
                        data: jsonText,
                        success: function () {
                            alert('Success');
                        },
                        Error: function () {
                            alert('Error');
                        }
                    });
        }
        function checkValid() {
            console.log('Validity');
            if (employeeID.value === '' || employeeName.value === '' || project.value === '' || employeeDivision.value === '' || manager.value === '') {
                alert('Enter the details!');
            }
        }
    </script>
</head>
<body>
     <div class="container">
        <form id="form" class="form" runat="server">
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
            <asp:TextBox CssClass="form-control" ID="joinDate" runat="server" TextMode="Date"/><br />
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
                    <label for="manager">Division</label>
            <asp:DropDownList ID="manager" runat="server" AutoPostBack="true" AppendDataBoundItems="true">
                
            </asp:DropDownList><br />
                    <small>Error message</small>
                </div>
                <button id="button" class="btn btn-primary" type="button" onclick="SavePersonRecord()">Save</button>
            </form>
        </div>
</body>
</html>
