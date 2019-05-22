USE [DB_CRMPortal]
GO

/****** Object:  StoredProcedure [dbo].[spAgentList]    Script Date: 1/3/2017 7:08:41 PM ******/
DROP PROCEDURE [dbo].[spAgentList]
GO

/****** Object:  StoredProcedure [dbo].[spAgentList]    Script Date: 1/3/2017 7:08:41 PM ******/
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

