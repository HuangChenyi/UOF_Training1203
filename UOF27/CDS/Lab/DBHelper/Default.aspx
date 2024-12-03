<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="CDS_Lab_DBHelper_Default" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Ede" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <Ede:Grid ID="GridView1" runat="server"
        AutoGenerateCheckBoxColumn="false" AutoGenerateColumns="false"
        >
                <Columns>
            <asp:BoundField HeaderText="產品ID" DataField="ProductID" ItemStyle-Width="100px"  />
             <asp:BoundField HeaderText="產品名稱" DataField="ProductName" ItemStyle-Width="300px"  />
             <asp:BoundField HeaderText="單價" DataField="UnitPrice" ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Right"  />
        </Columns>
    </Ede:Grid>


</asp:Content>

