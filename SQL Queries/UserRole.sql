USE [DB_CRMPortal]
GO

/****** Object:  Table [dbo].[UserRole]    Script Date: 1/3/2017 7:10:21 PM ******/
DROP TABLE [dbo].[UserRole]
GO

/****** Object:  Table [dbo].[UserRole]    Script Date: 1/3/2017 7:10:21 PM ******/
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

