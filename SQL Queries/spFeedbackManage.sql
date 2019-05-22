USE [DB_CRMPortal]
GO

/****** Object:  StoredProcedure [dbo].[spFeedbackManage]    Script Date: 1/5/2017 12:01:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spFeedbackManage]
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

