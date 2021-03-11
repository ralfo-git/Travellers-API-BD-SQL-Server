USE [DBTravellers]
GO


/*

select
*
from
[Travellers].[vwSQLLogins] s

*/

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Travellers].[vwSQLLogins]'))
DROP VIEW [Travellers].[vwSQLLogins]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Travellers].[vwSQLLogins]	
with encryption
AS
with CTEvw
(
					[UserId],
					[Login],
					[FirstName],
					[LastName],
					[GenderId],
					[RoleId],
					[Create_Date],
					[Modify_Date]
)
as
(
						select
						s.principal_id,
						s.[name],
						case 
						when s.[name] = 'ralfonzo'
						then
						'raúl'
						else
						''
						end,
						case 
						when s.[name] = 'ralfonzo'
						then
						'alfonzo'
						else
						''
						end,
						case 
						when s.[name] = 'ralfonzo'
						then
						'm'
						else
						''
						end,
						case 
						when s.[name] = 'ralfonzo'
						then
						1
						else
						0
						end,
						convert(nvarchar(40),s.[create_date],103) + ' ' + convert(nvarchar(40),s.[create_date],108),
						convert(nvarchar(40),s.[modify_date],103) + ' ' + convert(nvarchar(40),s.[modify_date],108)
						from
						sys.sql_logins s
						where 
						s.type_desc = N'SQL_LOGIN' and
						s.default_database_name = 'DBTravellers'
)
select
s.UserId,
s.[Login],
s.[FirstName],
s.[LastName],
s.[GenderId],
case 
when
s.[GenderId] = 'm'
then
'male'
else
'female'
end [Gender],
case 
when
s.[GenderId] = 'm'
then
'mr.'
else
'mrs.'
end [Treatment],
s.[RoleId],
case 
when
s.[RoleId] = 1
then
'administrator'
when
s.[RoleId] = 2
then
'operator'
else
''
end [Role],
s.[Create_Date],
s.[Modify_Date]
from
CTEvw s

GO





