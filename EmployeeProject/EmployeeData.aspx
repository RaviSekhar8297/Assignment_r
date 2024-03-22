<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeData.aspx.cs" Inherits="EmployeeProject.EmployeeData" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .grid{
            width:100%;
        }
        .main{
            width:100%;
            display:flex;
            justify-content:flex-start;
            align-items:flex-start;
            padding:20px;
            gap:2rem;
            height:100vh;
        }
        .form-main{
            width:30%;
            padding:30px;
            border-radius:10px;
            box-shadow: rgba(99, 99, 99, 0.2) 0px 2px 8px 0px;
            border:1px solid #5869b8;
    
        }
        .form-control{
            margin-bottom:10px;
        }
        span{
            color:lightslategray;
        }
        .text-center{
            display:flex;
            flex-direction:column;
            gap:3rem;
            width:65%;
            box-shadow: rgba(99, 99, 99, 0.2) 0px 2px 8px 0px;
            height:100%;
            padding:30px;
            border-radius:10px;
        }
        .drop-down-top{
            width:100%;
            display:flex;
            gap:1rem;
            justify-content:space-between;
            align-items:center;
        }
        .dropdown1{
            width:30%;
            display:flex;
            flex-direction:column;
            justify-content:flex-start;
            align-items:flex-start;
        }
        .dropdown1>:nth-child(2){
            width:100%;
        }
       
        .btnsearch{
            width:13%;

        }

        ::-webkit-scrollbar{
            display:none;
        }
        .main-grid{
            width:100%;
            height:90%;
            overflow:scroll;
        }
        .btn-card{
            width:100%;
            display:flex;
            justify-content:space-between;
            align-items:center;
        }
        .clickable{
            cursor:pointer;
        }
        .clickable:hover{
            color:#d10617;
            font-size:16px;
        }
        .btnsear{
            height:45px;
            border:none;
            outline:none;
            width:120px;
            background-color:#50ad64;
            color:black;
            border-radius:10px;
        }
    </style>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
</head>
<body>

    <form id="form1" runat="server">
         <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>


        <div class="main">
          <div class="form-main">
            <h5 style="text-align:center;color:red;">Employee Registration</h5>
              <br />
             <span> <asp:Label ID="Label1" runat="server" Text="EmpId"></asp:Label></span><asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" ></asp:TextBox>
              <asp:HiddenField ID="HiddenField1" runat="server" />

                  <span>Name</span>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" AutoCompleteType="Disabled"></asp:TextBox>

                  <span>Designation</span>
                        <asp:TextBox ID="txtDesignation" runat="server" CssClass="form-control" AutoCompleteType="Disabled"></asp:TextBox>

                  <span>Date Of joining</span>                
                        <asp:TextBox ID="txtDOJ" runat="server" CssClass="form-control" AutoCompleteType="Disabled" ></asp:TextBox>
                        <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDOJ" Format="dd-MM-yyyy" />

                 <span>salary</span>
                        <asp:TextBox ID="txtSalary" runat="server" CssClass="form-control" AutoCompleteType="Disabled" onkeypress="return onlyAllowNumbers(event)"></asp:TextBox>

                  <span>Gender</span>
                       <asp:RadioButtonList ID="rblGender" runat="server" >
                          <asp:ListItem  Text="Male" Value="Male"  />
                          <asp:ListItem Text="Female" Value="Female" />
                        </asp:RadioButtonList>

                 <span>State</span>
                        <asp:DropDownList ID="ddlState" runat="server" CssClass="form-control" onfocus="hideState()">
                            <asp:ListItem>--Select State --</asp:ListItem>
                            <asp:ListItem>Andhra Pradesh</asp:ListItem>
                            <asp:ListItem>Assam</asp:ListItem>
                            <asp:ListItem>Bihar</asp:ListItem>
                            <asp:ListItem>Chhattisgarh</asp:ListItem>
                             <asp:ListItem>Goa</asp:ListItem>
                             <asp:ListItem>Gujarat</asp:ListItem>                 
                            <asp:ListItem>Telangana</asp:ListItem>
                        </asp:DropDownList>
                   
                        <div class="btn-card">
                            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-success buttonl" OnClick="btnSave_Click" />
                            <asp:Button ID="btnupdate" runat="server" Text="UPDATE" CssClass="btn btn-success buttonl" OnClick="btnupdate_Click" />
                            <asp:Button ID="btnAdd" runat="server" Text="New Employee" CssClass="btn btn-success buttonl" OnClick="btnAdd_Click" />
                        </div>
                </div>   
               <div class="text-center">
               <div class="drop-down-top">
                   
                   <div class="dropdown1" > <span>Employee Name</span> <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control" onfocus="DropDownList1()" ></asp:DropDownList> </div>
                   <div class="dropdown1"> <span>Designation</span><asp:DropDownList ID="DropDownList2" runat="server" CssClass="form-control" onfocus="DropDownList2()"></asp:DropDownList></div>
                    <div class="btnsearch"><asp:Button ID="btnSearch" runat="server" Text="Search.." CssClass="btnsear" OnClick="btnSearch_Click" /></div>
                  
                  
               </div>
               <div class="main-grid">
                    <asp:GridView ID="gridData" runat="server" AutoGenerateColumns="False"  DataKeyNames="Id" CssClass="grid"  OnRowDataBound="gridData_RowDataBound" BackColor="White" BorderColor="#336666" BorderStyle="Double" BorderWidth="3px" CellPadding="4" GridLines="Horizontal">
                  <Columns>
                    <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" ><HeaderStyle BackColor="#cc58a7" /> </asp:BoundField>
                    <asp:BoundField DataField="EmployeeID" HeaderText="EmpId" ><HeaderStyle BackColor="#cc58a7" /> </asp:BoundField>
                    <asp:TemplateField HeaderText="Name" HeaderStyle-BackColor="#cc58a7">
                        <ItemTemplate>
                            <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>' CssClass="clickable" ClientIDMode="Static"></asp:Label>
                        </ItemTemplate>

