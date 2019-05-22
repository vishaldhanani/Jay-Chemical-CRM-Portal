using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AppStarSQL;
using DataSecurity;

namespace CRMPortal
{
    public partial class frmAppConfig : System.Web.UI.Page
    {
        AppTools objTool = new AppTools();
        AppSQL objSQL = new AppSQL();
        SSMSTool objSSMS = new SSMSTool();
        SecurityAlgorithm objSecurity = new SecurityAlgorithm();
        AppRouting objRout = new AppRouting();
        AppSession objSession = new AppSession();

        //Page Method
        public void IsAuthentication()
        {
            DataTable dtUsrRoll = objSSMS.Fill_Datatable(objSQL.Con, "spUserAuth", new string[] { "getUsrRoll", string.Empty, string.Empty, objSession.getSession(HttpContext.Current, objTool.getAppValue("UsrRoleID")) });
            if (dtUsrRoll.Rows.Count == 0)
            {
                Response.Redirect(objRout.getRouteURL("Authentication"), false);
                string strIsConfig = Convert.ToString(dtUsrRoll.Rows[0]["IsConfigAuth"]);
                if (strIsConfig != "True")
                {
                    objSession.unsetSession(HttpContext.Current);
                    Response.Redirect(objRout.getRouteURL("Authentication"), false);
                }
            }
        }

        //User Mananger Methods
        public void BindNonGeneateUsr()
        {
            dpSalesPerson.Items.Clear();
            dpSalesPerson.Items.Add(new ListItem("Select Sales Person", string.Empty));
            dpSalesPerson.AppendDataBoundItems = true;
            dpSalesPerson.DataSource = objSSMS.Fill_Datatable(objSQL.Con, "spUserAuth", new string[] { "SPListNotUsrCrated" });
            dpSalesPerson.DataTextField = "Name";
            dpSalesPerson.DataValueField = "Code";
            dpSalesPerson.DataBind();

        }
        public void BindItemCategory()
        {
            dpItemCategory.Items.Clear();
            //dpItemCategory.Items.Add(new ListItem("Select Item Category", string.Empty));
            dpItemCategory.AppendDataBoundItems = true;

            //dpItemCategory.Items.Clear();
            //dpItemCategory.Items.Add(new ListItem("Select Item Category", string.Empty));
            //dpItemCategory.AppendDataBoundItems = true;
            dpItemCategory.DataSource = objSSMS.Fill_Datatable(objSQL.Con, "spUserAuth", new string[] { "ReadItemCategory", string.Empty, string.Empty, string.Empty, dpSalesPerson.SelectedValue });
            dpItemCategory.DataTextField = "ItemCategoryCode";
            dpItemCategory.DataValueField = "ItemCategoryCode";
            dpItemCategory.DataBind();

        }
        public void BindItemCategoryPanel()
        {
            lbItemCategory.Items.Clear();
            lbItemCategory.DataSource = objSSMS.Fill_Datatable(objSQL.Con, "spUserAuth", new string[] { "ReadItemCategory", string.Empty, string.Empty, string.Empty, dpSalesPerson.SelectedValue });
            lbItemCategory.DataTextField = "ItemCategoryCode";
            lbItemCategory.DataValueField = "ItemCategoryCode";
            lbItemCategory.DataBind();

        }
        public void BindUserList()
        {
            string IsAdmin = rdOption.SelectedIndex == 0 ? "1" : "0";
            rptUserList.DataSource = objSSMS.Fill_Datatable(objSQL.Con, "spUserAuth", new string[] { "ReadAll", string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, IsAdmin });
            rptUserList.DataBind();
            //pnlUsrType.Visible = true;
        }
        public bool IsValidUpdateIC()
        {
            bool IsValid = false;
            for (int i = 0; i < lbItemCategory.Items.Count; i++)
            {
                if (lbItemCategory.Items[i].Selected == true)
                {
                    IsValid = true;
                }
            }
            return IsValid;
        }
        public void UserReset()
        {
            BindUserList();
            BindNonGeneateUsr();
            BindUserList();
            txtUserID.Text = string.Empty;
            txtUsrPwd.Text = string.Empty;
            dpUsrRoll.SelectedIndex = 0;
            btnAddUser.Text = "Add User";
            hfUser.Value = string.Empty;
            btnUserClear.Visible = false;
            dpItemCategory.SelectedIndex = -1;
        }

