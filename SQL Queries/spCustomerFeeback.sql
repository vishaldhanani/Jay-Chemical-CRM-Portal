USE [DB_CRMPortal]
GO

/****** Object:  StoredProcedure [dbo].[spCustomerFeeback]    Script Date: 1/5/2017 12:01:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spCustomerFeeback]
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

