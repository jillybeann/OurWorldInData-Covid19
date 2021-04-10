/****** Object:  Table [ourworldindata].[CovidDataByDay]    Script Date: 4/6/2021 10:20:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ourworldindata].[CovidDataByDay](
	[CovidDataByDayID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NULL,
	[DateYear] [int] NULL,
	[DateMonth] [int] NULL,
	[Continent] [varchar](50) NULL,
	[Location] [varchar](50) NULL,
	[CumulativeCases] [bigint] NULL,
	[NewCases] [bigint] NULL,
	[NewCasesSmoothed] [bigint] NULL,
	[NewDeaths] [bigint] NULL,
	[NewDeathsSmoothed] [bigint] NULL,
	[HospitalizedPatients] [bigint] NULL,
	[NewTests] [bigint] NULL,
	[NewTestsSmoothed] [bigint] NULL,
	[NewVaccinations] [bigint] NULL,
	[NewVaccinationsSmoothed] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUTCDate] [datetime] NOT NULL,
	[CreatedByUser] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_CovidDataByDay] PRIMARY KEY CLUSTERED 
(
	[CovidDataByDayID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_CovidDataByDay_Date]    Script Date: 4/6/2021 10:20:42 AM ******/
CREATE NONCLUSTERED INDEX [IX_CovidDataByDay_Date] ON [ourworldindata].[CovidDataByDay]
(
	[Date] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_CovidDataByDay_Location]    Script Date: 4/6/2021 10:20:42 AM ******/
CREATE NONCLUSTERED INDEX [IX_CovidDataByDay_Location] ON [ourworldindata].[CovidDataByDay]
(
	[Location] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

ALTER TABLE [ourworldindata].[CovidDataByDay] ADD  CONSTRAINT [DF_CovidDataByDay_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [ourworldindata].[CovidDataByDay] ADD  CONSTRAINT [DF_CovidDataByDay_CreatedUTCDate]  DEFAULT (getutcdate()) FOR [CreatedUTCDate]
GO

ALTER TABLE [ourworldindata].[CovidDataByDay] ADD  CONSTRAINT [DF_CovidDataByDay_CreatedByUser]  DEFAULT (suser_sname()) FOR [CreatedByUser]
GO


