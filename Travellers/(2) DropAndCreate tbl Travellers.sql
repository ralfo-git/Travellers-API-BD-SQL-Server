USE [DBTravellers]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[travellers].[Travellers]') AND type in (N'U'))
DROP TABLE [travellers].[Travellers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [travellers].[Travellers](
	[TravellerId] [int] identity(1,1) not null,
	[FirstName] [nvarchar] (25) not null constraint [Length(FirstName)>0] check (len(FirstName)>0),
	[LastName] [nvarchar] (25) not null constraint [Length(LastName)>0] check (len(LastName)>0),
	[CardID] [nvarchar] (9) not null constraint [CardIDIsUnique] unique nonclustered constraint [Length(CardID)>0] check (len(CardID)>0),
	[PhoneNumber] [nvarchar] (18) not null constraint [Length(PhoneNumber)>0] check (len(PhoneNumber)>0),
	[Address] [nvarchar] (250) not null constraint [Length(Address)>0] check (len([Address])>0),
	[Creator] [nvarchar] (50) not null default(system_user),
	[Creation] [datetime] not null default(getdate()),
 CONSTRAINT [PK_Travellers] PRIMARY KEY CLUSTERED 
(
	[TravellerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


