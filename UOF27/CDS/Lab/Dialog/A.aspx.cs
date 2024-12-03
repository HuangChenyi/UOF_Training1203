using Ede.Uof.Utility.Page;
using Ede.Uof.Utility.Page.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_Lab_Dialog_A : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //在這裡宣告開窗Dialog.Open2
        Dialog.Open2(btnOpen, "~/CDS/Lab/Dialog/B.aspx", "", 800, 600, Dialog.PostBackType.AfterReturn);
    }

    protected void btnOpen_Click(object sender, EventArgs e)
    {
        //在這裡出設定回傳值Dialog.GetReturnValue()
        if(!string.IsNullOrEmpty(Dialog.GetReturnValue()))
        {
            txtReturnValue.Text = Dialog.GetReturnValue();
        }
    }
}