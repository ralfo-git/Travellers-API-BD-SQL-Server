USE [DBTravellers]
GO

--select lower('IDENTITY(1,1) NOT NULL')
--select len('+58 412-6058494')

/****** Object:  Table [travellers].[Destinations]    Script Date: 22/12/2020 16:53:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[travellers].[Destinations]') AND type in (N'U'))
DROP TABLE [travellers].[Destinations]
GO

/****87655** Object:  Table [travellers].[Destinations]    Script Date: 22/12/2020 16:53:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [travellers].[Destinations](
	[DestinationId] [int] identity(1,1) not null,
	[TravelCode] [nvarchar] (25) not null constraint [TravelCodeIsUnique] unique nonclustered constraint [Length(TravelCode)>0] check (len([TravelCode])>0),
	[Name] [nvarchar] (25) not null constraint [Length(Name)>0] check (len([Name])>0),
	[AvailableQty] [smallint] not null default(0),
	[LocationPlace] [nvarchar] (30) not null constraint [Length(LocationPlace)>0] check (len([LocationPlace])>0),
	[Price] [decimal](10,2) not null default(0),
	[Description] [nvarchar] (250) not null constraint [Length(Description)>0] check (len([Description])>0),
	[Creator] [nvarchar] (50) not null default(system_user),
	[Creation] [datetime] not null default(getdate()),
 CONSTRAINT [PK_Destinations] PRIMARY KEY CLUSTERED 
(
	[DestinationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


