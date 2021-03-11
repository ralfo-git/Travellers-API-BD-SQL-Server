USE [DBTravellers]
GO

--select lower('IDENTITY(1,1) NOT NULL')
--select len('+58 412-6058494')

/****** Object:  Table [travellers].[Travels]    Script Date: 22/12/2020 16:53:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[travellers].[Travels]') AND type in (N'U'))
DROP TABLE [travellers].[Travels]
GO

/****** Object:  Table [travellers].[Travels]    Script Date: 22/12/2020 16:53:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [travellers].[Travels](
	[TravelId] [int] identity(1,1) not null,
	--[DestinationID] [int] not null constraint [fk_DestinationID] foreign key (DestinationID) references [travellers].[Destinations](DestinationId),
	--[TravellerID] [int] not null constraint [fk_TravellerID] foreign key (TravellerID) references [travellers].[Travellers](TravellerId),
	[DepartureDate] [datetime] not null default(getdate()),
	[Creator] [nvarchar] (50) not null default(system_user),
	[Creation] [datetime] not null default(getdate()),
 CONSTRAINT [PK_Travels] PRIMARY KEY CLUSTERED 
(
	[TravelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