        //User Roll Methods
        public void BindUserRolls()
        {
            DataTable dtUsrRoll = objSSMS.Fill_Datatable(objSQL.Con, "spUserRole", new string[] { "ReadAll" });
            rptUsrAuth.DataSource = dtUsrRoll;
            rptUsrAuth.DataBind();

            dpUsrRoll.Items.Clear();
            dpUsrRoll.Items.Add(new ListItem("Select User Roll", string.Empty));
            dpUsrRoll.AppendDataBoundItems = true;
            if (dtUsrRoll.Rows.Count > 0)
            {
                dpUsrRoll.DataSource = objSSMS.Fill_Datatable(objSQL.Con, "spUserRole", new string[] { "ReadAll", string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, "1" });
                dpUsrRoll.DataTextField = "UsrRollName";
                dpUsrRoll.DataValueField = "UsrRollID";
                dpUsrRoll.DataBind();
            }

            BindUserRollsDrop(false);
        }
        public void BindUserRollsDrop(bool IsAdmin)
        {
            dpUsrRoll.Items.Clear();
            dpUsrRoll.Items.Add(new ListItem("Select User Roll", string.Empty));
            dpUsrRoll.AppendDataBoundItems = true;
            dpUsrRoll.DataSource = objSSMS.Fill_Datatable(objSQL.Con, "spUserRole", new string[] { "ReadAll", string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, IsAdmin == true ? "1" : "0", "1" });
            dpUsrRoll.DataTextField = "UsrRollName";
            dpUsrRoll.DataValueField = "UsrRollID";
            dpUsrRoll.DataBind();
        }
        //Feedback Heading Methods
        public void BindFeedbackMaster()
        {
            DataTable dtFeedbackMst = objSSMS.Fill_Datatable(objSQL.Con, "spFeedbackManage", new string[] { "ReadFeedbackMaster" });

            rptFeedbackHead.DataSource = dtFeedbackMst;
            rptFeedbackHead.DataBind();

            dpFeedbackHeading.Items.Clear();
            dpFeedbackHeading.Items.Add(new ListItem("Select Feedback Heading", string.Empty));
            dpFeedbackHeading.AppendDataBoundItems = true;
            dpFeedbackHeading.DataSource = dtFeedbackMst;
            dpFeedbackHeading.DataTextField = "FeedbackMstTag";
            dpFeedbackHeading.DataValueField = "FeedbackMstID";
            dpFeedbackHeading.DataBind();
        }
        public void ResetFeedbackHeading()
        {
            txtFeedbackHeading.Text = string.Empty;
            chkIsMultipSel.Checked = false;
            chkIsRequired.Checked = false;
            btnNew.Text = "New";
            hfFeedbackHeading.Value = string.Empty;
            ltrNotificationArea.Text = string.Empty;
            BindFeedbackMaster();
        }

        //Feedback Option Methods
        public void ResetFeedbackOption()
        {
            ltrNotificationArea.Text = string.Empty;
        }

        //Page Load Event
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    rdOption.SelectedIndex = 1;
                    BindNonGeneateUsr();
                    BindItemCategory();
                    BindUserRolls();
                    BindUserList();
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }

