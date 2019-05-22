USE [DB_CRMPortal]
GO

/****** Object:  Table [dbo].[FeedbackMst]    Script Date: 1/3/2017 7:09:52 PM ******/
DROP TABLE [dbo].[FeedbackMst]
GO

/****** Object:  Table [dbo].[FeedbackMst]    Script Date: 1/3/2017 7:09:52 PM ******/
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

