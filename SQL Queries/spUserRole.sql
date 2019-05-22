USE [DB_CRMPortal]
GO

/****** Object:  StoredProcedure [dbo].[spUserRole]    Script Date: 1/5/2017 12:01:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		SUNNY FICHADIYA
-- Create date: 3rd January 2017
-- Description:	for Manager User Roll
-- =============================================
ALTER PROCEDURE [dbo].[spUserRole]
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