<HeaderStyle BackColor="#CC58A7"></HeaderStyle>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Designation" HeaderText="Designation" ><HeaderStyle BackColor="#cc58a7" /> </asp:BoundField>
                    <asp:BoundField DataField="DOJ" HeaderText="DateOfJoin" DataFormatString="{0:yyyy-MM-dd}" ><HeaderStyle BackColor="#cc58a7" /> </asp:BoundField>
                    <asp:BoundField DataField="Salary" HeaderText="Salary" ><HeaderStyle BackColor="#cc58a7" /> </asp:BoundField>
                    <asp:BoundField DataField="Gender" HeaderText="Gender" ><HeaderStyle BackColor="#cc58a7" /> </asp:BoundField>
                    <asp:BoundField DataField="State" HeaderText="State" ><HeaderStyle BackColor="#cc58a7" /> </asp:BoundField>
              

                    </Columns>
                        <FooterStyle BackColor="White" ForeColor="#333333" />
                        <HeaderStyle BackColor="#336666" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#336666" ForeColor="White" HorizontalAlign="Center" />
                        <RowStyle BackColor="White" ForeColor="#333333" />
                        <SelectedRowStyle BackColor="#339966" Font-Bold="True" ForeColor="White" />
                        <SortedAscendingCellStyle BackColor="#F7F7F7" />
                        <SortedAscendingHeaderStyle BackColor="#487575" />
                        <SortedDescendingCellStyle BackColor="#E5E5E5" />
                        <SortedDescendingHeaderStyle BackColor="#275353" />
                    </asp:GridView>
               </div>
            </div>
        </div>
    </form>
    
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        function bindRowToInputs(row) {
            var cells = $(row).find('td');

            var textbox = $(cells[1]).text().trim();
            $('#<%=TextBox1.ClientID %>').val(textbox);
            console.log("txtName Value: ", textbox);


            var HiddenField1 = $(cells[1]).text().trim();
            $('#<%=HiddenField1.ClientID %>').val(HiddenField1);
            console.log("HiddenField1 Value: ", HiddenField1);


            var txtNameValue = $(cells[2]).text().trim();
            $('#<%=txtName.ClientID %>').val(txtNameValue);

            $('#<%=txtDesignation.ClientID %>').val($(cells[3]).text().trim());

            var dateStr = $(cells[4]).text().trim();
            var date = new Date(dateStr);
            var day = ('0' + date.getDate()).slice(-2);
            var month = ('0' + (date.getMonth() + 1)).slice(-2);
            var year = date.getFullYear();
            var formattedDate = day + '-' + month + '-' + year;
            $('#<%=txtDOJ.ClientID %>').val(formattedDate);



            $('#<%=txtSalary.ClientID %>').val($(cells[5]).text().trim());

            var gender = $(cells[6]).text().trim();
            if (gender === "Male") {
                $('#<%=rblGender.ClientID %> input[value="Male"]').prop('checked', true);
        } else if (gender === "Female") {
            $('#<%=rblGender.ClientID %> input[value="Female"]').prop('checked', true);
        }

        var state = $(cells[7]).text().trim();
        $('#<%=ddlState.ClientID %>').val(state);
    }

    // Handle click event on GridView row
    $('#<%=gridData.ClientID %> tr').click(function () {
        bindRowToInputs(this); 

        $('#<%=btnupdate.ClientID %>').show();
        $('#<%=btnSave.ClientID %>').hide();
        $('#<%=Label1.ClientID %>').show();
        $('#<%=TextBox1.ClientID %>').show();
    });

    $('#<%=btnupdate.ClientID %>').hide();
        $('#<%=btnSave.ClientID %>').show();
        $('#<%=Label1.ClientID %>').hide();
        $('#<%=TextBox1.ClientID %>').hide();
    });

