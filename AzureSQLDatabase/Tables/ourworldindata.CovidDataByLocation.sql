/****** Object:  Table [ourworldindata].[CovidDataByLocation]    Script Date: 4/6/2021 10:21:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ourworldindata].[CovidDataByLocation](
	[CovidDataByLocationID] [int] IDENTITY(1,1) NOT NULL,
	[Location] [varchar](50) NULL,
	[SumNewCases] [bigint] NULL,
	[RankNewCases] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUTCDate] [datetime] NOT NULL,
	[CreatedByUser] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_CovidDataByLocation] PRIMARY KEY CLUSTERED 
(
	[CovidDataByLocationID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_CovidDataByLocation_Location]    Script Date: 4/6/2021 10:21:27 AM ******/
CREATE NONCLUSTERED INDEX [IX_CovidDataByLocation_Location] ON [ourworldindata].[CovidDataByLocation]
(
	[Location] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

ALTER TABLE [ourworldindata].[CovidDataByLocation] ADD  CONSTRAINT [DF_CovidDataByLocation_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [ourworldindata].[CovidDataByLocation] ADD  CONSTRAINT [DF_CovidDataByLocation_CreatedUTCDate]  DEFAULT (getutcdate()) FOR [CreatedUTCDate]
GO

ALTER TABLE [ourworldindata].[CovidDataByLocation] ADD  CONSTRAINT [DF_CovidDataByLocation_CreatedByUser]  DEFAULT (suser_sname()) FOR [CreatedByUser]
GO

