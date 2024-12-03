using Ede.Uof.Utility.Page;
using Ede.Uof.Utility.Page.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_Lab_Dialog_B : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //在這裡宣告Button1的Click事件-   產生事件後，在事件內將值用Dialog.SetReturn2回寫值  並關閉視窗Dialog.Close
        ((Master_DialogMasterPage)this.Master).Button1OnClick += CDS_Lab_Dialog_B_Button1OnClick;
        //在這裡找出Button2Text 並設為空字串
        ((Master_DialogMasterPage)this.Master).Button2Text = "";
    }

    private void CDS_Lab_Dialog_B_Button1OnClick()
    {
        Dialog.SetReturnValue2(txtReturnValue.Text);
        Dialog.Close(this.Page);
    }
}