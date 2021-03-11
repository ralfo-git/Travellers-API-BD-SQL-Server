USE [DBTravellers]
GO

SET ANSI_PADDING ON
GO

if  exists (select so.object_id from sys.objects so where so.object_id = OBJECT_ID(N'[travellers].[Users]') AND type in (N'U', N'PC'))
DROP TABLE [travellers].[Users]
GO

CREATE TABLE [travellers].[Users](
	[UserId] [int] identity(1,1) not null,
	[RoleId] [smallint] not null default (1), 	-- Administrator(1); Operator(2)  
	[GenderId] [char](1) not null default ('M'),--M:(Masculino);F:(femenino)  
	[Login] [nvarchar](30) not null  
	constraint [LoginIsUnique] unique nonclustered, 
	constraint [Length(Login)>0] check (len([Login])>0),
	[PasswordHash] [binary](64) not null,
	[Password] [binary](64) not null,
	[FirstName] [nvarchar](40) not null
	constraint [Length(UserFirstName)>0] check (len([FirstName])>0),
	[LastName] [nvarchar](40) not null
	constraint [Length(UserLastName)>0] check (len([LastName])>0),
	[Salt] [uniqueidentifier] not null,
	[MaxAuthCountAttempts] int not null default (3),
	[Creation] [datetime] not null default (getdate()),
	[Creator] [nvarchar](15) not null default (system_user),
 CONSTRAINT [PK_travellers_UserId] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


