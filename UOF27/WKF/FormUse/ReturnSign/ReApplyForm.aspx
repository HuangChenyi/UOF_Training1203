﻿<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="WKF_FormUse_ReturnSign_ReApplyForm" Title="送出表單" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="ReApplyForm.aspx.cs" %>
<%@ Register Src="~/WKF/Browse/TaskRecord/UC_TaskSiteRecord.ascx" TagName="UC_TaskSiteRecord" TagPrefix="uc4" %>
<%@ Register Src="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldCollectionUsingUC.ascx" TagName="VersionFieldCollectionUsingUC" TagPrefix="uc1" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register Src="../FormIQY/UC_QueryIqyTask.ascx" TagName="UC_QueryIqyTask" TagPrefix="uc5" %>
<%@ Register Src="../TaskSiteSignInfo/UC_SignComment.ascx" TagName="UC_SignComment" TagPrefix="uc6" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc2" TagName="UC_FileCenter" %>
<%@ Register Src="~/WKF/FormManagement/MultiColumnDesign/UC_VersionFieldCollectionUsing.ascx" TagPrefix="uc1" TagName="UC_VersionFieldCollectionUsing" %>
<%@ Register Src="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldCollectionUsingUC.ascx" TagPrefix="uc2" TagName="VersionFieldCollectionUsingUC" %>
<%@ Register Src="~/WKF/Common/UC_FileOnlinePreview.ascx" TagPrefix="uc9" TagName="UC_FileOnlinePreview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        .SubFlowTD
        {
            vertical-align: top;
            background-attachment: fixed;
            background-image: url("<%=themePath %>/images/wkf/line1.gif");
            background-repeat: repeat-y;
        }
        .EmptyTable
        {
            padding: 0px;
            border: 0px;
            margin: 0px;
            text-align: center;
        }
        .SignerTD
        {
            color: blue;
            text-align: left;
        }
        .SiteLeftTD
        {
            background-image: url("<%=themePath %>/images/wkf/site_left.gif");
            background-repeat: repeat-y;
        }
        .SiteMiddleTD
        {
            background-image: url("<%=themePath %>/images/wkf/app_con.gif");
            background-repeat: repeat-y;
        }
        .SiteRightTD
        {
            width: 8px;
            background-image: url("<%=themePath %>/images/wkf/site_right.gif");
            background-repeat: repeat-y;
        }
        .CondTextTD
        {
            text-align: center;
            font-weight: bold;
        }
        .CondLeftTD
        {
            background-image: url("<%=themePath %>/images/wkf/site_left_big.gif");
            background-repeat: repeat-y;
        }
        .CondMiddleTD
        {
            background-image: url("<%=themePath %>/images/wkf/cond_con.gif");
            background-repeat: repeat-y;
            text-align: center;
        }
        .CondRightTD
        {
            background-image: url("<%=themePath %>/images/wkf/site_rig_big.gif");
            background-repeat: repeat-y;
        }
        td_
        {
            text-align: center;
            vertical-align: top;
            font-size: 12px;
            width: 120;
        }
        table_
        {
            text-align: center;
            border: 0px;
        }
        .hiddenNotify
        {
            display: none;
        }
        .bigT
        {
            color: #ffffff;
            font-size: 25px;
            font-weight: bolder;
        }
        .applicantInfo {
            table-layout: fixed;
            white-space: nowrap;
            height: inherit;
        }

        .applicantInfo > tbody {
            display: block;
            height: inherit;
            white-space: nowrap;
            padding-left: 5px;
        }
    </style>

    <script id="ReApplyFormJS" type="text/javascript">
        function saveScrollPosition() 
        {
            $('#<%=this.HiddenField1.ClientID%>').val($('#<%=this.Panel1.ClientID%>').scrollTop()); 
        }       
                
        function setScrollPosition() 
        {        
            $('#<%=this.Panel1.ClientID%>').scrollTop($('#<%=this.HiddenField1.ClientID%>').val());
        }

        Sys.Application.add_load(function () {
            try {
                //隱藏所有欄位的填寫者Label
                $('.FillerVisible').hide();
                oncbShowFillerChecked();
                calculate();

            } catch (e) {
            }
        });

        $(function () {
            
            //表單計算欄位
            try {
                calculate();
                //SetDivZero();
            } catch(e) {
            }

            try {
                setScrollPosition();
                var actionMode = $uof.tool.htmlDecode("<%=actionMode %>");
                var validateMsg = $uof.tool.htmlDecode($('#<%=hfValidateMsg.ClientID%>').val());
                var confirmWinUrl = $uof.tool.htmlDecode('<%=System.Web.Security.AntiXss.AntiXssEncoder.HtmlEncode(confirmWinUrl,true)%>');
                var dialogTitleName = $uof.tool.htmlDecode('<%=System.Web.Security.AntiXss.AntiXssEncoder.HtmlEncode(dialogTitleName,true)%>');

                if (actionMode == "Send") {
                    
                    if (confirmWinUrl.length === 0)
                        return true;
                        
                    $uof.dialog.open2(confirmWinUrl, '', dialogTitleName, '<%=confirmWinWidth%>', '<%=confirmWinHeight%>', function checkReturn(returnValue) {
                        if (returnValue == "DoubleSigned") {
                            location.href = "../ViewForm.aspx?TASK_ID=" + $uof.tool.htmlDecode('<%=System.Web.Security.AntiXss.AntiXssEncoder.HtmlEncode(Request.QueryString["TASK_ID"],true)%>') + "&SignedStatus=IsSigned";
                            return true;
                        }
                        else if (typeof (returnValue) == 'undefined') {
                            return false;
                        }
                        else {
                            $uof.dialog.set_returnValue(returnValue);
                            $uof.dialog.close();
                            return true;
                        }
                    });
                }

                if (actionMode == "noPass") {
                    alert('<%=lblNoPassMsg.Text%>' + validateMsg);
                }
            }
            catch (e) {
                alert("<%=lblnewWindowMsg.Text%>");
            }
        });

        function openDialogResult(returnValue) {
            //判斷是否PostBack
            if (typeof (returnValue) == 'undefined') {
                return false;
            }
            return true;
        }

        function OnBarMainClick(sender, args) {
            var paras = {
                taskId: $uof.tool.htmlDecode('<%=System.Web.Security.AntiXss.AntiXssEncoder.HtmlEncode(Request.QueryString["TASK_ID"],true)%>'),
                 siteId: $uof.tool.htmlDecode('<%=System.Web.Security.AntiXss.AntiXssEncoder.HtmlEncode(Request.QueryString["SITE_ID"],true)%>'),
                nodeSeq: $uof.tool.htmlDecode('<%=System.Web.Security.AntiXss.AntiXssEncoder.HtmlEncode(Request.QueryString["nodeSeq"],true)%>'),
             };
            var formversionId = $uof.tool.htmlDecode('<%=System.Web.Security.AntiXss.AntiXssEncoder.HtmlEncode(formVersionId,true)%>');
            var flowId = $uof.tool.htmlDecode('<%=System.Web.Security.AntiXss.AntiXssEncoder.HtmlEncode(flowId,true)%>');
            var title = $uof.tool.htmlDecode('<%=System.Web.Security.AntiXss.AntiXssEncoder.HtmlEncode(dialogTitleName, true)%>');
            if (args.get_item().get_value() == "SaveFormDraft") {
                // 驗證欄位
                for (var i = 0; i < Page_Validators.length; ++i) {
                    ValidatorEnable(Page_Validators[i], (oButton.Key == "SaveFormDraft"));

                    if (!Page_Validators[i].isvalid) {
                        args.set_cancel(true);
                        break;
                    }
                }
            }
            else if (args.get_item().get_value() == "SendFormDraft") {
                //欄位送出是PostBack 在後端開窗    	   
                // 驗證欄位
                for (var i = 0; i < Page_Validators.length; ++i) {
                    ValidatorEnable(Page_Validators[i], (oButton.Key == "SendFormDraft"));

                    if (!Page_Validators[i].isvalid) {
                        args.set_cancel(true);
                        break;
                    }
                }
            }
            else if (args.get_item().get_value() == "ShowFlow") {
                args.set_cancel(true);
                $uof.dialog.open2('~/WKF/Browse/ViewMasterFlow.aspx', args.get_item(), title, 1280, 1080, openDialogResult, { 'formVersionId': formversionId, 'flowId': flowId});
            }
            else if (args.get_item().get_value() == "ViewFlow") {
                args.set_cancel(true);
                $uof.dialog.open2('~/WKF/Browse/ViewSignFlow.aspx', args.get_item(), title, 800, 650, function () { return false; },
                    { 'TASK_ID': paras.taskId, 'SITE_ID': paras.siteId, 'NODE_SEQ': paras.nodeSeq });
            }
            else if (args.get_item().get_value() == "ViewFlowDetail") {
                args.set_cancel(true);
                $uof.dialog.open2('~/WKF/FormUse/SiteSignInfo.aspx', args.get_item(), title, 800, 650, function () { return false; },
                    { 'TASK_ID': paras.taskId, 'SITE_ID': paras.siteId });
            }
            else if (args.get_item().get_value() == "SignComment") {
                var para = {
                    'ScriptID': paras.taskId,
                    'SiteID': paras.siteId,
                    'NodeSEQ': '0',
                    'IsScript': 'N'
                }
                args.set_cancel(true);
                $uof.dialog.open2('~/WKF/FormUse/AddSignComment.aspx', args.get_item(), '', 600, 480, openDialogResult, para);
            }
            else if (args.get_item().get_value() == "ForOpinion") {
                var para = {
                    "USER_GUID": $uof.tool.htmlDecode("<%=hiddenUserGUID.Value%>"),
                    "TASK_ID": $uof.tool.htmlDecode("<%=hiddenTaskId.Value%>"),
                    "IS_SCRIPT_IQY": "0",
                    "USER_DEPT": $uof.tool.htmlDecode("<%=hiddenUserDEPT.Value%>"),
                    "SITE_ID": $uof.tool.htmlDecode("<%=hiddenSiteid.Value%>"),
                    "NODE_SEQ": $uof.tool.htmlDecode("<%=hiddenNodeSEQ.Value%>")
                };
                args.set_cancel(true);
                $uof.dialog.open2('~/WKF/FormUse/FormIQY/IssueIQY.aspx', args.get_item(), '發出徵詢', 850, 700, openDialogResult, para);
            }
            else if (args.get_item().get_value() == "SimulationFlow") {

            }
            else if (args.get_item().get_value() == "PreAdditionalSign") {

            }
            else if (args.get_item().get_value() == "Attach") {

            }
            else if (args.get_item().get_value() == "Forum") {
                var TaskID = $uof.tool.htmlDecode("<%=System.Web.Security.AntiXss.AntiXssEncoder.HtmlEncode(hiddenTaskId.Value,true)%>");
                args.set_cancel(true);
                $uof.dialog.open2('~/WKF/FormForum/DefaultDialog.aspx', args.get_item(), '', 0, 0, function () { return false; }, { 'taskid': TaskID });
            }
            else if (args.get_item().get_value() == "FormDescription") {
                args.set_cancel(true);
                var w = $uof.tool.computeScreenSize('w', 1024);
                var h = $uof.tool.computeScreenSize('h', 768);
                var url = '../../FormManagement/EditFormDescription.aspx?formVersionId=' + formversionId + '&type=View&culture=<%=Ede.Uof.EIP.SystemInfo.Current.Culture%>';
                $uof.window.open(url, w, h, true);
            }
        }

        function openDialogResult(returnValue) {
            if (typeof (returnValue) == 'undefined') {
                return false;
            }
            return true;
        }

        function checkReturn(oEvent) {
            var comment = $('#<% = txtComment.ClientID %>');
            if (comment.val() == '') {
                alert($('#<% = lblReturnSignComment.ClientID %>').html());
                comment.focus();
                oEvent.cancel = true;
            }
        }

        function oncbShowFillerChecked() {
            var cbShowFiller = $('#<%=cbShowFiller?.ClientID %>')
            if (cbShowFiller === null)
                return;

            if (cbShowFiller.is(':checked')) {
                $('.FillerVisible').show();
            }
            else {
                $('.FillerVisible').hide();
            }
        }
    </script>

    <div id="contentDV" style="display:none">
        <table cellpadding="0" border="0" style="height: 100%; width: 100%;">
            <tr>
                <td style="background-image: url(<%=themePath %>/images/wf_bg.gif);vertical-align:top">
                    <center>
                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%;">
                                    <tr>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a01.gif); background-position: 0% 100%; height: 15px; width: 15px"></td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a09.gif); background-position: 0% 100%; background-repeat: repeat-x; height: 15px"></td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a02.gif); background-position: 0% 100%; height: 15px; width: 15px"></td>
                                    </tr>
                                    <tr>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a03.gif)"></td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a04.gif)">
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" id="FormIQYTable"
                                                runat="server">
                                                <tr>
                                                    <td>
                                                    <telerik:RadToolBar ID="webToolBar" runat="server" OnClientButtonClicking="OnBarMainClick"
                                                        OnButtonClick="webToolBar_ButtonClick" Width="100%" meta:resourcekey="webToolBarResource1">
                                                        <Items>
                                                             <telerik:RadToolBarButton runat="server"  
                                                                meta:resourceKey="TBarButtonResource6"  CausesValidation="false"
                                                                    CheckedImageUrl="~/Common/Images/Icon/icon_m101.gif"
                                                                    DisabledImageUrl="~/Common/Images/Icon/icon_m101.gif" 
                                                                    HoveredImageUrl="~/Common/Images/Icon/icon_m101.gif"
                                                                    ImageUrl="~/Common/Images/Icon/icon_m101.gif" Text="觀看表單流程" Value="ShowFlow" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" IsSeparator="true" Value="sShowFlow" meta:resourcekey="RadToolBarButtonResource1" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server"  
                                                                meta:resourceKey="TBarButtonResource11"  CausesValidation="false"
                                                                    CheckedImageUrl="~/Common/Images/Icon/icon_m101.gif"
                                                                    DisabledImageUrl="~/Common/Images/Icon/icon_m101.gif" 
                                                                    HoveredImageUrl="~/Common/Images/Icon/icon_m101.gif"
                                                                    ImageUrl="~/Common/Images/Icon/icon_m101.gif" Text="模擬流程" Value="SimulationFlow" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" IsSeparator="true" Value="sSimulationFlow" meta:resourcekey="RadToolBarButtonResource2" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server"  
                                                                meta:resourceKey="TBarButtonResource3"  CausesValidation="false"
                                                                    CheckedImageUrl="~/Common/Images/Icon/icon_m101.gif"
                                                                    DisabledImageUrl="~/Common/Images/Icon/icon_m101.gif" 
                                                                    HoveredImageUrl="~/Common/Images/Icon/icon_m101.gif"
                                                                    ImageUrl="~/Common/Images/Icon/icon_m101.gif" Text="進階加簽" Value="PreAdditionalSign" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" IsSeparator="true" Value="sPreAdditionalSign" meta:resourcekey="RadToolBarButtonResource3" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server"  
                                                                meta:resourceKey="TBarButtonResource1"  CausesValidation="false"
                                                                    CheckedImageUrl="~/Common/Images/Icon/icon_j06.gif"
                                                                    DisabledImageUrl="~/Common/Images/Icon/icon_j06.gif" 
                                                                    HoveredImageUrl="~/Common/Images/Icon/icon_j06.gif"
                                                                    ImageUrl="~/Common/Images/Icon/icon_j06.gif" Text="實際簽核流程" Value="ViewFlow" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" IsSeparator="true" Value="sViewFlow" meta:resourcekey="RadToolBarButtonResource5" >
                                                                </telerik:RadToolBarButton>
                                                                  <telerik:RadToolBarButton runat="server"  
                                                                meta:resourceKey="TBarButtonResource2"  CausesValidation="false"
                                                                    CheckedImageUrl="~/Common/Images/Icon/icon_j07.gif"
                                                                    DisabledImageUrl="~/Common/Images/Icon/icon_j07.gif" 
                                                                    HoveredImageUrl="~/Common/Images/Icon/icon_j07.gif"
                                                                    ImageUrl="~/Common/Images/Icon/icon_j07.gif" Text="實際簽核明細" Value="ViewFlowDetail" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" IsSeparator="true" Value="sViewFlowDetail" meta:resourcekey="RadToolBarButtonResource6" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server"  
                                                                meta:resourceKey="TBarButtonResource5"  CausesValidation="false"
                                                                    CheckedImageUrl="~/Common/Images/Icon/icon_m180.gif"
                                                                    DisabledImageUrl="~/Common/Images/Icon/icon_m180.gif" 
                                                                    HoveredImageUrl="~/Common/Images/Icon/icon_m180.gif"
                                                                    ImageUrl="~/Common/Images/Icon/icon_m180.gif" Text="罐頭意見" Value="SignComment" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" IsSeparator="true" Value="sSignComment" meta:resourcekey="RadToolBarButtonResource7" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server"  
                                                                meta:resourceKey="TBarButtonResource7"  CausesValidation="false"
                                                                    CheckedImageUrl="~/Common/Images/Icon/icon_m180.gif"
                                                                    DisabledImageUrl="~/Common/Images/Icon/icon_m180.gif" 
                                                                    HoveredImageUrl="~/Common/Images/Icon/icon_m180.gif"
                                                                    ImageUrl="~/Common/Images/Icon/icon_m180.gif" Text="發出徵詢" Value="ForOpinion" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" IsSeparator="true" Value="sForOpinion" meta:resourcekey="RadToolBarButtonResource8" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" 
                                                                 meta:resourcekey="FormForumResource"  CausesValidation="false"
                                                                    CheckedImageUrl="~/Common/Images/Icon/icon_m12.gif"
                                                                    DisabledImageUrl="~/Common/Images/Icon/icon_m12.gif" 
                                                                    HoveredImageUrl="~/Common/Images/Icon/icon_m12.gif"
                                                                    ImageUrl="~/Common/Images/Icon/icon_m12.gif"
                                                                    Text="表單討論" Value="Forum">
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" IsSeparator="true" Value="Separator3" meta:resourcekey="RadToolBarButtonResource9">
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server"
                                                                            CausesValidation="false"
                                                                            CheckedImageUrl="~/Common/Images/Icon/icon_m12.gif"
                                                                            DisabledImageUrl="~/Common/Images/Icon/icon_m12.gif"
                                                                            HoveredImageUrl="~/Common/Images/Icon/icon_m12.gif"
                                                                            ImageUrl="~/Common/Images/Icon/icon_m12.gif"
                                                                            Text="表單說明" Value="FormDescription" meta:resourcekey="RadToolBarButtonResource10">
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" IsSeparator="true" Value="SeparatorbyDescription" meta:resourcekey="RadToolBarButtonResource12">
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" Value="ShowFiller" CausesValidation="false">
                                                                    <ItemTemplate>
                                                                        <asp:CheckBox ID="cbShowFiller" onclick="oncbShowFillerChecked()" runat="server" meta:resourcekey="cbShowFillerResource1" />
                                                                        <asp:Label ID="lblShowFiller" runat="server" Text="顯示填寫者" meta:resourcekey="lblShowFillerResource1"></asp:Label>
                                                                    </ItemTemplate>
                                                                </telerik:RadToolBarButton>
                                                        </Items>
                                                    </telerik:RadToolBar>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="width: 25%; height: 100%; margin: 0; padding: 0; padding-right: 3px;" valign="top">
                                                        <table class="PopTable" style="height: 160px;" width="100%">
                                                            <tr style="vertical-align:top;">
                                                                <td align="center" class="PopTableHeader"  height="20px" style="text-align:center;">
                                                                    <center>
                                                                        <asp:Label ID="lblComment" runat="server" Text="申請資訊" meta:resourcekey="lblCommentResource1"></asp:Label>
                                                                    </center>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="background-color: white; height: 100%; margin: 0; padding: 0" valign="top">
                                                                    <asp:Panel ID="pnlAppInfo" runat="server" Height="140px" ScrollBars="Auto">
                                                                        <table cellpadding="0" cellspacing="0" width="100%" id="TABLE1" runat="server" style=" margin: 0; padding: 0" class="applicantInfo">
                                                                                <tr id="trApplicant" runat="server">
                                                                                    <td style="text-align: right; width: 26%;">
                                                                                        <asp:Label ID="Label15" runat="server" Text="申請人：" meta:resourcekey="Label15Resource1"></asp:Label>&nbsp;
                                                                                    </td>
                                                                                    <td style="text-align: left;" nowrap="nowrap">
                                                                                        <asp:Label ID="lblApplicant" runat="server" meta:resourcekey="lblApplicantResource1"></asp:Label>
                                                                                    </td>
                                                                                    <td style="height: 21px"></td>
                                                                                    <td style="height: 21px"></td>
                                                                                </tr>
                                                                                <tr id="trApplicantDept" runat="server">
                                                                                    <td style="width: 26%; height: 21px; text-align: right" nowrap="nowrap">
                                                                                        <asp:Label ID="Label17" runat="server" Text="部門：" meta:resourcekey="Label17Resource1"></asp:Label>&nbsp;
                                                                                    </td>
                                                                                    <td style="text-align: left">
                                                                                        <asp:Label ID="lblDepartment" runat="server" meta:resourcekey="lblDepartmentResource1"></asp:Label>
                                                                                    </td>
                                                                                    <td style="height: 21px"></td>
                                                                                    <td style="height: 21px"></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td nowrap style="text-align: right; width: 26%;">
                                                                                        <asp:Label ID="Label1" runat="server" Text="申請時間：" meta:resourcekey="Label1Resource1"></asp:Label>&nbsp;
                                                                                    </td>
                                                                                    <td style="text-align: left">
                                                                                        <asp:Label ID="lblApplyTime" runat="server" meta:resourcekey="lblApplyTimeResource1"></asp:Label>
                                                                                    </td>
                                                                                    <td style="height: 21px"></td>
                                                                                    <td style="height: 21px"></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td nowrap style="text-align: right; width: 26%;">
                                                                                        <asp:Label ID="Label9" runat="server" Text="緊急程度：" meta:resourcekey="Label9Resource1"></asp:Label>&nbsp;
                                                                                    </td>
                                                                                    <td style="text-align: left">
                                                                                        <asp:RadioButtonList ID="rblUrgentLevel" runat="server" RepeatDirection="Horizontal" meta:resourcekey="rblUrgentLevelResource1">
                                                                                            <asp:ListItem Value="0" meta:resourcekey="lblMostUrgentResource1" Text="緊急" />
                                                                                            <asp:ListItem Value="1" meta:resourcekey="lblUrgentResource1" Text="急" />
                                                                                            <asp:ListItem Value="2" meta:resourcekey="lblNormalResource1" Text="普通" />
                                                                                        </asp:RadioButtonList>
                                                                                    </td>
                                                                                    <td style="height: 21px"></td>
                                                                                    <td style="height: 21px"></td>
                                                                                </tr>
                                                                                <tr id="agentLableDisplayTR" runat="server">
                                                                                    <td>
                                                                                        <asp:Label ID="lblAgentApplicant" runat="server" Text="代理填寫者：" meta:resourcekey="lblAgentApplicantResource1"></asp:Label>&nbsp;
                                                                                    </td>
                                                                                    <td style="text-align: left">
                                                                                        <asp:Label ID="lblAgentUser" runat="server" meta:resourcekey="lblAgentUserResource1"></asp:Label>
                                                                                    </td>
                                                                                    <td style="height: 21px"></td>
                                                                                    <td style="height: 21px"></td>
                                                                                </tr>
                                                                            </table>
                                                                        </asp:Panel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td style="width: 25%; height: 100%; padding-left: 0; padding-right: 3px; margin: 0; padding-bottom: 0; padding-top: 0;" valign="top">
                                                        <table cellspacing="0" class="PopTable" style="height: 160px; margin: 0; padding: 0" width="100%">
                                                            <tr style="vertical-align: top;">
                                                                <td align="center" class="PopTableHeader" style="text-align: center; height: 20px">
                                                                    <center>
                                                                        <asp:Label ID="lblOtherInfo" runat="server" Text="意見" meta:resourcekey="lblOtherInfoResource1"></asp:Label>
                                                                    </center>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td  style="background-color: white;height:140px;margin:0; padding-bottom:0; padding-top:0;" valign="top" align="left"  >
                                                                    <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Width="100%" Height="99%" meta:resourcekey="txtCommentResource1"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td id="AttachmentsByForm" runat="server" style="width: 25%; height: 100%; margin: 0; padding: 0; padding-right: 3px;" valign="top">
                                                        <table cellspacing="0" class="PopTable" style="height: 160px; margin: 0; padding: 0;table-layout:fixed;word-wrap:break-word" width="100%">
                                                            <tr style="vertical-align: top;">
                                                                <td align="center" class="PopTableHeader" height="20px" style="text-align: center;">
                                                                    <center>
                                                                        <asp:Label ID="lblFileUpload" runat="server" Text="相關附件(表單)" meta:resourcekey="lblFileUploadResource1"></asp:Label>
                                                                    </center>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="background-color: white; height: 140px; margin: 0; padding: 0; width: 100%; vertical-align: top; text-align: center">
                                                                    <div align="center" style="height: 135px; overflow: auto; width: 100%; margin: 0; padding: 0">
                                                                        <asp:LinkButton ID="lbtnFileCenter" runat="server" ForeColor="OliveDrab" CausesValidation="False" Text="檔案操作" meta:resourcekey="lbtnRemoteFileCenterResource1" OnClick="lbtnFileCenter_Click"></asp:LinkButton>
                                                                        <div id="divFC" runat="server" style="text-align:left">
                                                                            <uc2:UC_FileCenter runat="server" id="UC_FileCenter1" ModuleName="WKF" Editable="false" ProxyEnabled="true"/>
                                                                        </div>
                                                                        <div id="divFOP" runat="server" style="text-align:left;">
                                                                            <uc9:UC_FileOnlinePreview runat="server" ID="UC_FileOnlinePreview" />
                                                                        </div>
                                                                        <asp:Label ID="lblFileGroupId" runat="server" Visible="False" meta:resourcekey="lblRemoteFileGroupIdResource1"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td id="AttachmentsBySite" runat="server" style="width: 25%; height: 100%; margin: 0; padding: 0" valign="top">
                                                        <table cellspacing="0" class="PopTable" style="height: 160px; margin: 0; padding: 0;table-layout:fixed;word-wrap:break-word" width="100%">
                                                            <tr style="vertical-align: top;">
                                                                <td align="center" class="PopTableHeader" height="20px" style="text-align: center;">
                                                                    <center>
                                                                        <asp:Label ID="Label2" runat="server" Text="個人附件(站點)" meta:resourcekey="lblPersonalAttachResource1"></asp:Label>
                                                                    </center>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="center" style="background-color: white; height: 140px; margin: 0; padding: 0; width: 100%" valign="top">
                                                                    <div align="center" style="height: 135px; overflow: auto; width: 100%; margin: 0; padding: 0">
                                                                        <asp:LinkButton ID="lbtnPersonalFileCenter" runat="server" ForeColor="OliveDrab" meta:resourcekey="LinkButton1Resource1" CausesValidation="False" Text="檔案操作" OnClick="lbtnPersonalFileCenter_Click"></asp:LinkButton>
                                                                        <div id="divFCPersonal" runat="server"  style="text-align:left">
                                                                            <uc2:UC_FileCenter runat="server" id="UC_PersonalFileCenter" Editable="false" ModuleName="WKF" ProxyEnabled="true"/>
                                                                        </div>
                                                                        <div id="divFOPPersonal" runat="server" style="text-align:left;">
                                                                            <uc9:UC_FileOnlinePreview runat="server" ID="UC_FileOnlinePreviewPersonal" />
                                                                        </div>
                                                                        <asp:Label ID="lblPersonalFileGroupId" runat="server" Visible="False" meta:resourcekey="lblPersonalRemoteFileGroupIdResource1"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a05.gif)"></td>
                                    </tr>
                                    <tr>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a06.gif); background-position: 0% 0%; height: 20px; width: 15px"></td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a07.gif); background-position: 0% 0%; height: 20px"></td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a08.gif); background-position: 0% 0%; height: 20px; width: 15px"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="blank8">
                            </td>
                        </tr>
                    </table>
                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="width:120px;min-width:120px">
                                            <img src="<%=themePath %>/images/wf_icon01.jpg" width="120" height="65" />
                                        </td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a01.jpg);background-repeat:repeat-x;height:65px;background-position: 0% 100%;">
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td class="bigT" style="height: 65px; vertical-align:middle;text-align:left">
                                                        <asp:Label ID="lblFormName" runat="server" meta:resourcekey="lblFormNameResource1"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="26">
                                            <img src="<%=themePath %>/images/wf_a02.jpg" width="26" height="65" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="height: 8px; width: 15px; background-image: url(<%=themePath %>/images/wf_a03.gif);">
                                        <img src="<%=themePath %>/images/wf_a03.gif" width="15px" height="8px">
                                    </td>
                                    <td style="background-image: url(<%=themePath %>/images/wf_a04.gif); height: 8px;">
                                    </td>
                                    <td style="background-image: url(<%=themePath %>/images/wf_a05.gif); height: 8px;
                                        width: 15px;">
                                        <img src="<%=themePath %>/images/wf_a05.gif" width="15px" height="8px">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 15px; background-image: url(<%=themePath %>/images/wf_a03.gif);">
                                        <img src="<%=themePath %>/images/wf_a03.gif" width="15px" height="8px">
                                    </td>
                                    <td style="background-image: url(<%=themePath %>/images/wf_a04.gif);">
                                        <table border="0" align="center" cellpadding="0" cellspacing="0" style="margin-left:auto; margin-right:auto;width:95%">
                                            <tr>
                                                <td>
                                                    <div>
                                                        <asp:Label ID="lblSpeedSendFailedMessage" runat="server" Text="快速送出失敗：" Visible="false" ForeColor="Red" meta:resourcekey="lblSpeedSendFailedMessageResource1" ></asp:Label>                                                        
                                                    </div>
                                                    <div>
                                                        <asp:Label ID="lblShowSignAgent" runat="server" Text="" Visible="false" ForeColor="Blue"></asp:Label>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Panel ID="Panel1" runat="server" Width="100%" meta:resourcekey="Panel1Resource1"></asp:Panel>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="background-image: url(<%=themePath %>/images/wf_a05.gif);">
                                        <img src="<%=themePath %>/images/wf_a05.gif" width="15" height="8">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="background-image: url(<%=themePath %>/images/wf_a06.gif); background-position: 0% 0%; height: 20px; width: 15px"></td>
                                    <td style="background-image: url(<%=themePath %>/images/wf_a07.gif); background-position: 0% 0%; height: 20px"></td>
                                    <td style="background-image: url(<%=themePath %>/images/wf_a08.gif); background-position: 0% 0%; height: 20px; width: 15px"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="blank8">
                            </td>
                        </tr>
                    </table>
                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="width:120px;min-width:120px">
                                            <img src="<%=themePath %>/images/wf_icon02.jpg" width="120" height="65">
                                        </td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a01.jpg);background-repeat:repeat-x;height:65px;background-position: 0% 100%;">
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td class="bigT" style="height: 65px; vertical-align:middle;text-align:left">
                                                        <asp:Label ID="lblFormFlow" runat="server" Text="表單流程" meta:resourcekey="lblFormFlowResource1"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="26">
                                            <img src="<%=themePath %>/images/wf_a02.jpg" width="26" height="65">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a03.gif); width: 15px;
                                            height: 8px;">
                                            <img src="<%=themePath %>/images/wf_a03.gif" width="15px" height="8px">
                                        </td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a04.gif); height: 8px;">
                                        </td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a05.gif); width: 15px;
                                            height: 8px;">
                                            <img src="<%=themePath %>/images/wf_a05.gif" width="15px" height="8px">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a03.gif);">
                                            <img src="<%=themePath %>/images/wf_a03.gif" width="15px" height="8px">
                                        </td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a04.gif);">
                                            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Panel ID="Panel3" runat="server" meta:resourcekey="Panel3Resource1">
                                                            <uc6:UC_SignComment ID="UC_SignComment1" runat="server" />
                                                        </asp:Panel>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a05.gif);">
                                            <img src="<%=themePath %>/images/wf_a05.gif" width="15" height="8">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a06.gif); background-position: 0% 0%; height: 20px; width: 15px"></td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a07.gif); background-position: 0% 0%; height: 20px"></td>
                                        <td style="background-image: url(<%=themePath %>/images/wf_a08.gif); background-position: 0% 0%; height: 20px; width: 15px"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="blank8">
                            </td>
                        </tr>
                    </table>
                    </center>
                    
                    <asp:Panel ID="Panel2" runat="server" Width="100%" meta:resourcekey="Panel1Resource1">
                        <uc5:UC_QueryIqyTask ID="UC_QueryIqyTask1" runat="server" />
                    </asp:Panel>
                    
                    <asp:HiddenField ID="hiddenTaskId" runat="server" />
                    <asp:HiddenField ID="hiddenUserGUID" runat="server" />
                    <asp:HiddenField ID="hiddenUserDEPT" runat="server" />
                    <asp:HiddenField ID="hiddenSiteid" runat="server" />
                    <asp:HiddenField ID="hiddenNodeSEQ" runat="server" />
                    <asp:HiddenField ID="hfValidateMsg" runat="server" />
                    <asp:HiddenField ID="HiddenField1" runat="server" Value="0" />

                    <asp:Label ID="lblDialogTitleMsg" runat="server" Text="送出表單" Visible="False" meta:resourcekey="lblDialogTitleMsgResource1"></asp:Label>
                    <asp:Label ID="lblNormal" runat="server" Text="普通" Visible="False" meta:resourcekey="lblNormalResource1"></asp:Label>
                    <asp:Label ID="lblUrgent" runat="server" Text="急" Visible="False" meta:resourcekey="lblUrgentResource1"></asp:Label>
                    <asp:Label ID="lblMostUrgent" runat="server" Text="緊急" Visible="False" meta:resourcekey="lblMostUrgentResource1"></asp:Label>
                    <asp:Label ID="lblSaveTxt" runat="server" Text="儲存" Visible="False" meta:resourcekey="lblSaveTxtResource1"></asp:Label>
                    <asp:Label ID="lblNoPassMsg" runat="server" Text="驗證失敗，失敗原因如下：\n\n" Visible="False" meta:resourcekey="lblNoPassMsgResource1"></asp:Label>
                    <asp:Label ID="lblSendTxt" runat="server" Text="送出" Visible="False" meta:resourcekey="lblSendTxtResource1"></asp:Label>
                    <asp:Label ID="lblSpeedSend" runat="server" Text="快速送出" visible="False" meta:resourcekey="lblSpeedSendResource1" ></asp:Label>                    
                    <asp:Label ID="lblReturn" runat="server" Text="退簽" Visible="False" meta:resourcekey="lblReturnResource1"></asp:Label>
                    <asp:Label ID="lblReturnSignComment" runat="server" ForeColor="Red" Text="請在意見欄輸入退簽意見" meta:resourcekey="lblReturnSignCommentResource1" CssClass="hiddenNotify"></asp:Label>
                    <asp:Label ID="lblNotCurrentSite" runat="server" Text="此站點非可處理站點" Visible="False" meta:resourcekey="lblNotCurrentSiteResource1" ></asp:Label>
                    <asp:Label ID="lblTaskEnd" runat="server" Text="表單已結案，無法進行簽核" Visible="False" meta:resourcekey="lblTaskEndResource1"></asp:Label>
                    <asp:Label ID="lblConfirmWinTitle" runat="server" Text="簽核確認" Visible="False" meta:resourcekey="lblConfirmWinTitleResource1"></asp:Label>
                    <asp:Label ID="lblnewWindowMsg" Visible="False" runat="server" Text="無法開啟簽核視窗，請嘗試將快顯封鎖程式關閉" meta:resourcekey="lblnewWindowMsgResource1"></asp:Label>
                    <asp:Label ID="lblJumpSign" runat="server" Text="跳關送出" Visible="False" meta:resourcekey="lblJumpSignResource1"></asp:Label>
                    <asp:Label ID="lblAdditionalSign" runat="server" Text="加簽" Visible="False" meta:resourcekey="lblAdditionalSignResource1"></asp:Label>
                    <asp:Label ID="lblNoAuth" runat="server" Text="無權限處理或觀看此表單" Visible="False" meta:resourcekey="lblNoAuthResource1" ></asp:Label>
                    <asp:Label ID="lblReleaseApprovalDisalbed" runat="server" Text="已關閉表單審核功能，不允許簽核，請洽系統管理員處理。" Visible="False" meta:resourcekey="lblReleaseApprovalDisalbedResource1" ></asp:Label>
                    <asp:Label ID="lblIsSignAgent" runat="server" Text="目前代理 {0} 簽核中" Visible="false" ForeColor="Blue" meta:resourcekey="lblIsSignAgentResource1" ></asp:Label>                
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
