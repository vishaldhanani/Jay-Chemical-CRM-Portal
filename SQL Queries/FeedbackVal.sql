USE [DB_CRMPortal]
GO

/****** Object:  Table [dbo].[FeedbackVal]    Script Date: 1/3/2017 7:10:05 PM ******/
DROP TABLE [dbo].[FeedbackVal]
GO

/****** Object:  Table [dbo].[FeedbackVal]    Script Date: 1/3/2017 7:10:05 PM ******/
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

