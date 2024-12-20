﻿using Ede.Uof.Utility.Page;
using Lab.Lib.UCO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_Lab_Grid_OrderDetail : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {

        ((Master_DialogMasterPage)this.Master).Button1Text = "";
        ((Master_DialogMasterPage)this.Master).Button2Text = "";
        if (!IsPostBack)
        {
            //用Request把參數餵給 lblOrderId.Text
            lblOrderId.Text = Request.QueryString["OrderID"];

            LabUCO uco = new LabUCO();
            var dt = uco.GetOrderDetail(lblOrderId.Text);

            //從資料庫撈出來的TABLE塞給
            //Grid的DataSource
            //再用Grid的  DataBind 將資料建出來
            Grid1.DataSource = dt;
            Grid1.DataBind();   
        }

    }
}