        //User Auth Events
        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            try
            {
                string itemcategory = string.Empty;
                foreach (ListItem li in dpItemCategory.Items)
                {
                    if (li.Selected)
                    {
                        itemcategory += itemcategory == string.Empty ? li.Text : "|" + li.Text;
                    }
                }
                if (rdOption.SelectedIndex == -1)
                {
                    objTool.jsWarning(ltrNotificationArea, "Select User Type!");
                }
                else if (rdOption.SelectedIndex == 1 && dpSalesPerson.SelectedIndex == 0)
                {
                    objTool.jsWarning(ltrNotificationArea, "Select Sales Person!");
                }
                else if (rdOption.SelectedIndex == -1)
                {
                    objTool.jsWarning(ltrNotificationArea, "Select Item Category Code!");
                }
                else if (string.IsNullOrEmpty(txtUserID.Text) || string.IsNullOrWhiteSpace(txtUserID.Text))
                {
                    objTool.jsWarning(ltrNotificationArea, "Enter User ID!");
                }
                else if (string.IsNullOrEmpty(txtUsrPwd.Text) || string.IsNullOrWhiteSpace(txtUsrPwd.Text))
                {
                    objTool.jsWarning(ltrNotificationArea, "Enter Passsword!");
                }
                else if (string.IsNullOrEmpty(txtConfPassword.Text) || string.IsNullOrWhiteSpace(txtConfPassword.Text))
                {
                    objTool.jsWarning(ltrNotificationArea, "Enter Confirm Passsword!");
                }
                else if (string.Compare(txtConfPassword.Text, txtUsrPwd.Text) != 0)
                {
                    objTool.jsWarning(ltrNotificationArea, "Enter Password and Confirm Passsword does not match!");
                }
                else if (dpUsrRoll.SelectedIndex == 0)
                {
                    objTool.jsWarning(ltrNotificationArea, "Select User Roll!");
                }
                else if (objSSMS.ExecutedStoreProcedure(objSQL.Con, "spUserAuth", new string[] { "getUserCount", txtUserID.Text }) != "0")
                {
                    objTool.jsWarning(ltrNotificationArea, "This User already created. Enter Unique User ID.");
                }
                else
                {
                    if (string.IsNullOrEmpty(hfUser.Value))
                    {
                        objSSMS.ExecutedStoreProcedure(objSQL.Con, "spUserAuth", new string[] { "CreateUser", txtUserID.Text, objSecurity.EncryptWithKey(txtConfPassword.Text, objTool.getAppValue("SecurityKey")), dpUsrRoll.SelectedValue, rdOption.SelectedIndex == 0 ? txtUserID.Text : dpSalesPerson.SelectedValue, itemcategory });
                        UserReset();
                        objTool.jsSuccess(ltrNotificationArea, "New User Created.");
                    }
                    else
                    {
                        objSSMS.ExecutedStoreProcedure(objSQL.Con, "spUserAuth", new string[] { "UpdateUser", txtUserID.Text, string.IsNullOrEmpty(txtConfPassword.Text) == true ? string.Empty : objSecurity.EncryptWithKey(txtConfPassword.Text, objTool.getAppValue("SecurityKey")), dpUsrRoll.SelectedValue, rdOption.SelectedIndex == 0 ? txtUserID.Text : dpSalesPerson.SelectedValue, itemcategory, string.Empty, hfUser.Value });
                        UserReset();
                        objTool.jsSuccess(ltrNotificationArea, "User Updated.");
                    }
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void lnkUsrMgt_Click(object sender, EventArgs e)
        {
            try
            {
                string strCommand = ((LinkButton)sender).CommandName;

                pnlUsrMgt.Visible = false;
                pnlFeedbackHeading.Visible = false;
                pnlFeedbackOption.Visible = false;
                pnlUsrRoll.Visible = false;

                switch (strCommand)
                {
                    case "UsrPnl":
                        BindNonGeneateUsr();
                        pnlUsrMgt.Visible = true;
                        break;
                    case "FeedHeading":
                        BindFeedbackMaster();
                        pnlFeedbackHeading.Visible = true;
                        break;
                    case "FeedOption":
                        pnlFeedbackOption.Visible = true;
                        break;
                    case "UsrRoll":
                        pnlUsrRoll.Visible = true;
                        break;
                    default:
                        break;
                }

                ResetFeedbackHeading();
                ResetFeedbackOption();
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void rdOption_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (rdOption.SelectedValue == "Admin")
                {
                    pnlUsrType.Visible = false;
                    BindUserList();
                    BindUserRollsDrop(true);
                }
                else
                {
                    pnlUsrType.Visible = true;
                    BindUserList();
                    BindUserRollsDrop(false);
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void dpSalesPerson_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                //if (dpSalesPerson.SelectedIndex == 0)
                //{
                //    dpItemCategory.Items.Clear();
                //    dpItemCategory.Items.Add(new ListItem("Select Item Category", string.Empty));
                //}
                //else
                //{
                //    dpItemCategory.Items.Clear();
                //    dpItemCategory.Items.Add(new ListItem("Select Item Category", string.Empty));
                //    dpItemCategory.AppendDataBoundItems = true;
                //    dpItemCategory.DataSource = objSSMS.Fill_Datatable(objSQL.Con, "spUserAuth", new string[] { "ReadItemCategory", string.Empty, string.Empty, string.Empty, dpSalesPerson.SelectedValue });
                //    dpItemCategory.DataTextField = "ItemCategoryCode";
                //    dpItemCategory.DataValueField = "ItemCategoryCode";
                //    dpItemCategory.DataBind();
                //}
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void chkIsActive_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                CheckBox chkIsActive = ((CheckBox)sender);
                int ItemIndex = ((RepeaterItem)chkIsActive.NamingContainer).ItemIndex;
                // ADDED NEW USER ID.

                hfUser.Value = ((HiddenField)rptUserList.Items[ItemIndex].FindControl("hfUsrID")).Value;

                string strStatus = chkIsActive.Checked == true ? "1" : "0";
                objSSMS.ExecutedStoreProcedure(objSQL.Con, "spUserAuth", new string[] { "UdateUserStatus", hfUser.Value, string.Empty, string.Empty, string.Empty, string.Empty, strStatus });
                BindUserList();
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void lnkbtnItemCategoryCode_Click(object sender, EventArgs e)
        {
            try
            {

                int ItemIndex = ((RepeaterItem)((LinkButton)sender).NamingContainer).ItemIndex;
                hfUserRow.Value = ((Label)rptUserList.Items[ItemIndex].FindControl("lblUserCode")).Text;
                pnlItemCategory.Visible = true;
                BindItemCategoryPanel();
                string[] ListItemCategory = ((LinkButton)sender).Text.Split('|').ToArray();
                if (ListItemCategory.Length > 0)
                {
                    for (int i = 0; i < lbItemCategory.Items.Count; i++)
                    {
                        for (int j = 0; j < ListItemCategory.Length; j++)
                        {
                            if (lbItemCategory.Items[i].Value == ListItemCategory[j].Trim())
                            {
                                lbItemCategory.Items[i].Selected = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void lnkUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (IsValidUpdateIC() == false)
                {
                    objTool.jsWarning(ltrICNotification, "At Least one Item Category has selected.");
                }
                else
                {
                    string ItemCatory = string.Empty;
                    for (int i = 0; i < lbItemCategory.Items.Count; i++)
                    {
                        if (lbItemCategory.Items[i].Selected == true)
                        {
                            ItemCatory += ItemCatory == string.Empty ? lbItemCategory.Items[i].Text : "|" + lbItemCategory.Items[i].Text;
                        }
                    }
                    objSSMS.ExecutedStoreProcedure(objSQL.Con, "spUserAuth", new string[] { "UpdateItemCateogory", hfUserRow.Value, string.Empty, string.Empty, string.Empty, ItemCatory });
                    objTool.jsSuccess(ltrNotificationArea, hfUserRow.Value + " User ID's Item Category Update Successfully.");
                    pnlItemCategory.Visible = false;
                    hfUserRow.Value = string.Empty;
                    BindUserList();
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void lnkClear_Click(object sender, EventArgs e)
        {
            try
            {
                pnlItemCategory.Visible = false;
                hfUserRow.Value = string.Empty;
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void lnkEdit_Click(object sender, EventArgs e)
        {
            try
            {
                int ItemIndex = ((RepeaterItem)((LinkButton)sender).NamingContainer).ItemIndex;
                hfUser.Value = ((HiddenField)rptUserList.Items[ItemIndex].FindControl("hfUsrID")).Value;
                txtUserID.Text = ((Label)rptUserList.Items[ItemIndex].FindControl("lblUserCode")).Text;
                dpSalesPerson.SelectedValue = ((HiddenField)rptUserList.Items[ItemIndex].FindControl("hdnSalesPersonId")).Value;
                dpUsrRoll.SelectedValue = ((HiddenField)rptUserList.Items[ItemIndex].FindControl("hfUsrRollID")).Value;
                string[] ItemCat = ((LinkButton)rptUserList.Items[ItemIndex].FindControl("lnkbtnItemCategoryCode")).Text.Split('|');
                for (int i = 0; i < ItemCat.Length; i++)
                {
                    for (int j = 0; j < dpItemCategory.Items.Count; j++)
                    {
                        if (dpItemCategory.Items[j].Value == ItemCat[i])
                        {
                            dpItemCategory.Items[j].Selected = true;
                        }
                    }
                }
                btnAddUser.Text = "Update User";
                btnUserClear.Visible = true;
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void btnUserClear_Click(object sender, EventArgs e)
        {
            try
            {
                UserReset();
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }

        //User Roll Events
        protected void btnAddUsrRoll_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(txtUsrRoll.Text) || string.IsNullOrWhiteSpace(txtUsrRoll.Text))
                {
                    objTool.jsWarning(ltrNotificationArea, "Please Enter User Roll.");
                }
                else
                {
                    objSSMS.ExecutedStoreProcedure(objSQL.Con, "spUserRole", new string[] { "Create", string.Empty, txtUsrRoll.Text, string.Empty, string.Empty, string.Empty, chkIsAdministrator.Checked == true ? "1" : "0" });
                    txtUsrRoll.Text = string.Empty;
                    chkIsAdministrator.Checked = false;
                    BindUserRolls();
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void chkIsFeedback_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                string strUsrRollID = ((HiddenField)rptUsrAuth.Items[((RepeaterItem)((CheckBox)sender).NamingContainer).ItemIndex].FindControl("hfUsrRollID")).Value;
                objSSMS.ExecutedStoreProcedure(objSQL.Con, "spUserRole", new string[] { "UpdateIsFeedback", strUsrRollID, string.Empty, string.Empty, ((CheckBox)sender).Checked == true ? "1" : "0" });
                objTool.jsSuccess(ltrNotificationArea, "Update Authentication");
                BindUserRolls();
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void chkIsAppConfig_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                string strUsrRollID = ((HiddenField)rptUsrAuth.Items[((RepeaterItem)((CheckBox)sender).NamingContainer).ItemIndex].FindControl("hfUsrRollID")).Value;
                objSSMS.ExecutedStoreProcedure(objSQL.Con, "spUserRole", new string[] { "UpdateIsConfigAuth", strUsrRollID, string.Empty, ((CheckBox)sender).Checked == true ? "1" : "0" });
                objTool.jsSuccess(ltrNotificationArea, "Update Authentication");
                BindUserRolls();
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void chkIsActive_CheckedChanged1(object sender, EventArgs e)
        {
            try
            {
                CheckBox ResponseCheck = ((CheckBox)sender);
                int ItemIndex = ((RepeaterItem)ResponseCheck.NamingContainer).ItemIndex;
                string strRollID = ((HiddenField)rptUsrAuth.Items[ItemIndex].FindControl("hfUsrRollID")).Value;
                objSSMS.ExecutedStoreProcedure(objSQL.Con, "spUserRole", new string[] { "Blocked", strRollID, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, ResponseCheck.Checked == true ? "1" : "0" });
                objTool.jsSuccess(ltrNotificationArea, "Roll Status Update Successfully.");
                BindUserRolls();
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }

        //Feedback Master Events
        protected void btnNew_Click(object sender, EventArgs e)
        {
            try
            {
                if (hfFeedbackHeading.Value == string.Empty)
                {
                    objSSMS.ExecutedStoreProcedure(objSQL.Con, "spFeedbackManage", new string[] { "CreateFeedbackMaster", string.Empty, txtFeedbackHeading.Text, chkIsMultipSel.Checked == true ? "1" : "0", string.Empty, string.Empty, string.Empty, chkIsRequired.Checked == true ? "1" : "0" });
                    ResetFeedbackHeading();
                    objTool.jsSuccess(ltrNotificationArea, "Feedback Master Add.");
                }
                else
                {
                    objSSMS.ExecutedStoreProcedure(objSQL.Con, "spFeedbackManage", new string[] { "UpdateFeedbackMaster", hfFeedbackHeading.Value, txtFeedbackHeading.Text, chkIsMultipSel.Checked == true ? "1" : "0", string.Empty, string.Empty, string.Empty, chkIsRequired.Checked == true ? "1" : "0" });
                    ResetFeedbackHeading();
                    objTool.jsSuccess(ltrNotificationArea, "Feedback Master Update.");
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void btnEdit_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lnkCommand = ((LinkButton)sender);
                int i = ((RepeaterItem)lnkCommand.NamingContainer).ItemIndex;
                string strCmd = lnkCommand.CommandName;
                switch (strCmd)
                {
                    case "cmdEdit":
                        hfFeedbackHeading.Value = ((HiddenField)rptFeedbackHead.Items[i].FindControl("hfFeedbackHeadingID")).Value;
                        txtFeedbackHeading.Text = ((Label)rptFeedbackHead.Items[i].FindControl("lblFeedbackMstTag")).Text;
                        chkIsMultipSel.Checked = ((Label)rptFeedbackHead.Items[i].FindControl("lblIsMultiple")).Text == "Yes" ? true : false;
                        chkIsRequired.Checked = ((Label)rptFeedbackHead.Items[i].FindControl("lblIsRequired")).Text == "Yes" ? true : false;
                        btnNew.Text = "Update";
                        ltrNotificationArea.Text = string.Empty;
                        break;
                    case "cmdDel":
                        objSSMS.ExecutedStoreProcedure(objSQL.Con, "spFeedbackManage", new string[] { "DeleteFeedbackMaster", ((HiddenField)rptFeedbackHead.Items[i].FindControl("hfFeedbackHeadingID")).Value });
                        objTool.jsSuccess(ltrNotificationArea, "Feedback Master Remove.");
                        ResetFeedbackHeading();
                        break;
                    default:
                        break;
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }

        //Feedbaction Option Events
        protected void dpFeedbackHeading_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (dpFeedbackHeading.SelectedIndex != 0)
                {
                    rptFeedbackOption0.DataSource = objSSMS.Fill_Datatable(objSQL.Con, "spFeedbackManage", new string[] { "ReadFeedbackOption", dpFeedbackHeading.SelectedValue });
                    rptFeedbackOption0.DataBind();
                    pnlFeedbackOpMgt.Visible = true;
                }
                else
                {
                    rptFeedbackOption0.DataSource = null;
                    rptFeedbackOption0.DataBind();
                    pnlFeedbackOpMgt.Visible = false;
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void btnAddFeedbackOp_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(hfFeedbackOpTag.Value))
                {
                    if (string.IsNullOrEmpty(txtFeedbackOpTag.Text) || string.IsNullOrWhiteSpace(txtFeedbackOpTag.Text))
                    {
                        objTool.jsWarning(ltrNotificationArea, "Enter Feedback Option Tag.");
                    }
                    else
                    {
                        objSSMS.ExecutedStoreProcedure(objSQL.Con, "spFeedbackManage", new string[] { "CreateFeedbackOption", dpFeedbackHeading.SelectedValue, string.Empty, string.Empty, string.Empty, txtFeedbackOpTag.Text, IsTextbox.Checked == true ? "1" : "0" });
                        txtFeedbackOpTag.Text = string.Empty;
                        IsTextbox.Checked = false;
                        rptFeedbackOption0.DataSource = objSSMS.Fill_Datatable(objSQL.Con, "spFeedbackManage", new string[] { "ReadFeedbackOption", dpFeedbackHeading.SelectedValue });
                        rptFeedbackOption0.DataBind();
                        pnlFeedbackOpMgt.Visible = true;

                    }
                }
                else
                {
                    objSSMS.ExecutedStoreProcedure(objSQL.Con, "spFeedbackManage", new string[] { "UpdateFeedbackOption", dpFeedbackHeading.SelectedValue, string.Empty, string.Empty, hfFeedbackOpTag.Value, txtFeedbackOpTag.Text, IsTextbox.Checked == true ? "1" : "0" });
                    txtFeedbackOpTag.Text = string.Empty;
                    IsTextbox.Checked = false;
                    rptFeedbackOption0.DataSource = objSSMS.Fill_Datatable(objSQL.Con, "spFeedbackManage", new string[] { "ReadFeedbackOption", dpFeedbackHeading.SelectedValue });
                    rptFeedbackOption0.DataBind();
                    pnlFeedbackOpMgt.Visible = true;
                    hfFeedbackOpTag.Value = string.Empty;
                    btnAddFeedbackOp.Text = "Add Feeback Option";
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
        protected void lnkFOpEdit_Click(object sender, EventArgs e)
        {
            try
            {
                string strCmd = ((LinkButton)sender).CommandName;
                int ItemIndex = ((RepeaterItem)((LinkButton)sender).NamingContainer).ItemIndex;
                switch (strCmd)
                {
                    case "cmdEdit":
                        hfFeedbackOpTag.Value = ((HiddenField)rptFeedbackOption0.Items[ItemIndex].FindControl("hfFeedbackOpID")).Value;
                        txtFeedbackOpTag.Text = ((Label)rptFeedbackOption0.Items[ItemIndex].FindControl("lblFeedbackOp")).Text;
                        IsTextbox.Checked = ((Label)rptFeedbackOption0.Items[ItemIndex].FindControl("lblIsTextBox")).Text == "Yes" ? true : false;
                        btnAddFeedbackOp.Text = "Update";
                        break;
                    case "cmdDel":
                        objSSMS.ExecutedStoreProcedure(objSQL.Con, "spFeedbackManage", new string[] { "DeleteFeedbackOption", string.Empty, string.Empty, string.Empty, ((HiddenField)rptFeedbackOption0.Items[ItemIndex].FindControl("hfFeedbackOpID")).Value });
                        rptFeedbackOption0.DataSource = objSSMS.Fill_Datatable(objSQL.Con, "spFeedbackManage", new string[] { "ReadFeedbackOption", dpFeedbackHeading.SelectedValue });
                        rptFeedbackOption0.DataBind();
                        break;
                    default:
                        break;
                }
            }
            catch (Exception ex)
            {
                objTool.jsError(ltrNotificationArea, ex.Message.ToString());
            }
        }
    }
}