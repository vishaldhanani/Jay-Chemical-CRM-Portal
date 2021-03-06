USE [DB_CRMPortal]
GO
/****** Object:  StoredProcedure [dbo].[spAgentList]    Script Date: 1/5/2017 3:54:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAgentList]
	(
		@Flag nvarchar(350) = NULL
		,@SalesPersCd nvarchar(50) = NULL
		,@ItemCategoryCode nvarchar(10) =NULL
		,@Agentcode nvarchar(255) = NULL
		,@CustomerID int = NULL
		,@OutputPara nvarchar(max) = NULL OUTPUT
	)
AS
BEGIN
	IF(@Flag = 'ReadAgent')
	BEGIN		
		Select 
			AC.[Agent Code]
			, A.[Agent Name]
						
			FROM [TEST_JAY2013R2].[dbo].[JAY$Agent Customers] AS AC

			INNER JOIN [TEST_JAY2013R2].[dbo].[JAY$Cust_ Relation with A_S_Person] AS RASP
			ON RASP.[Customer No_] = AC.[Linked Customer No_] AND RASP.Level BETWEEN 3 AND 5

			INNER JOIN [TEST_JAY2013R2].[dbo].[JAY$Agent] AS A
			ON A.Code = AC.[Agent Code]

			INNER JOIN InternalDB.[dBO].[Customer Registration] AS CR
			ON AC.[Agent Code] collate Latin1_General_CI_AI  = CR.AgentCode
			
			WHERE RASP.Code = @SalesPersCd AND RASP.[Item Category Code] = @ItemCategoryCode

			GROUP BY AC.[Agent Code], A.[Agent Name]
	END
	ELSE IF(@Flag = 'ReadClient')
	BEGIN
		Select 
		DISTINCT
				AC.[Linked Customer No_]						
				FROM [TEST_JAY2013R2].[dbo].[JAY$Agent Customers] AS AC

				INNER JOIN [TEST_JAY2013R2].[dbo].[JAY$Cust_ Relation with A_S_Person] AS RASP
				ON RASP.[Customer No_] = AC.[Linked Customer No_] AND (RASP.Level BETWEEN 3 AND 5) AND (RASP.[Item Category Code] = @ItemCategoryCode)

				INNER JOIN [TEST_JAY2013R2].[dbo].[JAY$Agent] AS A
				ON A.Code = AC.[Agent Code]

				INNER JOIN InternalDB.[dBO].[Customer Registration] AS CR
				ON AC.[Agent Code] collate Latin1_General_CI_AI  = CR.AgentCode
			
				WHERE (RASP.Code = @SalesPersCd) AND (AC.[Agent Code] = @Agentcode)			
	END
	ELSE IF (@Flag = 'ReadSubClient')
	BEGIN
			SELECT
			CR.CustomerID, CR.CustomerName
			FROM [TEST_JAY2013R2].[dbo].[JAY$Agent Customers] AS AC

			INNER JOIN [TEST_JAY2013R2].[dbo].[JAY$Cust_ Relation with A_S_Person] AS RASP
			ON RASP.[Customer No_] = AC.[Linked Customer No_] AND (RASP.Level BETWEEN 3 AND 5) AND (RASP.[Item Category Code] = @ItemCategoryCode)

			INNER JOIN [TEST_JAY2013R2].[dbo].[JAY$Agent] AS A
			ON A.Code = AC.[Agent Code]

			INNER JOIN InternalDB.[dBO].[Customer Registration] AS CR
			ON AC.[Agent Code] collate Latin1_General_CI_AI  = CR.AgentCode
			
			WHERE RASP.Code = @SalesPersCd  AND (AC.[Agent Code] = @Agentcode)			
			GROUP BY CR.CustomerID, CR.CustomerName, CR.Address + ', '+ CR.[Address 2] + ', ' + CR.City , CR.[Contact Per. Tech. Mobile]
	END
	ELSE IF (@Flag = 'ReadSubClientDetails')
	BEGIN
			SELECT
			CustomerID, CustomerName, Address + ', ' + [Address 2]+ ', '+ City + '- ' + [Pin Code] +'('+  State +')' AS FullAddress, [Land Line]
			,
			[Contact Person Name (Technical)], [Contact Per. Tech. Mobile], [Contact Per. Tech. Email]
				,
			[Contact Person Name (Owner)], [Contact Per. Owner Mobile], [Contact Per. Owner Email]
			FROM            InternalDB.dbo.[Customer Registration]
			
			WHERE (CustomerID = @CustomerID)
	END
	ELSE IF(@Flag = 'ReadItemCategoryCode')
	BEGIN
		Select 
		distinct
		RASP.[Item Category Code]

		FROM [TEST_JAY2013R2].[dbo].[JAY$Agent Customers] AS AC

		INNER JOIN [TEST_JAY2013R2].[dbo].[JAY$Cust_ Relation with A_S_Person] AS RASP
		ON RASP.[Customer No_] = AC.[Linked Customer No_] AND RASP.Level BETWEEN 3 AND 5

		INNER JOIN [TEST_JAY2013R2].[dbo].[JAY$Agent] AS A
		ON A.Code = AC.[Agent Code]

		WHERE RASP.Code = 'DBALA' 
	END

END


GO
/****** Object:  StoredProcedure [dbo].[spCustomerFeeback]    Script Date: 1/5/2017 3:54:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCustomerFeeback]
	(
		@Flag				nvarchar(255)	=NULL
		,@FeedbackFrmID		bigint			=NULL
		,@FeedbackDt		datetime		=NULL
		,@ItemCat			nvarchar(50)	=NULL
		,@CustomerID		int				=NULL
		,@OwName			nvarchar(255)	=NULL
		,@OwDesig			nvarchar(255)	=NULL
		,@OwContact			nvarchar(11)	=NULL
		,@OwEmail			nvarchar(255)	=NULL
		,@TechName			nvarchar(255)	=NULL
		,@TechDesg			nvarchar(255)	=NULL
		,@TechContact		nvarchar(11)	=NULL
		,@TechEmail			nvarchar(255)	=NULL

		--Feedback Values 
		,@FeedbackValID		bigint			=NULL				
		,@FeedbackOpID		bigint			=NULL
		,@FeedbackOpText	nvarchar(MAX)	=NULL
		--_______________________________________________
		,@OutputPara		nvarchar(max)	=NULL OUTPUT
	)	
AS
BEGIN
	IF(@Flag = 'CreateCustomerFeedback')
	BEGIN
		INSERT INTO	FeedbackFrm
                    (FeedbackDt, ItemCat, CustomerID, OwName, OwDesig, OwContact, OwEmail, TechName, TechDesg, TechContact, TechEmail, IsActive)
		VALUES      (@FeedbackDt,@ItemCat,@CustomerID,@OwName,@OwDesig,@OwContact,@OwEmail,@TechName,@TechDesg,@TechContact,@TechEmail, 1)		
		SET @OutputPara = CONVERT(varchar(max), SCOPE_IDENTITY())
	END
	ELSE IF(@Flag = 'CreateCustomerFeedbackVal')
	BEGIN
		INSERT INTO FeedbackVal        
					(FeedbackFrmID, FeedbackOpID, FeedbackOpText)
		VALUES      (@FeedbackFrmID,@FeedbackOpID,@FeedbackOpText)
	END
	IF(@Flag = 'ViewCustomerFeedback')
	BEGIN
		SELECT			FF.FeedbackFrmID, FF.FeedbackDt, FF.ItemCat, CR.CustomerName, FF.OwName, FF.OwContact, FF.OwEmail, FF.TechName, FF.TechContact, FF.TechEmail
		FROM            FeedbackFrm AS FF 
		INNER JOIN		InternalDB.dbo.[Customer Registration] AS CR ON CR.CustomerID = FF.CustomerID AND FF.CustomerID = @CustomerID
		WHERE			(FF.IsActive = 1)		
	END
	ELSE IF(@Flag = 'ViewCustomerFeedbackVal')
	BEGIN
		SELECT			FM.FeedbackMstTag, FO.FeedbackOpTag, FV.FeedbackOpText
		FROM            FeedbackVal AS FV 
		INNER JOIN		FeedbackOp AS FO ON FO.FeedbackOpID = FV.FeedbackOpID
		INNER JOIN		FeedbackMst AS FM ON FM.FeedbackMstID = FO.FeedbackMstID
		WHERE			(FV.FeedbackFrmID = @FeedbackFrmID)
	END
END


GO
/****** Object:  StoredProcedure [dbo].[spFeedbackManage]    Script Date: 1/5/2017 3:54:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFeedbackManage]
	(
		@Flag				nvarchar(255)	= NULL
		,@FeedbackMstID		bigint			= NULL		
		,@FeedbackMstTag	varchar(255)	= NULL
		,@IsMultiple		bit				= NULL

		,@FeedbackOpID		bigint			= NULL
		,@FeedbackOpTag		varchar(255)	= NULL
		,@FeedbackOthOpText	bit				= NULL
		,@OutputPara		nvarchar(max)	= NULL OUTPUT
	)
AS
BEGIN	
	IF(@Flag = 'ReadFeedbackMaster')
	BEGIN
		SELECT			FeedbackMstID, FeedbackMstTag, IsMultiple
		FROM			FeedbackMst
		WHERE			(IsActive = 1)
	END	
	ELSE IF(@Flag = 'CreateFeedbackMaster')
	BEGIN
		INSERT INTO	FeedbackMst
					(FeedbackMstTag, IsMultiple)
		VALUES      (@FeedbackMstTag,@IsMultiple)
	END	
	ELSE IF(@Flag = 'UpdateFeedbackMaster')
	BEGIN
		UPDATE      FeedbackMst
		SET         FeedbackMstTag = @FeedbackMstTag, IsMultiple = @IsMultiple
		WHERE       (FeedbackMstID = @FeedbackMstID)
	END	
	ELSE IF(@Flag = 'DeleteFeedbackMaster')
	BEGIN
		UPDATE      FeedbackMst
		SET			IsActive = 0
		WHERE        (FeedbackMstID = @FeedbackMstID)
	END
	ELSE IF(@Flag = 'CreateFeedbackOption')
	BEGIN
		INSERT INTO FeedbackOp
                    (FeedbackOpTag, FeedbackMstID, FeedbackOthOpText)
		VALUES      (@FeedbackOpTag,@FeedbackMstID,@FeedbackOthOpText)
	END	
	ELSE IF(@Flag = 'UpdateFeedbackOption')
	BEGIN
		UPDATE      FeedbackOp
		SET			FeedbackOpTag = @FeedbackOpTag, FeedbackMstID = @FeedbackMstID, FeedbackOthOpText = @FeedbackOthOpText
		WHERE       (FeedbackOpID = @FeedbackOpID)
	END	
	ELSE IF(@Flag = 'DeleteFeedbackOption')
	BEGIN
		UPDATE      FeedbackOp
		SET			IsActive = 0
		WHERE       (FeedbackOpID = @FeedbackOpID)
	END	
	ELSE IF(@Flag = 'ReadFeedbackOption')
	BEGIN
		SELECT		FO.FeedbackOpID
					, FO.FeedbackOpTag
					, FM.FeedbackMstTag
					, FO.FeedbackOthOpText										
		FROM        FeedbackOp AS FO 
		INNER JOIN	FeedbackMst AS FM 
		ON			FO.FeedbackMstID = FM.FeedbackMstID AND FM.IsActive = 1 AND FM.FeedbackMstID = @FeedbackMstID
		WHERE	    (FO.IsActive = 1) AND ((@FeedbackOpID IS NULL) OR (@FeedbackOpID = '') OR (FO.FeedbackOpID = @FeedbackOpID))
	END	
END


GO
/****** Object:  StoredProcedure [dbo].[spUserAuth]    Script Date: 1/5/2017 3:54:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUserAuth]
	(
		@Flag				nvarchar(350)	=NULL
		,@UsrID				varchar(55)		=NULL
		,@UsrPwd			varchar(32)		=NULL
		,@UsrRollID			bigint			=NULL
		,@ExecuteID			nvarchar(50)	=NULL
		,@ItemCategoryCode	nvarchar(10)	=NULL
		,@IsActive			bit				=NULL
		,@OutputPara		nvarchar(max)	=NULL OUTPUT
	)
AS
BEGIN
	IF(@Flag = 'UserList')
		BEGIN
		SELECT      UA.UsrID, UA.UsrPwd, UA.ExecuteID, 
		CASE
		WHEN  MASP.Name IS NULL THEN
			UA.UsrID
		ELSE
			MASP.Name
		END
		AS Name
		, UR.UsrRollID, UR.UsrRollName, UA.[Item Category Code]
			FROM        UserAuth AS UA
			LEFT JOIN	[TEST_JAY2013R2].[dbo].[JAY$Target Master Of A_S_Person] AS MASP 			
			ON			MASP.Code collate Latin1_General_CI_AI =  UA.ExecuteID AND MASP.Level BETWEEN 3 AND 5
			INNER JOIN	UserRole AS UR
			ON			UR.UsrRollID = UA.UsrRollID AND UA.IsActive = 1 					
			WHERE		(UA.UsrID = @UsrID) AND (UA.UsrPwd = @UsrPwd)
			GROUP BY	UA.UsrID, UA.UsrPwd, UA.ExecuteID, Name, UR.UsrRollID, UR.UsrRollName, UA.[Item Category Code]			
		END
	ELSE IF(@Flag = 'SPListNotUsrCrated')
		BEGIN
			SELECT		MASP.Code collate Latin1_General_CI_AI AS Code , MASP.Name collate Latin1_General_CI_AI AS Name
			FROM		[TEST_JAY2013R2].[dbo].[JAY$Target Master Of A_S_Person] AS MASP
			WHERE		MASP.Code collate Latin1_General_CI_AI NOT IN (SELECT UA.ExecuteID FROM UserAuth AS UA) 
			GROUP BY	MASP.Code, MASP.Name
			ORDER BY	MASP.Name
			
		END
	ELSE IF(@Flag = 'ReadItemCategory')
		BEGIN
			SELECT   [Item Category Code] AS ItemCategoryCode
			FROM     TEST_JAY2013R2.dbo.[JAY$Target Master Of A_S_Person] AS MASP
			WHERE    (MASP.Code = @ExecuteID)
			ORDER BY [Item Category Code]
		END
	ELSE IF(@Flag = 'getUsrRoll')
		BEGIN
			SELECT      IsConfigAuth, IsFeedbackForm
			FROM        UserRole AS UR
			WHERE       (IsActive = 1) AND (UsrRollID = @UsrRollID)
		END	
	ELSE IF(@Flag = 'CreateUser')
		BEGIN
			IF((SELECT COUNT(UA.UsrID) FROM UserAuth AS UA Where (UA.UsrID = @UsrID)) = 0)
			BEGIN
				INSERT INTO 
							UserAuth
					        (UsrID, UsrPwd, UsrRollID, ExecuteID, [Item Category Code])
				VALUES      (@UsrID,@UsrPwd,@UsrRollID,@ExecuteID,@ItemCategoryCode)
				SET @OutputPara = 'New User Created.'
			END
			ELSE
			BEGIN
				SET @OutputPara = 'This User already created. Enter Unique User ID.'
			END
		END
	ELSE IF(@Flag = 'UdateUserStatus')
		BEGIN
			UPDATE      UserAuth
			SET         IsActive = @IsActive
			WHERE       (UsrID = @UsrID)
		END	
	ELSE IF(@Flag = 'ReadAll')
		BEGIN		
			SELECT      UA.UsrID, UA.UsrPwd, UA.ExecuteID, 
			CASE
			WHEN  MASP.Name IS NULL THEN
				UA.UsrID
			ELSE
				MASP.Name
			END
			AS Name
			, UR.UsrRollID, UR.UsrRollName, UA.[Item Category Code], UA.IsActive
				FROM        UserAuth AS UA
				LEFT JOIN	[TEST_JAY2013R2].[dbo].[JAY$Target Master Of A_S_Person] AS MASP 			
				ON			MASP.Code collate Latin1_General_CI_AI =  UA.ExecuteID AND MASP.Level BETWEEN 3 AND 5
				INNER JOIN	UserRole AS UR
				ON			UR.UsrRollID = UA.UsrRollID AND UA.IsActive = 1 					
				Where ((@UsrID IS NULL) OR (@UsrID = '') OR (UA.UsrID = @UsrID))
				GROUP BY	UA.UsrID, UA.UsrPwd, UA.ExecuteID, Name, UR.UsrRollID, UR.UsrRollName, UA.[Item Category Code], UA.IsActive
		END	
	ELSE IF(@Flag = 'getUserCount')
		BEGIN		
			 SET @OutputPara = (SELECT COUNT(UA.UsrID) FROM UserAuth AS UA Where (UA.UsrID = @UsrID))
		END
END


GO
/****** Object:  StoredProcedure [dbo].[spUserRole]    Script Date: 1/5/2017 3:54:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SUNNY FICHADIYA
-- Create date: 3rd January 2017
-- Description:	for Manager User Roll
-- =============================================
CREATE PROCEDURE [dbo].[spUserRole]
	(
		@Flag nvarchar(350) = NULL		
		,@UsrRollID bigint = NULL
		,@UsrRollName varchar(50) = NULL
		,@IsConfigAuth bit = NULL
		,@IsFeedbackForm bit = NULL
		,@IsRollMst bit = NULL		
		,@OutputPara nvarchar(max) = NULL Output
	)
AS
BEGIN
	IF(@Flag = 'ReadAll')
		BEGIN			
			SELECT		UsrRollID
						, UsrRollName
						, IsConfigAuth
						, IsFeedbackForm
						, IsRollMst
			FROM        UserRole
			WHERE       (IsActive = 1)
		END
	ELSE IF(@Flag = 'Create')
		BEGIN			
			INSERT INTO UserRole
                         (UsrRollName)
			VALUES        (@UsrRollName)
		END
	ELSE IF(@Flag = 'Update')
		BEGIN			
			UPDATE		UserRole
			SET         UsrRollName = @UsrRollName
			WHERE       (UsrRollID = @UsrRollID)
		END
	ELSE IF(@Flag = 'UpdateIsFeedback')
		BEGIN			
			UPDATE		UserRole
			SET         IsFeedbackForm = @IsFeedbackForm
			WHERE       (UsrRollID = @UsrRollID)
		END
	ELSE IF(@Flag = 'UpdateIsConfigAuth')
		BEGIN			
			UPDATE		UserRole
			SET         IsConfigAuth = @IsConfigAuth
			WHERE       (UsrRollID = @UsrRollID)
		END
END

GO
/****** Object:  Table [dbo].[FeedbackFrm]    Script Date: 1/5/2017 3:54:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FeedbackFrm](
	[RowIdent] [timestamp] NOT NULL,
	[FeedbackFrmID] [bigint] IDENTITY(1,1) NOT NULL,
	[FeedbackDt] [datetime] NOT NULL,
	[ItemCat] [nvarchar](50) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[OwName] [nvarchar](255) NOT NULL,
	[OwDesig] [nvarchar](255) NOT NULL,
	[OwContact] [nvarchar](11) NOT NULL,
	[OwEmail] [nvarchar](255) NOT NULL,
	[TechName] [nvarchar](255) NOT NULL,
	[TechDesg] [nvarchar](255) NOT NULL,
	[TechContact] [nvarchar](11) NOT NULL,
	[TechEmail] [nvarchar](255) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_FeedbackFrm_IsActive]  DEFAULT ((1)),
 CONSTRAINT [PK_FeedbackFrm] PRIMARY KEY CLUSTERED 
(
	[FeedbackFrmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FeedbackMst]    Script Date: 1/5/2017 3:54:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FeedbackMst](
	[timestramp] [timestamp] NOT NULL,
	[FeedbackMstID] [bigint] IDENTITY(1,1) NOT NULL,
	[FeedbackMstTag] [varchar](255) NOT NULL,
	[IsMultiple] [bit] NOT NULL CONSTRAINT [DF_FeedbackMst_IsMultiple]  DEFAULT ((0)),
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_FeedbackMst_IsActive]  DEFAULT ((1)),
 CONSTRAINT [PK_FeedbackMst] PRIMARY KEY CLUSTERED 
(
	[FeedbackMstID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FeedbackOp]    Script Date: 1/5/2017 3:54:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FeedbackOp](
	[timestramp] [timestamp] NOT NULL,
	[FeedbackOpID] [bigint] IDENTITY(1,1) NOT NULL,
	[FeedbackOpTag] [varchar](255) NOT NULL,
	[FeedbackMstID] [bigint] NOT NULL,
	[FeedbackOthOpText] [bit] NOT NULL CONSTRAINT [DF_FeedbackOp_FeedbackOthOpText]  DEFAULT ((0)),
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_FeedbackOp_IsActive]  DEFAULT ((1)),
 CONSTRAINT [PK_FeedbackOp] PRIMARY KEY CLUSTERED 
(
	[FeedbackOpID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FeedbackVal]    Script Date: 1/5/2017 3:54:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FeedbackVal](
	[RowIndentity] [timestamp] NOT NULL,
	[FeedbackValID] [bigint] IDENTITY(1,1) NOT NULL,
	[FeedbackFrmID] [bigint] NOT NULL,
	[FeedbackOpID] [bigint] NOT NULL,
	[FeedbackOpText] [nvarchar](max) NULL,
 CONSTRAINT [PK_FeedbackVal] PRIMARY KEY CLUSTERED 
(
	[FeedbackValID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserAuth]    Script Date: 1/5/2017 3:54:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserAuth](
	[timestap] [timestamp] NOT NULL,
	[UsrID] [varchar](55) NOT NULL,
	[UsrPwd] [varchar](32) NOT NULL,
	[ExecuteID] [nvarchar](50),
	[UsrRollID] [bigint] NOT NULL,
	[Item Category Code] [nvarchar](10),
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_UserAuth_IsActive]  DEFAULT ((1)),
 CONSTRAINT [PK_UserAuth] PRIMARY KEY CLUSTERED 
(
	[UsrID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 1/5/2017 3:54:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserRole](
	[RowIndentity] [timestamp] NOT NULL,
	[UsrRollID] [bigint] IDENTITY(1,1) NOT NULL,
	[UsrRollName] [varchar](50) NOT NULL,
	[IsConfigAuth] [bit] NOT NULL CONSTRAINT [DF_UserRole_IsConfigAuth]  DEFAULT ((0)),
	[IsFeedbackForm] [bit] NOT NULL CONSTRAINT [DF_UserRole_IsFeedbackMstCard]  DEFAULT ((0)),
	[IsRollMst] [bit] NOT NULL CONSTRAINT [DF_UserRole_IsRollMst]  DEFAULT ((0)),
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_UserRole_IsActive]  DEFAULT ((1)),
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[UsrRollID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[FeedbackFrm] ON 

INSERT [dbo].[FeedbackFrm] ([FeedbackFrmID], [FeedbackDt], [ItemCat], [CustomerID], [OwName], [OwDesig], [OwContact], [OwEmail], [TechName], [TechDesg], [TechContact], [TechEmail], [IsActive]) VALUES (1, CAST(N'2017-01-03 00:00:00.000' AS DateTime), N'DYES', 3, N'Test Owner Name', N'Test Owner Desg', N'12345678901', N'Test Owner Email ID', N'Test Tech Name', N'Test Tech  Desg', N'12345678902', N'Test Tech Email', 1)
INSERT [dbo].[FeedbackFrm] ([FeedbackFrmID], [FeedbackDt], [ItemCat], [CustomerID], [OwName], [OwDesig], [OwContact], [OwEmail], [TechName], [TechDesg], [TechContact], [TechEmail], [IsActive]) VALUES (2, CAST(N'2017-01-05 00:00:00.000' AS DateTime), N'DYES', 3, N'Test Owner Name', N'Test Owner Desg', N'12345678901', N'Test Owner Email ID', N'Test Tech Name', N'Test Tech  Desg', N'12345678902', N'Test Tech Email', 1)
SET IDENTITY_INSERT [dbo].[FeedbackFrm] OFF
SET IDENTITY_INSERT [dbo].[FeedbackMst] ON 

INSERT [dbo].[FeedbackMst] ([FeedbackMstID], [FeedbackMstTag], [IsMultiple], [IsActive]) VALUES (1, N'Agenda for visit', 1, 1)
INSERT [dbo].[FeedbackMst] ([FeedbackMstID], [FeedbackMstTag], [IsMultiple], [IsActive]) VALUES (2, N'Purpose', 0, 1)
INSERT [dbo].[FeedbackMst] ([FeedbackMstID], [FeedbackMstTag], [IsMultiple], [IsActive]) VALUES (3, N'Mutally agreed Application area for business', 1, 1)
INSERT [dbo].[FeedbackMst] ([FeedbackMstID], [FeedbackMstTag], [IsMultiple], [IsActive]) VALUES (4, N'Decided business volume to be achiceved (Qty)', 1, 1)
INSERT [dbo].[FeedbackMst] ([FeedbackMstID], [FeedbackMstTag], [IsMultiple], [IsActive]) VALUES (5, N'Deadline', 0, 1)
INSERT [dbo].[FeedbackMst] ([FeedbackMstID], [FeedbackMstTag], [IsMultiple], [IsActive]) VALUES (6, N'Action plan to achieve deadline', 0, 1)
INSERT [dbo].[FeedbackMst] ([FeedbackMstID], [FeedbackMstTag], [IsMultiple], [IsActive]) VALUES (7, N'Test2', 1, 0)
SET IDENTITY_INSERT [dbo].[FeedbackMst] OFF
SET IDENTITY_INSERT [dbo].[FeedbackOp] ON 

INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (1, N'Dyes', 1, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (2, N'Textile Auxiliaries', 1, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (3, N'New Business', 2, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (4, N'Expanding Existing Business', 2, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (5, N'Dyeing', 3, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (6, N'Printing', 3, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (7, N'Continuous', 3, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (8, N'Pre-treatment', 3, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (9, N'Finishing', 3, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (10, N'Dye Bath', 3, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (11, N'Others, if any', 3, 1, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (12, N'Quantity', 4, 1, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (13, N'30 Days', 5, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (14, N'60 Days', 5, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (15, N'90 Days', 5, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (16, N'Trail', 6, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (17, N'Shade Matching', 6, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (18, N'Sampling', 6, 0, 1)
INSERT [dbo].[FeedbackOp] ([FeedbackOpID], [FeedbackOpTag], [FeedbackMstID], [FeedbackOthOpText], [IsActive]) VALUES (19, N'Others, if any', 6, 1, 1)
SET IDENTITY_INSERT [dbo].[FeedbackOp] OFF
SET IDENTITY_INSERT [dbo].[FeedbackVal] ON 

INSERT [dbo].[FeedbackVal] ([FeedbackValID], [FeedbackFrmID], [FeedbackOpID], [FeedbackOpText]) VALUES (1, 1, 1, NULL)
INSERT [dbo].[FeedbackVal] ([FeedbackValID], [FeedbackFrmID], [FeedbackOpID], [FeedbackOpText]) VALUES (2, 1, 3, NULL)
INSERT [dbo].[FeedbackVal] ([FeedbackValID], [FeedbackFrmID], [FeedbackOpID], [FeedbackOpText]) VALUES (3, 1, 5, NULL)
INSERT [dbo].[FeedbackVal] ([FeedbackValID], [FeedbackFrmID], [FeedbackOpID], [FeedbackOpText]) VALUES (4, 1, 12, N'10')
INSERT [dbo].[FeedbackVal] ([FeedbackValID], [FeedbackFrmID], [FeedbackOpID], [FeedbackOpText]) VALUES (5, 1, 13, NULL)
INSERT [dbo].[FeedbackVal] ([FeedbackValID], [FeedbackFrmID], [FeedbackOpID], [FeedbackOpText]) VALUES (6, 1, 16, NULL)
INSERT [dbo].[FeedbackVal] ([FeedbackValID], [FeedbackFrmID], [FeedbackOpID], [FeedbackOpText]) VALUES (7, 2, 1, NULL)
INSERT [dbo].[FeedbackVal] ([FeedbackValID], [FeedbackFrmID], [FeedbackOpID], [FeedbackOpText]) VALUES (8, 2, 4, NULL)
INSERT [dbo].[FeedbackVal] ([FeedbackValID], [FeedbackFrmID], [FeedbackOpID], [FeedbackOpText]) VALUES (9, 2, 5, NULL)
INSERT [dbo].[FeedbackVal] ([FeedbackValID], [FeedbackFrmID], [FeedbackOpID], [FeedbackOpText]) VALUES (10, 2, 11, N'TEST OTHER')
INSERT [dbo].[FeedbackVal] ([FeedbackValID], [FeedbackFrmID], [FeedbackOpID], [FeedbackOpText]) VALUES (11, 2, 12, N'20')
INSERT [dbo].[FeedbackVal] ([FeedbackValID], [FeedbackFrmID], [FeedbackOpID], [FeedbackOpText]) VALUES (12, 2, 14, NULL)
INSERT [dbo].[FeedbackVal] ([FeedbackValID], [FeedbackFrmID], [FeedbackOpID], [FeedbackOpText]) VALUES (13, 2, 17, NULL)
SET IDENTITY_INSERT [dbo].[FeedbackVal] OFF

INSERT [dbo].[UserAuth] ([UsrID], [UsrPwd], [ExecuteID], [UsrRollID], [Item Category Code], [IsActive]) VALUES (N'ADMIN', N'dL53kVPekSnY4MhZAC9HIw==', N'ADMIN', 2, N'ADMIN', 1)
INSERT [dbo].[UserAuth] ([UsrID], [UsrPwd], [ExecuteID], [UsrRollID], [Item Category Code], [IsActive]) VALUES (N'DBALA', N'3xEGakhJfSvd4WMBo0ZxQg==', N'DBALA', 1, N'DYES', 1)
SET IDENTITY_INSERT [dbo].[UserRole] ON 

INSERT [dbo].[UserRole] ([UsrRollID], [UsrRollName], [IsConfigAuth], [IsFeedbackForm], [IsRollMst], [IsActive]) VALUES (1, N'SalesPerson', 0, 1, 0, 1)
INSERT [dbo].[UserRole] ([UsrRollID], [UsrRollName], [IsConfigAuth], [IsFeedbackForm], [IsRollMst], [IsActive]) VALUES (2, N'Administrator', 1, 0, 1, 1)
SET IDENTITY_INSERT [dbo].[UserRole] OFF
/****** Object:  Index [IX_UserAuth]    Script Date: 1/5/2017 3:54:58 PM ******/
ALTER TABLE [dbo].[UserAuth] ADD  CONSTRAINT [IX_UserAuth] UNIQUE NONCLUSTERED 
(
	[timestap] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
