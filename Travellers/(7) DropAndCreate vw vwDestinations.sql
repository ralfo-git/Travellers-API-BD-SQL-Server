USE [DBTravellers]
GO
/*
select
*
from
[Travellers].[vwDestinations] s
*/

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Travellers].[vwDestinations]'))
DROP VIEW [Travellers].[vwDestinations]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Travellers].[vwDestinations]	
																																																																																																		with encryption
AS
with CTEvw
(
					[DestinationId],
					[TravelCode],
					[Name],
					[AvailableQty],
					[LocationPlace],
					[Price],
					[Description],
					[Creation],
					[Creator]
)
as
(
					select
					u.DestinationId,
					u.TravelCode,
					u.[Name], 
					u.[AvailableQty],
					u.[LocationPlace],
					cast(u.[Price] as nvarchar(15)),
					u.[Description],

					convert(nvarchar(40),u.[Creation],103) + ' ' + convert(nvarchar(40),u.[Creation],108) [Creation],
					u.Creator
					from
					Travellers.Destinations u
)
select
*
from
CTEvw u

GO





