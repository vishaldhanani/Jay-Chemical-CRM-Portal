USE [DB_CRMPortal]
GO

/****** Object:  Table [dbo].[UserAuth]    Script Date: 1/3/2017 7:10:14 PM ******/
DROP TABLE [dbo].[UserAuth]
GO

/****** Object:  Table [dbo].[UserAuth]    Script Date: 1/3/2017 7:10:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[UserAuth](
	[timestap] [timestamp] NOT NULL,
	[UsrID] [varchar](55) NOT NULL,
	[UsrPwd] [varchar](32) NOT NULL,
	[ExecuteID] [nvarchar](50) NOT NULL,
	[UsrRollID] [bigint] NOT NULL,
	[Item Category Code] [nvarchar](10) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_UserAuth_IsActive]  DEFAULT ((1)),
 CONSTRAINT [PK_UserAuth] PRIMARY KEY CLUSTERED 
(
	[UsrID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_UserAuth] UNIQUE NONCLUSTERED 
(
	[timestap] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

