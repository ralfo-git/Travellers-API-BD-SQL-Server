USE [DBTravellers]
GO

if  exists (select * from sys.objects where object_id = OBJECT_ID(N'[travellers].[spUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [travellers].[spUsers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [travellers].[spUsers]
@UserId int = null,
@RoleId smallint = null,
@Login nvarchar(40) = null,
@Password nvarchar(50) = null,
@FirstName nvarchar(64) = null,
@LastName nvarchar(40) = null,
@GenderId char(1) = null
with encryption
as
begin
/*
						Engineered by Raúl Alfonzo 
						Manages [travellers].[Users] Entity
*/
						set nocount on
						declare @opmode nvarchar(80),
						@outputmessage nvarchar(80),
						@Salt uniqueidentifier = null,
						@output int = 0,
						@MaxAuthCountAttempts int = 0

						if @Login is not null and
						@GenderId is not null and 
						@RoleId is not null and 
						@Password is not null and 
						@FirstName is not null and 
						@LastName is not null 
						begin
												set @opmode = 'update'
												if @UserId is null
												set @opmode = 'insert'
												begin try
																		begin transaction
																		if @opmode = 'insert'
																		begin
																								select @Salt = newid()
																								insert into [travellers].[Users]
																								(
																														[Login],
																														[RoleId],
																														[GenderId],
																														[FirstName],
																														[LastName],
																														[PasswordHash],
																														[Password],
																														[Salt]
																								)
																								values
																								(
																														@Login,
																														@RoleId,
																														@GenderId,
																														@FirstName,
																														@LastName,
																														hashbytes('SHA2_256',
																														@Password+cast(@Salt as nvarchar(36))),
																														hashbytes('SHA2_256',@Password),
																														@Salt
																								)
																								select
																								@output = @@identity,
																								@outputmessage = ((select m.[Message] from [Travellers].[vwMessages]  m with (nolock) where m.MessageID = 9))
																								set @UserId =  @output
																		end
																		else if @opmode = 'update'
																		begin
																		                        if exists (select u.UserId from [travellers].[Users] u with (nolock) where u.UserId = @UserId)
																								begin
																														update  u   
																														set
																														u.RoleId = @RoleId, 
																														u.[Login] = @Login,
																														u.[GenderId] = @GenderId,
																														u.[FirstName] = @FirstName,
																														u.[LastName] = @LastName
																														from [travellers].Users u
																														where
																														u.UserId = @UserId

																														select
																														@output = @UserId,
																														@outputmessage =  m.[Message] 
																														from 
																														[Travellers].[vwMessages] m with (nolock) where m.MessageID = 10
																								end
																								else
																								select 
																								@output = @UserId,
																								@outputmessage = 'Update failed, Id doesn''t exist'
																		end 
																		commit transaction 
												end try
												begin catch
																		select @output = -error_number(),
																		@outputmessage = case 
																		when 
																		patindex('%' + 'LoginIsUnique' +'%',error_message())>0 
																		then 
																		replace('Login name ''*'' must be unique','*',@Login) 
																		when 
																		patindex('%' + 'Length(Login)>0' +'%',error_message())>0 
																		then 
																		'Login length must bigger than 0' 
																		when 
																		patindex('%' + 'Length(UserFirstName)>0' +'%',error_message())>0 
																		then 
																		'FirstName length must bigger than 0' 
																		when 
																		patindex('%' + 'Length(UserLastName)>0' +'%',error_message())>0 
																		then 
																		'LastName length must bigger than 0' 
																		else 
																		error_message() 
																		end
																		rollback transaction
												end catch
												select 
												@output as [output],
												isnull(@opmode,'') as [opmode],
												isnull(@outputmessage,'') as [outputmessage]
						end
						else if @UserId is null and
						@RoleId is null and
						@GenderId is null and
						@Login is null and 
						@Password is null and 
						@FirstName is null and 
						@LastName is null  
						begin
												set @opmode = 'get all'
												if exists
												(
																		select 
																		u.UserId 
																		from 
																		Travellers.vwUsers u
												)
												select 
												u.UserId,
												u.[Login],
												u.RoleId,
												u.GenderId,
												u.Gender,
												u.[Role],
												u.[FirstName],
												u.[LastName],
												u.[IsLocked],
												u.Creation,
												u.Creator
												from Travellers.vwUsers u with (nolock)
												order 
												by
												u.[LastName],u.[FirstName]
						end
						else if @UserId > 0 and
						@RoleId  is null and
						@GenderId is null and
						@Login is null and 
						@Password is null and 
						@FirstName is null and 
						@LastName is null
						begin
												set @opmode = 'get one by Id'
												if exists(select u.UserId from Travellers.vwUsers u where u.UserId = @UserId)
												select 
												u.UserId,
												u.[Login],
												u.RoleId,
												u.[GenderId],
												u.[Gender],
												u.[Role],
												u.[FirstName],
												u.[LastName],
												u.[IsLocked],
												u.GrantMessage,
												u.FarewellMessage,
												u.FullNameDisplay,
												u.Creation,
												u.Creator
												from Travellers.vwUsers u where u.UserId = @UserId
						end
						else if @UserId < 0 and
						@RoleId  is null and
						@GenderId is null and
						@Login is null and 
						@Password is null and 
						@FirstName is null and 
						@LastName is null
						begin
												set @opmode = 'delete'
												set @UserId = abs(@UserId)
												if exists(select u.UserId  from Travellers.vwUsers u where u.UserId = @UserId)
												begin
																		begin try
																								begin transaction
																								delete from [Travellers].Users where
																								UserId = @UserId
																								select
																								@output = @UserId,
																								@outputmessage =(select m.[Message] from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 11)
																								commit transaction
																		end try
																		begin catch
																								select 
																								@output = -error_number(),
																								@opmode = 'delete failed',
																								@outputmessage = error_message()  
																								rollback transaction
																		end catch
												end
												else
												select 
												@output = -@UserId,
												@opmode = 'delete failed',
												@outputmessage = replace('The selected Id (*) doesn''t exist','*',cast(@UserId as nvarchar(7)))
												select 
												@output as [output],
												isnull(@opmode,'') as [opmode],
												isnull(@outputmessage,'') as [outputmessage]
						end
						else if @UserId is null and
						@RoleId  is null and
						@GenderId is null and
						@Login is not null and 
						@Password is not null and 
						@FirstName is null and 
						@LastName is null
						begin
												select @output = -1,
												@opmode = 'Authentication',
												@outputmessage = (select m.[Message] from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 16)     																								
						                        if exists(select u.UserID from  [travellers].Users u where u.[Login] = @Login)
												begin
																		select
																		@outputmessage = (select m.[Message] from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 17),
																		@UserId = u.UserId,
																		@MaxAuthCountAttempts = u.MaxAuthCountAttempts 
																		from  
																		[travellers].vwUsers u 
																		where u.[Login] = @Login
																		if @MaxAuthCountAttempts = 0
																		begin
																								select
																								@outputmessage = (select m.[Message] from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 15)
																								select 
																								@output as [output],
																								@opmode as [opmode],
																								@outputmessage as [outputmessage],
																								cast(0 as smallint) [RoleId],
																								'' [GrantMessage],
																								'' [FarewellMessage],
																								'' [FullNameDisplay]
																								return
																		end
																		if exists(select u.UserID from [travellers].Users u where u.[Login] = @Login and hashbytes('SHA2_256',@Password+cast(u.Salt as nvarchar(36))) = u.PasswordHash)
																		begin
																								update u
																								set
																								u.MaxAuthCountAttempts = 3 
																								from  
																								[travellers].Users u 
																								where u.UserId = @UserId   

																								select
																								@output = u.UserID,
																								@outputmessage = (select replace(m.[Message],'$',(select case when u.GenderId = 'M' then 'o' else 'a' end from [travellers].[Users] u 
																								where u.UserId =  @UserId)) from [Travellers].[vwMessages] m where m.MessageID = 12)
																								from 
																								[travellers].Users u 
																								where 
																								u.[Login] = @Login 
																								and hashbytes('SHA2_256',@Password+cast(u.Salt as nvarchar(36))) = u.PasswordHash
																								select
																								@output as [output],
																								@opmode as [opmode],
																								@outputmessage as [outputmessage],
																								u.RoleId [RoleId],
																								u.GrantMessage [GrantMessage],
																								u.FarewellMessage [FarewellMessage],
																								u.FullNameDisplay [FullNameDisplay]
																								from 
																								[travellers].vwUsers u 
																								where 
																								u.[UserId] = @UserId
																								return
																		end
																		else
																		begin
																								if (@MaxAuthCountAttempts)>0
																								begin
																														update u
																														set
																														u.MaxAuthCountAttempts = u.MaxAuthCountAttempts -1,
																														@MaxAuthCountAttempts = u.MaxAuthCountAttempts -1
																														from  
																														[travellers].Users u 
																														where u.UserId = @UserId

																														if (@MaxAuthCountAttempts)=0
																														select
																														@outputmessage = (select m.[Message] from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 15)     
																														else
																														select
																														@outputmessage = (select 
																										m.[Message] 
																										from 
																										[Travellers].[vwMessages] m 
																										where 
																										m.MessageID = 13) + cast((@MaxAuthCountAttempts) as nvarchar(2)) + (select 
																										m.[Message] 
																										from 
																										[Travellers].[vwMessages] m with (nolock)  
																										where 
																										m.MessageID = 14) 
																								end
																		end
												end
												select 
												@output as [output],
												@opmode as [opmode],
												@outputmessage as [outputmessage],
												cast(0 as smallint) [RoleId],
												'' [GrantMessage],
												'' [FarewellMessage],
												'' [FullNameDisplay]
						end 
						else if 
						@UserId is null and
						@RoleId  is null and
						@GenderId is null and
						@Login is not null and patindex('%' + '.resetLogin' + '%',@Login)>0 and 
						@Password is null and 
						@FirstName is null and  
						@LastName is null 
						begin
												select
												@Login = replace(@Login,'.resetLogin','')
												select @output = -1,
												@opmode = 'ResetLogin',
												@outputmessage = 'Unknown login!'
						                        if exists(select u.UserID from  [travellers].Users u where u.[Login] = @Login)
												begin
																		select 
																		@UserId = u.UserID,
																		@output = u.UserID,
																		@outputmessage = (select m.[Message] from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 24)--'Login reset done and unlocked!'
																		from 
																		[travellers].Users u 
																		where u.[Login] = @Login
																		update u
																		set
																		u.MaxAuthCountAttempts = 3
																		from  
																		[travellers].Users u 
																		where 
																		u.UserID = @UserId
												end
												select 
												@output as [output],
												@opmode as [opmode],
												@outputmessage as [outputmessage]
						end
						else if
						@UserId is null and
						@RoleId  is null and
						@GenderId is null and
						@Login is not null and 
						@Password is not null and
						@FirstName is not null and
						@LastName is null 
						begin

												select @output = -1,
												@opmode = 'password change',
												@outputmessage = 'Unknown Login!'
						                        if exists(select u.UserID from  [travellers].Users u where u.[Login] = @Login)
												begin
																		select
																		@outputmessage = 'Incorrect current password!'
																		if exists(select u.UserID from  [travellers].Users u where u.[Login] = @Login and hashbytes('SHA2_256',@Password+cast(u.Salt as nvarchar(36))) = u.PasswordHash)
																		begin
																								select
																								@UserId = u.UserID, 
																								@output = u.UserID,
																								@outputmessage = 'Password changed successfully!' 
																								from 
																								[travellers].Users u 
																								where 
																								u.[Login] = @Login 
																								and hashbytes('SHA2_256',@Password+cast(u.Salt as nvarchar(36))) = u.PasswordHash

																								if exists(select u.UserID from  [travellers].Users u where u.[Login] = @Login and hashbytes('SHA2_256',@Password+cast(u.Salt as nvarchar(36))) = u.PasswordHash and hashbytes('SHA2_256',@FirstName) = u.[Password])
																								select
																								@outputmessage = 'New password must be different to current one!'
																								else 
																								update s set
																								s.MaxAuthCountAttempts = 3,
																								s.[Password] = hashbytes('SHA2_256',@FirstName),
																								s.PasswordHash = hashbytes('SHA2_256',@FirstName+cast(s.Salt as nvarchar(36)))
																								from 
																								[travellers].Users s where s.UserID = @output 
																		end
																		--- Must add code to lock user when 3 attempts are failed 
												end
												select 
												@output as [output],
												@opmode as [opmode],
												@outputmessage as [outputmessage]
						end
						else if
						@UserId is null and
						@RoleId  is null and
						@GenderId is null and
						@Login is not null and
						@Password is null and
						@FirstName is not null and
						@LastName is null 
						begin
												select @output = -1,
												@opmode = 'password change as administrator',
												@outputmessage = 'Unknown Login!'
						                        if exists(select u.UserID from  [travellers].Users u where u.[Login] = @Login)
												begin
																		select
																		@UserId = u.UserID, 
																		@output = u.UserID,
																		@outputmessage = 'Password changed successfully!' 
																		from 
																		[travellers].Users u 
																		where 
																		u.[Login] = @Login 

																		if exists(select u.UserID from  [travellers].Users u with (nolock) where u.[Login] = @Login and hashbytes('SHA2_256',@FirstName) = u.[Password])
																		select
																		@output = -1,
																		@outputmessage = 'New password must be different to current one!'
																		else 
																		update s set
																		s.MaxAuthCountAttempts = 3,
																		s.[Password] = hashbytes('SHA2_256',@FirstName),
																		s.PasswordHash = hashbytes('SHA2_256',@FirstName+cast(s.Salt as nvarchar(36)))
																		from 
																		[travellers].Users s where s.[Login] = @Login 
												end
												select 
												@output as [output],
												@opmode as [opmode],
												@outputmessage as [outputmessage]
						end
end
GO


