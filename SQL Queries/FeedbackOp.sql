USE [DB_CRMPortal]
GO

/****** Object:  Table [dbo].[FeedbackOp]    Script Date: 1/3/2017 7:09:59 PM ******/
DROP TABLE [dbo].[FeedbackOp]
GO

/****** Object:  Table [dbo].[FeedbackOp]    Script Date: 1/3/2017 7:09:59 PM ******/
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

