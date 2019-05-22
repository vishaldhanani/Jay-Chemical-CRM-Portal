<%@ Page Title="" Language="C#" MasterPageFile="~/mstNavClient.master" AutoEventWireup="true" CodeBehind="frmAppConfig.aspx.cs" Inherits="CRMPortal.frmAppConfig" %>

<asp:Content ID="Content1" ContentPlaceHolderID="mstNavClientHead" runat="server">
    <style>
        @media (max-width: 768px) {
            .btn {
                margin-top: 8px;
                margin-bottom: 8px;
            }
        }
    </style>
    <style>
        /*for Item Tracking Show*/
        .DialogView {
            position: fixed;
            height: 100%;
            width: 100%;
            top: 0;
            right: 0;
            left: 0;
            z-index: 9999999;
            background-color: rgba(245, 245, 245, 0.69);
        }

        .ModalPanel-lg {
            width: 80% !important;
            right: 10%;
            left: 10%;
            height: 650px;
        }

        .ModalPanel-sm {
            width: 40% !important;
            right: 30%;
            left: 30%;
        }

        .ModalPanel-md {
            width: 60% !important;
            right: 20%;
            left: 20%;
            height: 450px;
        }

        .ModalPanel {
            position: fixed;
            top: 5%;
            background-color: #ffffff;
            border: 1px solid #3b5998;
            -webkit-box-shadow: 0px 0px 10px 0px rgba(94,94,94,1);
            -moz-box-shadow: 0px 0px 10px 0px rgba(94,94,94,1);
            box-shadow: 0px 0px 10px 0px rgba(94,94,94,1);
            padding: 5px;
        }

        .ModalPanelContent {
            margin-top: 2%;
            padding: 20px;
        }

        .ModalPanelHeader {
            padding: 10px;
            background-color: #f5f5f5;
        }

        .ModalPanelFooter {
            padding: 20px;
            margin-top: 15px;
            text-align: right;
            background-color: #f5f5f5;
        }
        /*------------------------------*/
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="mstNavClientBody" runat="server">
    <div class="col-sm-12 col-md-12 col-lg-12 col-xs-12 well main FormPage">
        <ul class="nav nav-tabs">
            <li>
                <asp:LinkButton ID="lnkUsrMgt" runat="server" Text="User Manage" CommandName="UsrPnl" Visible="true" OnClick="lnkUsrMgt_Click" OnClientClick="return showActive(this);" ValidationGroup="NavGrp"></asp:LinkButton>
            </li>
            <li>
                <asp:LinkButton ID="lnkUsrRoll" runat="server" Text="User Roll" CommandName="UsrRoll" Visible="true" OnClick="lnkUsrMgt_Click" ValidationGroup="NavGrp"></asp:LinkButton>
            </li>
            <li>
                <asp:LinkButton ID="lnkFeedbackHeading" runat="server" Text="Feedback Heading" CommandName="FeedHeading" Visible="true" OnClick="lnkUsrMgt_Click" ValidationGroup="NavGrp"></asp:LinkButton>
            </li>
            <li>
                <asp:LinkButton ID="lnkFeebackOption" runat="server" Text="Feedback Option" CommandName="FeedOption" Visible="true" OnClick="lnkUsrMgt_Click" ValidationGroup="NavGrp"></asp:LinkButton>
            </li>
        </ul>
        <div class="clearfix"></div>
        <asp:Literal ID="ltrNotificationArea" runat="server"></asp:Literal>
        <div class="row placeholders">
            <asp:Panel ID="pnlUsrMgt" runat="server">
                <div class="col-lg-12">
                    <h4 class="panel-heading">User Manage
                    </h4>
                </div>
                <div class="clearfix"></div>
                <hr />
                <div class="form-group col-lg-6">
                    <div class="col-lg-3 col-md-2 col-xs-12 col-sm-12">
                        <label>User Type</label>
                    </div>
                    <div class="col-lg-4 col-md-4 col-xs-12 col-sm-12">
                        <asp:RadioButtonList ID="rdOption" runat="server" AutoPostBack="true" OnSelectedIndexChanged="rdOption_SelectedIndexChanged">
                            <asp:ListItem Text="Administrator" Value="Admin"></asp:ListItem>
                            <asp:ListItem Text="User" Value="User" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                </div>
                <div class="clearfix"></div>

                <asp:Panel ID="pnlUsrType" runat="server" CssClass="form-group col-lg-12" Visible="true">
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Sales Person</label>
                    </div>
                    <div class="col-lg-4 col-md-4 col-xs-12 col-sm-12">
                        <asp:DropDownList ID="dpSalesPerson" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="dpSalesPerson_SelectedIndexChanged"></asp:DropDownList>
                    </div>
                    <div>
                        <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                            <label>Item Category</label>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-12 col-sm-12">
                            <%--<asp:DropDownList ID="dpItemCategory" runat="server" CssClass="form-control"></asp:DropDownList>--%>
                            <asp:ListBox ID="dpItemCategory" runat="server" CssClass="form-control" Height="120px" SelectionMode="Multiple"></asp:ListBox>
                        </div>
                    </div>
                </asp:Panel>
                <div class="form-group col-lg-6">
                    <div class="col-lg-4 col-md-2 col-xs-12 col-sm-12">
                        <label>User ID</label>
                    </div>
                    <div class="col-lg-8 col-md-4 col-xs-12 col-sm-12" style="padding: 0;">
                        <asp:TextBox ID="txtUserID" runat="server" CssClass="form-control" Style="width: 95%; float: right;"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group col-lg-6" style="margin-bottom: 11px;">
                    <div class="col-lg-4 col-md-2 col-xs-12 col-sm-12" style="padding-left: 0px;">
                        <label>Password</label>
                    </div>
                    <div class="col-lg-8 col-md-4 col-xs-12 col-sm-12" style="padding: 0;">
                        <asp:TextBox ID="txtUsrPwd" runat="server" CssClass="form-control" TextMode="Password" Style="width: 95%; float: left; margin-left: 4px;"></asp:TextBox>
                    </div>
                </div>
                <div class="clearfix"></div>
                <div class="form-group col-lg-6" style="margin-bottom: 0px;">
                    <div class="col-lg-4 col-md-2 col-xs-12 col-sm-12" style="padding-left: 0px;">
                        <label>Confirm Password</label>
                    </div>
                    <div class="col-lg-8 col-md-4 col-xs-12 col-sm-12" style="padding: 0;">
                        <asp:TextBox ID="txtConfPassword" runat="server" CssClass="form-control" TextMode="Password" Style="width: 95%; float: right; margin-left: 4px;"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group col-lg-6">
                    <div class="col-lg-4 col-md-2 col-xs-12 col-sm-12" style="padding-left: 0px;">
                        <label>User Roll</label>
                    </div>
                    <div class="col-lg-8 col-md-4 col-xs-12 col-sm-12" style="padding: 0;">
                        <asp:DropDownList ID="dpUsrRoll" runat="server" CssClass="form-control" Style="width: 95%; float: left; margin-left: 4px;"></asp:DropDownList>
                    </div>
                </div>
                <div class="clearfix"></div>
                <br />
                <div class="form-inline col-lg-12">
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <asp:Button ID="btnAddUser" runat="server" Text="Add User" CssClass="btn btn-primary" OnClick="btnAddUser_Click" />
                        <asp:HiddenField ID="hfUser" runat="server" />
                    </div>
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <asp:Button ID="btnUserClear" runat="server" Text="Clear" CssClass="btn btn-primary" OnClick="btnUserClear_Click" Visible="false" />
                    </div>
                </div>
                <div class="clearfix"></div>
                <hr />
                <div class="col-lg-12 table-responsive">
                    <table class="table table-bordered, table-hover">
                        <thead>
                            <tr>
                                <th>User ID
                                </th>
                                <th>User Name
                                </th>
                                <th>User Roll
                                </th>
                                <th>Item Category
                                </th>
                                <th>UnBlock
                                </th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptUserList" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblUserCode" runat="server" Text='<% #Eval("UsrID")%>'></asp:Label>
                                            <asp:HiddenField ID="hfUsrID" runat="server" Value='<% #Eval("UserCode")%>' />
                                        </td>
                                        <td>
                                            <asp:Label ID="lblName" runat="server" Text='<% #Eval("Name")%>'></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblUsrRollName" runat="server" Text='<% #Eval("UsrRollName")%>'></asp:Label>
                                            <asp:HiddenField ID="hfUsrRollID" runat="server" Value='<% #Eval("UsrRollID")%>' />
                                        </td>
                                        <td>
                                            <asp:LinkButton ID="lnkbtnItemCategoryCode" runat="server" Text='<% #Eval("Item Category Code")%>' OnClick="lnkbtnItemCategoryCode_Click"></asp:LinkButton>
                                            <asp:HiddenField ID="hfIsAdmin" runat="server" Value='<% #Eval("IsAdministrator")%>' />

                                            <asp:HiddenField ID="hdnSalesPersonId" runat="server" Value='<% #Eval("ExecuteID")%>' />
                                        </td>
                                        <td>
                                            <asp:CheckBox ID="chkIsActive" runat="server" Checked='<% #Eval("IsActive")%>' AutoPostBack="true" OnCheckedChanged="chkIsActive_CheckedChanged" />
                                        </td>
                                        <td>
                                            <asp:LinkButton ID="lnkEdit" runat="server" CssClass="btn btn-primary" OnClick="lnkEdit_Click">
                                                <span class="glyphicon glyphicon-pencil">
                                                </span>
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
                <div class="clearfix"></div>
                <br />
            </asp:Panel>
            <asp:Panel ID="pnlUsrRoll" runat="server" Visible="false">
                <div class="col-lg-12">
                    <h4 class="panel-heading">User Roll
                    </h4>
                </div>
                <div class="clearfix"></div>
                <hr />
                <div class="form-group col-lg-12">
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>User Roll</label>
                    </div>
                    <div class="col-lg-4 col-md-4 col-xs-12 col-sm-12">
                        <asp:TextBox ID="txtUsrRoll" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group col-lg-12">
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>Is Administrator</label>
                    </div>
                    <div class="col-lg-4 col-md-4 col-xs-12 col-sm-12">
                        <asp:CheckBox ID="chkIsAdministrator" runat="server" />
                    </div>
                </div>
                <div class="form-group col-lg-12">
                    <div class="col-lg-4 col-md-4 col-xs-12 col-sm-12">
                        <asp:Button ID="btnAddUsrRoll" runat="server" CssClass="btn btn-primary" Text="Add" OnClick="btnAddUsrRoll_Click" />
                    </div>
                </div>
                <div class="clearfix"></div>
                <hr />
                <div class="form-group col-lg-12">
                    <div class="col-lg-12 col-md-12 col-xs-12 col-sm-12">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th class="col-lg-3">User Roll
                                        </th>
                                        <th class="col-lg-2">Feedback Access
                                        </th>
                                        <th class="col-lg-3">Configuration Access
                                        </th>
                                        <th class="col-lg-2">Administrator
                                        </th>
                                        <th class="col-lg-2">Is Unblock
                                        </th>
                                    </tr>
                                </thead>
                                <asp:Repeater ID="rptUsrAuth" runat="server">
                                    <ItemTemplate>
                                        <tbody>
                                            <td>
                                                <asp:Label ID="lblUserRoll" runat="server" Text='<% #Eval("UsrRollName")%>'></asp:Label>
                                                <asp:HiddenField ID="hfUsrRollID" runat="server" Value='<% #Eval("UsrRollID")%>' />
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="chkIsFeedback" runat="server" Checked='<% #Eval("IsFeedbackForm")%>' AutoPostBack="true" OnCheckedChanged="chkIsFeedback_CheckedChanged" />
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="chkIsAppConfig" runat="server" Checked='<% #Eval("IsConfigAuth")%>' AutoPostBack="true" OnCheckedChanged="chkIsAppConfig_CheckedChanged" />
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="chkIsAdministraotr" runat="server" Checked='<% #Eval("IsAdministrator")%>' />
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="chkIsActive" runat="server" Checked='<% #Eval("IsActive")%>' AutoPostBack="true" OnCheckedChanged="chkIsActive_CheckedChanged1" />
                                            </td>
                                        </tbody>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="clearfix"></div>
                <hr />
            </asp:Panel>
            <asp:Panel ID="pnlFeedbackHeading" runat="server" Visible="false">
                <div class="col-lg-12">
                    <h4 class="panel-heading">Feedback Heading
                    </h4>
                </div>
                <div class="clearfix"></div>
                <hr />
                <div class="form-group col-lg-6">
                    <div class="col-lg-4 col-md-2 col-xs-12 col-sm-12" style="padding: 0;">
                        <label>Feedback Heading</label>
                    </div>
                    <div class="col-lg-8 col-md-4 col-xs-12 col-sm-12" style="padding: 0;">
                        <asp:TextBox ID="txtFeedbackHeading" runat="server" CssClass="form-control" ValidationGroup="GRPFeedMst" Style="width: 95%; float: right; margin-left: 4px;"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="ReqValtxtFeedbackHeading" runat="server" ControlToValidate="txtFeedbackHeading" Display="Dynamic" ErrorMessage="Enter Feedback Heading." ValidationGroup="GRPFeedMst"></asp:RequiredFieldValidator>
                        <asp:HiddenField ID="hfFeedbackMstID" runat="server" />
                    </div>
                </div>

                <div class="form-group col-lg-6">
                    <div class="col-lg-4 col-md-2 col-xs-12 col-sm-12" style="padding: 0;">
                        <label>Is Multiple Select</label>
                    </div>
                    <div class="col-lg-8 col-md-4 col-xs-12 col-sm-12" style="padding: 0;">
                        <asp:CheckBox ID="chkIsMultipSel" runat="server" />
                    </div>
                </div>
                <div class="form-group col-lg-6">
                    <div class="col-lg-4 col-md-2 col-xs-12 col-sm-12" style="padding: 0;">
                        <label>Is Requried</label>
                    </div>
                    <div class="col-lg-8 col-md-4 col-xs-12 col-sm-12" style="padding: 0;">
                        <asp:CheckBox ID="chkIsRequired" runat="server" />
                    </div>
                </div>
                <div class="clearfix"></div>
                <div class="form-group col-lg-12">
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <asp:LinkButton ID="btnNew" runat="server" Text="Add Feedback Heading" CssClass="btn btn-primary" OnClick="btnNew_Click" ValidationGroup="GRPFeedMst"></asp:LinkButton>
                        <asp:HiddenField ID="hfFeedbackHeading" runat="server" />
                    </div>
                </div>
                <div class="clearfix"></div>
                <div class="form-group col-lg-12">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Feedback Heading</th>
                                    <th class="col-lg-2">Is Multiple Selection</th>
                                    <th class="col-lg-2">Is Required</th>
                                    <th class="col-lg-2"></th>
                                </tr>
                            </thead>
                            <asp:Repeater ID="rptFeedbackHead" runat="server">
                                <ItemTemplate>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblFeedbackMstTag" runat="server" Text='<% #Eval("FeedbackMstTag")%>'></asp:Label>
                                                <asp:HiddenField ID="hfFeedbackHeadingID" runat="server" Value='<% #Eval("FeedbackMstID")%>' />
                                            </td>
                                            <td>
                                                <asp:Label ID="lblIsMultiple" runat="server" Text='<% # Convert.ToString(Eval("IsMultiple")) == "True" ? "Yes" : "No"%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="lblIsRequired" runat="server" Text='<% # Convert.ToString(Eval("IsRequired")) == "True" ? "Yes" : "No"%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="cmdEdit" CssClass="btn btn-primary" OnClick="btnEdit_Click" ValidationGroup="GRPFedH">
                                                    <span class="glyphicon glyphicon-pencil"></span>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="cmdDel" CssClass="btn btn-danger" OnClientClick="confirm('Are you sure want to remove record!');" OnClick="btnEdit_Click" ValidationGroup="GRPFedH">
                                                    <span class="glyphicon glyphicon-remove">
                                                    </span>
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </tbody>
                                </ItemTemplate>
                            </asp:Repeater>
                        </table>
                    </div>
                </div>
                <div class="clearfix"></div>
                <hr />
            </asp:Panel>
            <asp:Panel ID="pnlFeedbackOption" runat="server" Visible="false">
                <div class="col-lg-12">
                    <h4 class="panel-heading">Feedback Option
                    </h4>
                </div>
                <div class="clearfix"></div>
                <hr />
                <div class="form-group col-lg-12">
                    <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                        <label>
                            Feedback Heading
                        </label>
                    </div>
                    <div class="col-lg-4 col-md-4 col-xs-12 col-sm-12">
                        <asp:DropDownList ID="dpFeedbackHeading" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="dpFeedbackHeading_SelectedIndexChanged" ValidationGroup="GRPFedH"></asp:DropDownList>
                    </div>
                </div>
                <div class="clearfix"></div>
                <hr />
                <asp:Panel ID="pnlFeedbackOpMgt" runat="server" Visible="false">
                    <div class="form-group col-lg-12">
                        <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                            <label>
                                Feedback Option Tag
                            </label>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-12 col-sm-12">
                            <asp:TextBox ID="txtFeedbackOpTag" runat="server" CssClass="form-control" ValidationGroup="FOP_A"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="ReqValtxtFeedbackOpTag" runat="server" ControlToValidate="txtFeedbackOpTag" ErrorMessage="Enter Feedback Option Tag!" ForeColor="Red" ValidationGroup="FOP_A"></asp:RequiredFieldValidator>
                            <asp:HiddenField ID="hfFeedbackOpTag" runat="server" />
                        </div>
                        <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                            <label>
                                Is Text Value
                            </label>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-12 col-sm-12">
                            <asp:CheckBox ID="IsTextbox" runat="server" Checked="false" />
                        </div>
                    </div>
                    <div class="clearfix"></div>
                    <div class="form-group col-lg-12">
                        <div class="col-lg-2 col-md-2 col-xs-12 col-sm-12">
                            <asp:Button ID="btnAddFeedbackOp" runat="server" Text="Add Feeback Option" CssClass="btn btn-primary" OnClick="btnAddFeedbackOp_Click" ValidationGroup="FOP_A" />
                        </div>
                    </div>
                    <div class="clearfix"></div>
                    <br />
                </asp:Panel>
                <div class="form-group col-lg-12">
                    <div class="col-lg-12 col-md-12 col-xs-12 col-sm-12">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Sr. No.</th>
                                        <th>Feedback Name
                                        </th>
                                        <th>Feedback Heading
                                        </th>
                                        <th>Is Text Value
                                        </th>
                                        <td></td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptFeedbackOption0" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td class="col-lg-1">
                                                    <asp:Label ID="lblSrNo" runat="server" Text='<% #Container.ItemIndex + 1%>'>
                                                    </asp:Label>
                                                </td>
                                                <td class="col-lg-5">
                                                    <asp:Label ID="lblFeedbackOp" runat="server" Text='<% #Eval("FeedbackOpTag")%>'></asp:Label>
                                                    <asp:HiddenField ID="hfFeedbackOpID" runat="server" Value='<% #Eval("FeedbackOpID")%>'></asp:HiddenField>
                                                </td>
                                                <td class="col-lg-3">
                                                    <asp:Label ID="lblFeedbackHeading" runat="server" Text='<% #Eval("FeedbackMstTag")%>'></asp:Label>
                                                </td>
                                                <td class="col-lg-1">
                                                    <asp:Label ID="lblIsTextBox" runat="server" Text='<% # (Eval("FeedbackOthOpText")).ToString() == "False" ? "No" : "Yes"%>'></asp:Label>
                                                </td>
                                                <td class="col-lg-2">
                                                    <asp:LinkButton ID="lnkFOpEdit" runat="server" CommandName="cmdEdit" CssClass="btn btn-primary" OnClick="lnkFOpEdit_Click" ToolTip="Edit" ValidationGroup="VGRPFeedOp">
                                                        <span class="glyphicon glyphicon-pencil"></span>
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="lnkFOpDel" runat="server" CommandName="cmdDel" CssClass="btn btn-danger" OnClick="lnkFOpEdit_Click" ToolTip="Delete" OnClientClick="return confirm('Are you sure to delete this?');" ValidationGroup="VGRPFeedOp">
                                                        <span class="glyphicon glyphicon-remove">
                                                    </asp:LinkButton>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="clearfix"></div>
                <hr />
            </asp:Panel>
            <asp:Panel ID="pnlItemCategory" runat="server" CssClass="DialogView" Visible="false">
                <div class="ModalPanel ModalPanel-sm">
                    <asp:Literal ID="ltrICNotification" runat="server"> </asp:Literal>
                    <div class="ModalPanelHeader">
                        <h3>Item Category
                        </h3>
                    </div>
                    <div class="ModalPanelContent">
                        <div class="well">
                            <asp:CheckBoxList ID="lbItemCategory" runat="server">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                    <div class="ModalPanelFooter">
                        <asp:HiddenField ID="hfUserRow" runat="server" />
                        <asp:LinkButton ID="lnkUpdate" runat="server" Text="Update" CssClass="btn btn-success" OnClick="lnkUpdate_Click"></asp:LinkButton>
                        <asp:LinkButton ID="lnkClear" runat="server" Text="Clear" CssClass="btn btn-success" OnClick="lnkClear_Click"></asp:LinkButton>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
