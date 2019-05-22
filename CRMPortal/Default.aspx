<%@ Page Title="" Language="C#" MasterPageFile="~/mstBlank.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CRMPortal.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="mstBlankHead" runat="server">
    <style>
        

        label {
            color: #fff;
            font-weight: 700;
        }

        input {
            background: none !important;
        }

        .btn {
            background: #fff !important;
            color: #188;
            border: none;
            height: 39px;
            width: 100%;
            font-weight: 700;
            text-transform: uppercase;
        }

        .btn-primary:hover {
            color: #188;
        }

        .form-control {
            height: 40px;
            border-color: rgba(255,255,255,0.3);
        }

        .panel-title {
            margin-top: 0;
            margin-bottom: 0;
            font-size: 18px;
            color: white;
            text-align: center;
            text-transform: uppercase;
        }

        .col-lg-offset-4 {
            margin-left: 30.333333%;
        }

        @media (max-width: 768px) {
            .panel-title {
                color: #fff !important;
            }
            /*.btn-primary:hover {
            background:#188 !important;
            color:#fff !important;
            }
           .btn-primary {
            background:#188 !important;
            color:#fff !important;
            }*/
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="mstBlankBody" runat="server">
    <div style="height: 25vh;"></div>
    <div class="container">
        <div class="clearfix">
        </div>
        <br />
        <asp:Literal ID="ltrNotificationArea" runat="server"></asp:Literal>
        <div class="login-fields">
            <div class="field">
                <div style="margin: 0 auto;">
                    <div class="col-lg-5" style="margin: 0 auto; float: none;">
                        <div class="panel panel-purple">
                            <div class="l_part_wrap">
                                <div class="logo">
                                    <center> <img src="Images/logo.png" alt="Jay Chemicals"> </center>
                                </div>
                            </div>
                        </div>

                        <div class="panel-body">

                            <div class="form-group col-lg-12">
                                <div>
                                    <label>User ID</label>
                                </div>
                                <div>
                                    <asp:TextBox ID="txtUsrID" runat="server" CssClass="form-control" ForeColor="White"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-group col-lg-12">
                                <div>
                                    <label>Password</label>
                                </div>
                                <div>
                                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" ForeColor="White" TextMode="Password"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-group col-lg-12">
                                <div>
                                    <asp:Button ID="btnLogin" runat="server" CssClass="btn btn-primary btn-md" Text="Login" OnClick="btnLogin_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>

</asp:Content>
