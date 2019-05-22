using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Transactions;
using AppStarSQL;
using System.Web.Script.Serialization;
namespace CRMPortal
{
    public partial class frmInquiry : System.Web.UI.Page
    {
        AppTools objTool = new AppTools();
        AppSQL objSQL = new AppSQL();
        SSMSTool objSSMS = new SSMSTool();
        AppSession objSession = new AppSession();
        AppRouting objRout = new AppRouting();

        public void Reset()
        {
            txtOName.Text = string.Empty;
            txtODesignation.Text = string.Empty;
            txtOContactNo.Text = string.Empty;
            txtOEmailID.Text = string.Empty;
            txtTName.Text = string.Empty;
            txtTDesignation.Text = string.Empty;
            txtTContactNo.Text = string.Empty;
            txtTEmailID.Text = string.Empty;
            //Reset Feedback
            BindFeedbackMaster();
        }
        public void BindFeedbackMaster()
        {
            rptFeedbackHeading.DataSource = objSSMS.Fill_Datatable(objSQL.Con, "spFeedbackManage", new string[] { "ReadFeedbackMaster" });
            rptFeedbackHeading.DataBind();

            for (int i = 0; i < rptFeedbackHeading.Items.Count; i++)
            {
                Repeater rptFeedbackOption = ((Repeater)rptFeedbackHeading.Items[i].FindControl("rptFeedbackOption"));
                string strIsMul = ((HiddenField)rptFeedbackHeading.Items[i].FindControl("hfIsMultiple")).Value;
                string strFeedbackMstID = ((HiddenField)rptFeedbackHeading.Items[i].FindControl("hfFeedbackMstID")).Value;
                rptFeedbackOption.DataSource = objSSMS.Fill_Datatable(objSQL.Con, "spFeedbackManage", new string[] { "ReadFeedbackOption", strFeedbackMstID });
                rptFeedbackOption.DataBind();
                for (int j = 0; j < rptFeedbackOption.Items.Count; j++)
                {
                    if (strIsMul == "True")
                    {
                        ((CheckBox)rptFeedbackOption.Items[j].FindControl("chkFeedbackOption")).Visible = true;
                        ((RadioButton)rptFeedbackOption.Items[j].FindControl("rdFeedbackOption")).Visible = false;
                    }
                    else
                    {
                        ((CheckBox)rptFeedbackOption.Items[j].FindControl("chkFeedbackOption")).Visible = false;
                        ((RadioButton)rptFeedbackOption.Items[j].FindControl("rdFeedbackOption")).Visible = true;
                    }
                }
            }
        }
        public void BindCustomerDetails(string strCustomerID)
        {
            DataTable dtCustomerDetails = objSSMS.Fill_Datatable(objSQL.Con, "spAgentList", new string[] { "ReadSubClientDetails", string.Empty, string.Empty, string.Empty, strCustomerID });
            if (dtCustomerDetails.Rows.Count > 0)
            {
                hfCustomerID.Value = Convert.ToString(Request.QueryString["CustNo"]);
                txtCustomerName.Text = Convert.ToString(dtCustomerDetails.Rows[0]["CustomerName"]);
                txtAddress.Text = Convert.ToString(dtCustomerDetails.Rows[0]["FullAddress"]);
                txtPhoneNo.Text = Convert.ToString(dtCustomerDetails.Rows[0]["Landline"]);
                txtOName.Text = Convert.ToString(dtCustomerDetails.Rows[0]["OwnerPersonName"]);
                txtOContactNo.Text = Convert.ToString(dtCustomerDetails.Rows[0]["OwnerPersonMobile"]);
                txtOEmailID.Text = Convert.ToString(dtCustomerDetails.Rows[0]["OwnerPersonEmail"]);
                txtTName.Text = Convert.ToString(dtCustomerDetails.Rows[0]["TechnicalPersonName"]);
                txtTContactNo.Text = Convert.ToString(dtCustomerDetails.Rows[0]["TechPersonMobile"]);
                txtTEmailID.Text = Convert.ToString(dtCustomerDetails.Rows[0]["TechPersonEmail"]);
            }
        }
        public void IsAuthentication()
        {
            DataTable dtUsrRoll = objSSMS.Fill_Datatable(objSQL.Con, "spUserAuth", new string[] { "getUsrRoll", string.Empty, string.Empty, objSession.getSession(HttpContext.Current, objTool.getAppValue("UsrRoleID")) });
            if (dtUsrRoll.Rows.Count == 0)
            {
                Response.Redirect(objRout.getRouteURL("Authentication"), false);
                string IsFeedback = Convert.ToString(dtUsrRoll.Rows[0]["IsFeedbackForm"]);
                if (IsFeedback != "True")
                {
                    objSession.unsetSession(HttpContext.Current);
                    Response.Redirect(objRout.getRouteURL("Authentication"), false);
                }
            }
        }
        public bool Validate()
        {
            int counter = 0;
            for (int i = 0; i < rptFeedbackHeading.Items.Count; i++)
            {
                Repeater rptFeedbackOptionValidate = ((Repeater)rptFeedbackHeading.Items[i].FindControl("rptFeedbackOption"));
                string strIsMul = ((HiddenField)rptFeedbackHeading.Items[i].FindControl("hfIsMultiple")).Value;
                string strIsReq = ((HiddenField)rptFeedbackHeading.Items[i].FindControl("hfIsRequired")).Value;
                if (strIsReq == "True")
                {
                    for (int j = 0; j < rptFeedbackOptionValidate.Items.Count; j++)
                    {
                        if (strIsMul == "True")
                        {
                            if (((CheckBox)rptFeedbackOptionValidate.Items[j].FindControl("chkFeedbackOption")).Checked == true && ((HiddenField)rptFeedbackOptionValidate.Items[j].FindControl("hfIsTextbox")).Value == "True" && (!string.IsNullOrEmpty(((TextBox)rptFeedbackOptionValidate.Items[j].FindControl("txtOtherText")).Text)))
                            {
                                counter += 1;
                            }
                            else if (((CheckBox)rptFeedbackOptionValidate.Items[j].FindControl("chkFeedbackOption")).Checked == true && ((HiddenField)rptFeedbackOptionValidate.Items[j].FindControl("hfIsTextbox")).Value == "True" && (string.IsNullOrEmpty(((TextBox)rptFeedbackOptionValidate.Items[j].FindControl("txtOtherText")).Text)))
                            {
                                return false;
                            }
                            else if (((CheckBox)rptFeedbackOptionValidate.Items[j].FindControl("chkFeedbackOption")).Checked == true && ((HiddenField)rptFeedbackOptionValidate.Items[j].FindControl("hfIsTextbox")).Value == "False")
                            {
                                counter += 1;
                            }
                        }
                        else
                        {
                            if (((RadioButton)rptFeedbackOptionValidate.Items[j].FindControl("rdFeedbackOption")).Checked && ((HiddenField)rptFeedbackOptionValidate.Items[j].FindControl("hfIsTextbox")).Value == "True" && (!string.IsNullOrEmpty(((TextBox)rptFeedbackOptionValidate.Items[j].FindControl("txtOtherText")).Text)))
                            {
                                counter += 1;
                            }
                            else if (((RadioButton)rptFeedbackOptionValidate.Items[j].FindControl("rdFeedbackOption")).Checked && ((HiddenField)rptFeedbackOptionValidate.Items[j].FindControl("hfIsTextbox")).Value == "True" && (string.IsNullOrEmpty(((TextBox)rptFeedbackOptionValidate.Items[j].FindControl("txtOtherText")).Text)))
                            {
                                return false;
                            }
                            else if (((RadioButton)rptFeedbackOptionValidate.Items[j].FindControl("rdFeedbackOption")).Checked && ((HiddenField)rptFeedbackOptionValidate.Items[j].FindControl("hfIsTextbox")).Value == "False")
                            {
                                counter += 1;
                            }
                        }
                    }
                }
                else
                {
                    counter = 1;
                }
                if (counter == 0)
                {

                    return false;
                }
                else
                {
                    counter = 0;
                }
            }
            return true;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    if (string.IsNullOrEmpty(Request.QueryString["CustNo"]))
                    {
                        Response.Redirect(objRout.getRouteURL("AgentList"));
                    }
                    else
                    {
                        Reset();
                        txtDate.Text = DateTime.Today.ToString(objTool.getAppValue("SystemDateFormate"));
                        txtJCILExec.Text = objSession.getSession(HttpContext.Current, objTool.getAppValue("ExecutiveName"));
                        hfExecutiveCode.Value = objSession.getSession(HttpContext.Current, objTool.getAppValue("ExecutiveCode"));
                        hfItemCategoryCode.Value = objSession.getSession(HttpContext.Current, objTool.getAppValue("ItemCategoryCode"));
                        BindFeedbackMaster();
                        BindCustomerDetails(Convert.ToString(Request.QueryString["CustNo"]));
                    }
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            DateTime dtNow = DateTime.Today;
            if (!DateTime.TryParse(txtDate.Text, out dtNow))
            {
                var message1 = new JavaScriptSerializer().Serialize("Please enter date in proper format.");
                var script1 = string.Format("alert({0});", message1);
                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", script1, true);
            }
            else if (!Validate())
            {
                var message1 = new JavaScriptSerializer().Serialize("Please fill all the fields of the feedback form.");
                var script1 = string.Format("alert({0});", message1);
                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", script1, true);
            }
            //            else if (string.IsNullOrEmpty(txtOName.Text) || string.IsNullOrWhiteSpace(txtOName.Text))
            //            {

//                var message1 = new JavaScriptSerializer().Serialize("Enter Owner Name");
            //                var script1 = string.Format("alert({0});", message1);
            //                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", script1, true);
            //                //objTool.jsWarning(ltrNotificationArea, "Enter Owner Name");
            //            }
            //            else if (string.IsNullOrEmpty(txtODesignation.Text) || string.IsNullOrWhiteSpace(txtODesignation.Text))
            //            {
            //                var message1 = new JavaScriptSerializer().Serialize("Enter Owner Designation");
            //                var script1 = string.Format("alert({0});", message1);
            //                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", script1, true);

//                //objTool.jsWarning(ltrNotificationArea, "Enter Owner Designation");
            //            }
            //            else if (string.IsNullOrEmpty(txtOContactNo.Text) || string.IsNullOrWhiteSpace(txtOContactNo.Text))
            //            {
            //                var message1 = new JavaScriptSerializer().Serialize("Enter Owner Contact No");
            //                var script1 = string.Format("alert({0});", message1);
            //                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", script1, true);

//                ///objTool.jsWarning(ltrNotificationArea, "Enter Owner Contact No");
            //            }
            //            else if (string.IsNullOrEmpty(txtTName.Text) || string.IsNullOrWhiteSpace(txtTName.Text))
            //            {
            //                var message1 = new JavaScriptSerializer().Serialize("Enter Technical Name");
            //                var script1 = string.Format("alert({0});", message1);
            //                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", script1, true);

////                objTool.jsWarning(ltrNotificationArea, "Enter Technical Name");
            //            }
            //            else if (string.IsNullOrEmpty(txtTDesignation.Text) || string.IsNullOrWhiteSpace(txtTDesignation.Text))
            //            {
            //                var message1 = new JavaScriptSerializer().Serialize("Enter Technical Designation");
            //                var script1 = string.Format("alert({0});", message1);
            //                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", script1, true);

//                //objTool.jsWarning(ltrNotificationArea, "Enter Technical Designation");
            //            }
            //            else if (string.IsNullOrEmpty(txtTContactNo.Text) || string.IsNullOrWhiteSpace(txtTContactNo.Text))
            //            {
            //                var message1 = new JavaScriptSerializer().Serialize("Enter Technical Contact No");
            //                var script1 = string.Format("alert({0});", message1);
            //                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", script1, true);

//                //objTool.jsWarning(ltrNotificationArea, "Enter Technical Contact No");
            //            }
            //            else if (string.IsNullOrEmpty(txtTEmailID.Text) || string.IsNullOrWhiteSpace(txtTEmailID.Text))
            //            {
            //                var message1 = new JavaScriptSerializer().Serialize("Enter Technical Email ID");
            //                var script1 = string.Format("alert({0});", message1);
            //                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", script1, true);

//                //objTool.jsWarning(ltrNotificationArea, "Enter Technical Email ID");
            //            }



            else
            {
                try
                {
                    long CustID = 0;
                    string strCustFeedbackID = objSSMS.ExecutedStoreProcedure(objSQL.Con, "spCustomerFeeback", new string[] { "CreateCustomerFeedback", string.Empty, txtDate.Text, hfItemCategoryCode.Value, hfCustomerID.Value, txtOName.Text, txtODesignation.Text, txtOContactNo.Text, txtOEmailID.Text, txtTName.Text, txtTDesignation.Text, txtTContactNo.Text, txtTEmailID.Text });
                    if (long.TryParse(strCustFeedbackID, out CustID))
                    {
                        for (int i = 0; i < rptFeedbackHeading.Items.Count; i++)
                        {
                            string strIsMultiple = ((HiddenField)rptFeedbackHeading.Items[i].FindControl("hfIsMultiple")).Value;
                            Repeater rptFeedbackOption = ((Repeater)rptFeedbackHeading.Items[i].FindControl("rptFeedbackOption"));

                            string strFeedbackOpID = string.Empty;
                            if (strIsMultiple == "True")
                            {
                                for (int j = 0; j < rptFeedbackOption.Items.Count; j++)
                                {
                                    bool IsTextbox = ((Panel)rptFeedbackOption.Items[j].FindControl("pnlOtherText")).Visible;
                                    if (((CheckBox)rptFeedbackOption.Items[j].FindControl("chkFeedbackOption")).Checked == true)
                                    {
                                        string txtOtherText = string.Empty;
                                        strFeedbackOpID = ((HiddenField)rptFeedbackOption.Items[j].FindControl("FeedbackOpID")).Value;
                                        if (IsTextbox)
                                        {
                                            txtOtherText = ((TextBox)rptFeedbackOption.Items[j].FindControl("txtOtherText")).Text;
                                        }
                                        objSSMS.ExecutedStoreProcedure(objSQL.Con, "spCustomerFeeback", new string[] { "CreateCustomerFeedbackVal", strCustFeedbackID, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, strFeedbackOpID, txtOtherText });
                                    }
                                }
                            }
                            else
                            {
                                for (int j = 0; j < rptFeedbackOption.Items.Count; j++)
                                {
                                    bool IsTextbox = ((Panel)rptFeedbackOption.Items[j].FindControl("pnlOtherText")).Visible;
                                    if (((RadioButton)rptFeedbackOption.Items[j].FindControl("rdFeedbackOption")).Checked)
                                    {
                                        string txtOtherText = string.Empty;
                                        strFeedbackOpID = ((HiddenField)rptFeedbackOption.Items[j].FindControl("FeedbackOpID")).Value;
                                        if (IsTextbox)
                                        {
                                            txtOtherText = ((TextBox)rptFeedbackOption.Items[j].FindControl("txtOtherText")).Text;
                                        }
                                        objSSMS.ExecutedStoreProcedure(objSQL.Con, "spCustomerFeeback", new string[] { "CreateCustomerFeedbackVal", strCustFeedbackID, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, strFeedbackOpID, txtOtherText });
                                        break;
                                    }
                                }
                            }
                        }
                        string updateCustomerReg = objSSMS.ExecutedStoreProcedure(objSQL.Con, "spCustomerFeeback", new string[] { "UpdateRegisteredCustomer", string.Empty, string.Empty, string.Empty, hfCustomerID.Value, txtOName.Text, txtODesignation.Text, txtOContactNo.Text, txtOEmailID.Text, txtTName.Text, txtTDesignation.Text, txtTContactNo.Text, txtTEmailID.Text });

                        var message1 = new JavaScriptSerializer().Serialize("Feedback form filled successfully.!!!");
                        var script1 = string.Format("alert({0});window.location='frmAgent.aspx';", message1);
                        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", script1, true);

                    }
                }
                catch (TransactionAbortedException ex)
                {
                    objTool.jsError(ltrNotificationArea, ex.Message.ToString());
                    var message1 = new JavaScriptSerializer().Serialize(ex.Message.ToString());
                    var script1 = string.Format("alert({0});", message1);
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", script1, true);
                }
                catch (ApplicationException ex)
                {
                    objTool.jsError(ltrNotificationArea, ex.Message.ToString());
                    var message1 = new JavaScriptSerializer().Serialize(ex.Message.ToString());
                    var script1 = string.Format("alert({0});", message1);
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", script1, true);
                }
                catch (Exception ex)
                {
                    objTool.jsError(ltrNotificationArea, ex.Message.ToString());
                    var message1 = new JavaScriptSerializer().Serialize(ex.Message.ToString());
                    var script1 = string.Format("alert({0});", message1);
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", script1, true);
                }

            }
        }
        protected void rdFeedbackOption_CheckedChanged(object sender, EventArgs e)
        {
            int RadioIndex = ((RepeaterItem)((RadioButton)sender).NamingContainer).ItemIndex;
            Repeater rpFeedbackOption = ((Repeater)((RepeaterItem)((RadioButton)sender).NamingContainer).Parent);
            for (int i = 0; i < rpFeedbackOption.Items.Count; i++)
            {
                if (RadioIndex != i)
                {
                    ((RadioButton)rpFeedbackOption.Items[i].FindControl("rdFeedbackOption")).Checked = false;
                    ((TextBox)rpFeedbackOption.Items[i].FindControl("txtOtherText")).Visible = false;
                    ((Panel)rpFeedbackOption.Items[i].FindControl("pnlOtherText")).Visible = false;
                }
                else
                {
                    if (((HiddenField)rpFeedbackOption.Items[i].FindControl("hfIsTextbox")).Value == "True")
                    {
                        ((TextBox)rpFeedbackOption.Items[i].FindControl("txtOtherText")).Visible = true;
                        ((Panel)rpFeedbackOption.Items[i].FindControl("pnlOtherText")).Visible = true;
                    }
                    else
                    {
                        ((TextBox)rpFeedbackOption.Items[i].FindControl("txtOtherText")).Visible = false;
                        ((Panel)rpFeedbackOption.Items[i].FindControl("pnlOtherText")).Visible = false;
                    }
                }
            }
        }
        protected void chkFeedbackOption_CheckedChanged(object sender, EventArgs e)
        {
            int RadioIndex = ((RepeaterItem)((CheckBox)sender).NamingContainer).ItemIndex;
            CheckBox chkFeedbackOption = ((CheckBox)sender);
            Repeater rpFeedbackOption = ((Repeater)((RepeaterItem)((CheckBox)sender).NamingContainer).Parent);

            if (((HiddenField)rpFeedbackOption.Items[RadioIndex].FindControl("hfIsTextbox")).Value == "True")
            {
                ((TextBox)rpFeedbackOption.Items[RadioIndex].FindControl("txtOtherText")).Visible = chkFeedbackOption.Checked;
                ((Panel)rpFeedbackOption.Items[RadioIndex].FindControl("pnlOtherText")).Visible = chkFeedbackOption.Checked;
            }
            else
            {
                ((TextBox)rpFeedbackOption.Items[RadioIndex].FindControl("txtOtherText")).Visible = false;
                ((Panel)rpFeedbackOption.Items[RadioIndex].FindControl("pnlOtherText")).Visible = false;
            }
        }
    }
}