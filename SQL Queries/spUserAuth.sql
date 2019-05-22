USE [DB_CRMPortal]
GO

/****** Object:  StoredProcedure [dbo].[spUserAuth]    Script Date: 1/5/2017 12:01:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spUserAuth]
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

