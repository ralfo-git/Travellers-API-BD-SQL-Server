USE [DBTravellers]
GO


/*

select
*
from
[Travellers].[vwTravellers]

*/

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Travellers].[vwTravellers]'))
DROP VIEW [Travellers].[vwTravellers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Travellers].[vwTravellers]	                                                                                                                                                                                                                                                                                                        with encryption
AS
with CTEvw
(
					[TravellerId],
					[FullName],
					[FirstName],
					[LastName],
					[CardID],
					[PhoneNumber],
					[Address],
					[Creation],
					[Creator]
)
as
(
					select
					u.TravellerId,
					u.LastName + ', ' + u.FirstName,
					u.FirstName, 
					u.LastName,
					u.CardID,
					u.PhoneNumber,
					u.[Address],
					convert(nvarchar(40),u.[Creation],103) + ' ' + convert(nvarchar(40),u.[Creation],108) [Creation],
					u.Creator
					from
					Travellers.Travellers u
)
select
*
from
CTEvw u

GO





