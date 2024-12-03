using Ede.Uof.Utility.Page;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_WebPage_Detail : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((Master_DialogMasterPage)this.Master).Button1OnClick += CDS_WebPage_Detail_Button1OnClick;
       // ((Master_DialogMasterPage)this.Master).Button1Text = "AAA";
    }

    private void CDS_WebPage_Detail_Button1OnClick()
    {
       // throw new NotImplementedException();
    }
}