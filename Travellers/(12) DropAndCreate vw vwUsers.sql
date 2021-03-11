USE [DBTravellers]
GO


/*

select
*
from
[Travellers].[vwUsers] u


select
u.UserId,
u.[Login],
u.RoleId,
u.[Role],
u.[FirstName],
u.[LastName],
u.[GenderId],
u.[Gender],
u.Treatment,
u.[IsLocked],
u.GrantMessage,
u.FarewellMessage,
u.FullNameDisplay,
u.Creation,
u.Creator
from
[Travellers].[vwUsers] u

*/

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Travellers].[vwUsers]'))
DROP VIEW [Travellers].[vwUsers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Travellers].[vwUsers]	
with encryption
AS
with CTEvw
(
					[UserId],
					[Login],
					[RoleId],
					[Role],
					[FirstName],
					[LastName],
					[GenderId],
					[Gender],
					[Treatment],
					[PasswordHash],
					[Password],
					[MaxAuthCountAttempts],
					[IsLocked],
					[GrantMessage],
					[FarewellMessage],
					[Creation],
					[Creator]
)
as
(
					select
					u.UserId,
					u.[Login],
					u.[RoleId],
					case 
					when
					u.[RoleId] = 1
					then
					(select m.[Message] from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 18)--'Administrator'
					else
					(select m.[Message] from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 19)--'Operator'
					end,
					u.FirstName, 
					u.LastName,
					u.GenderId,
					case
					when u.GenderId = 'M'
					then
					'Male'
					else
					'Female'
					end,
					case 
					when
					u.[GenderId] = 'M'
					then
					'Sr.'
					else
					'Sra.'
					end [Treatment],
					u.PasswordHash,
					u.[Password],
					u.[MaxAuthCountAttempts],
					case 
					when u.[MaxAuthCountAttempts] = 0
					then
					1
					else
					0
					end,


					replace(replace((select replace(m.[Message],'$',case 
					when
					u.[GenderId] = 'M'
					then
					'o'
					else
					'a'
					end) from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 20),'*',u.LastName + ', ' + u.FirstName),'#',(case 
					when
					u.[GenderId] = 'M'
					then
					'Sr.'
					else
					'Sra.'
					end)),

					replace(replace((select m.[Message] from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 21),'*',u.LastName + ', ' + u.FirstName),'#',case 
					when
					u.[GenderId] = 'M'
					then
					'Sr.'
					else
					'Sra.'
					end),

					convert(nvarchar(40),u.[Creation],103) 
					+ ' ' + convert(nvarchar(40),
					u.[Creation],108) [Creation],
					u.Creator
					from
					[travellers].[Users] u
)
select
u.UserId,
u.[Login],
u.[RoleId],
u.[Role],
u.[FirstName],
u.[LastName],
u.[GenderId],
u.[Gender],
u.[Treatment],
u.[PasswordHash],
u.[Password],
u.[MaxAuthCountAttempts],
u.[IsLocked],
u.[GrantMessage],
u.[FarewellMessage],
replace(replace((select replace(m.[Message],'#',u.[Treatment]) 
from [Travellers].[vwMessages] m 
with (nolock) where m.MessageID = 22),'&',
u.LastName + ', ' + u.FirstName),
'$',u.[Role]) [FullNameDisplay],--   '(Sr.|Sra.) '+u.[LastName] + ', ' +u.[FirstName] +' (' + u.[Role] + ')'   [FullNameDisplay],
u.[Creation],
u.[Creator]
from
CTEvw u

GO