</script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $("#txtSalary").keypress(function (event) {
            var value = $(this).val();
            if ((event.which != 46 || value.indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                event.preventDefault();
            }

            if (value.indexOf('.') != -1) {
                if (event.which == 46) {
                    event.preventDefault();
                }
                if (event.which >= 48 && event.which <= 57) {
                    var decimalPart = value.split('.')[1];
                    if (decimalPart && decimalPart.length >= 1) {
                        event.preventDefault();
                    }
                }
            }
        });

        $("#txtSalary").blur(function () {
            if ($(this).val().indexOf('.') == -1) {
                alert("Please enter a decimal value.");
                $(this).val(''); 
            }
        });


        $(document).ready(function () {
            $("#btnSave").click(function () {
                var isValid = true;

                if ($("#txtName").val().trim() === "") {
                    alert("Please enter a name.");
                    isValid = false;
                    return false;
                }
                if ($("#txtDesignation").val().trim() === "") {
                    alert("Please enter Designation.");
                    isValid = false;
                    return false;
                }
                if ($("#txtDOJ").val().trim() === "") {
                    alert("Please Select Date Of Join.");
                    isValid = false;
                    return false;
                }

                if ($("#txtSalary").val().trim() === "" || isNaN(parseFloat($("#txtSalary").val()))) {
                    alert("Please Enter a valid salary (numeric value).");
                    isValid = false;
                    return false; 
                }

                if ($("input[name='rblGender']:checked").length === 0) {
                    alert("Please select a Gender.");
                    isValid = false;
                    return false;
                }

                if ($("#ddlState").val() === "-- Select State --") {
                    alert("Please select a State.");
                    isValid = false;
                    return false; 
                }

                return isValid;
            });
        });
    });
</script>

    <script type="text/javascript">
        function DropDownList1() {
            var defaultOption = document.querySelector("#<%= DropDownList1.ClientID %> option[value='']"); 
             defaultOption.style.display = "none";
        }
        function DropDownList2() {
            var defaultOption = document.querySelector("#<%= DropDownList2.ClientID %> option[value='']");
             defaultOption.style.display = "none";
        }



        $(document).ready(function () {
            $('#<%=ddlState.ClientID %> option:first').hide();
        });

       

    </script>


</body>
</html>
