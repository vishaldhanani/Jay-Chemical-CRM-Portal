USE [DB_CRMPortal]
GO

/****** Object:  Table [dbo].[FeedbackFrm]    Script Date: 1/3/2017 7:09:45 PM ******/
DROP TABLE [dbo].[FeedbackFrm]
GO

/****** Object:  Table [dbo].[FeedbackFrm]    Script Date: 1/3/2017 7:09:45 PM ******/
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

