USE [DBTravellers]
GO

if  exists (select * from sys.objects where object_id = OBJECT_ID(N'[Travellers].[spTravellers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Travellers].[spTravellers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		     Raúl Alfonzo
-- Description:	Manages Entity [Travellers].[Travellers] 
-- =============================================
create procedure [Travellers].[spTravellers]
@TravellerId int = null,
@FirstName nvarchar(25) = null,
@LastName nvarchar(25) = null,
@CardID nvarchar(9) = null,
@PhoneNumber nvarchar(18) = null,
@Address nvarchar(250) = null																																																																																																																				with encryption
as
begin
						set nocount on;
						declare @opmode nvarchar(50),
						@outputmessage nvarchar(max),
						@output int = 0



						if @FirstName is not null and 
						@LastName is not null and 
						@CardID is not null and 
						@PhoneNumber is not null and 
						@Address is not null 
						begin
												set @opmode = 'update'
												if @TravellerId is null
												set @opmode = 'insert'

												begin try
												                        begin transaction
																		if @opmode = 'insert'
																		begin
																								insert into Travellers.Travellers
																								(
																														[FirstName],
																														[LastName],
																														[CardID],
																														[PhoneNumber],
																														[Address]
																								)
																								values
																								(
																														@FirstName,
																														@LastName,
																														@CardID,
																														@PhoneNumber,
																														@Address
																								)
																								select
																								@output = @@identity,
																								@outputmessage = (select m.[Message] from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 2)
																								set @TravellerId =  @output
																		end
																		else if @opmode = 'update'
																		begin
																		                        if exists
																								(
																														select 
																														u.TravellerId 
																														from 
																														Travellers.vwTravellers u 
																														where 
																														u.TravellerId = @TravellerId
																								)
																								begin
																														update u set
																														u.[FirstName] = @FirstName,
																														u.[LastName] = @LastName,
																														u.[CardID] = @CardID,
																														u.[PhoneNumber] = @PhoneNumber,
																														u.[Address] = @Address
																														from Travellers.Travellers u
																														where
																														u.TravellerId = @TravellerId
																														select
																														@output = @TravellerId,
																														@outputmessage = (select m.[Message] from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 4)
																								end
																								else
																								select 
																								@output = @TravellerId,
																								@outputmessage = 'Update failed, Id doesn''t exist'
																		end
																		commit transaction
												end try
												begin catch
												                        select 
																		@opmode = 
																		case 
																		when @opmode = 'update' 
																		then 
																		'update failed'
																		else
																		'insert failed'
																		end

																		select @output = -error_number(),
																		@outputmessage = case 
																		when 
																		patindex('%' + 'CardIDIsUnique' +'%',error_message())>0 
																		then 
																		replace(((select m.[Message] from [Travellers].[vwMessages] m where m.MessageID = 3)),'*',@CardID) 
																		when 
																		patindex('%' + 'Length(CardId)>0' +'%',error_message())>0 
																		then 
																		'CardId length must bigger than 0' 
																		when 
																		patindex('%' + 'Length(FirstName)>0' +'%',error_message())>0 
																		then 
																		'FirstName length must bigger than 0' 
																		when 
																		patindex('%' + 'Length(LastName)>0' +'%',error_message())>0 
																		then 
																		'LastName length must bigger than 0'
																		when 
																		patindex('%' + 'Length(PhoneNumber)>0' +'%',error_message())>0 
																		then 
																		'PhoneNumber length must bigger than 0' 
																		when 
																		patindex('%' + 'Length([Address])>0' +'%',error_message())>0 
																		then 
																		'Address length must bigger than 0' 
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
						else if @TravellerId is null
						begin
												set @opmode = 'get all'
												if exists
												(
																		select 
																		u.TravellerId 
																		from 
																		Travellers.vwTravellers u
												)
												select 
												*  
												from Travellers.vwTravellers u
												order 
												by
												u.FullName
						end
						else if @TravellerId > 0
						begin
												set @opmode = 'get one by Id'
												if exists(select u.TravellerId from Travellers.vwTravellers u with (nolock) where u.TravellerId = @TravellerId)
												select 
												*  
												from Travellers.vwTravellers u where u.TravellerId = @TravellerId
						end
						else if @TravellerId < 0
						begin
												set @opmode = 'delete'
												set @TravellerId = abs(@TravellerId)
												if exists(select u.TravellerId  from Travellers.Travellers u with (nolock) where u.TravellerId = @TravellerId)
												begin
																		begin try
																								begin transaction
																								delete from [Travellers].Travellers where
																								TravellerId = @TravellerId
																								select
																								@output = @TravellerId,
																								@outputmessage = (select m.[Message] from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 1)
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
												@output = -@TravellerId,
												@opmode = 'delete failed',
												@outputmessage = replace('The selected Id (*) doesn''t exist','*',cast(@TravellerId as nvarchar(7)))

												select 
												@output as [output],
												isnull(@opmode,'') as [opmode],
												isnull(@outputmessage,'') as [outputmessage]
						end
end
go


