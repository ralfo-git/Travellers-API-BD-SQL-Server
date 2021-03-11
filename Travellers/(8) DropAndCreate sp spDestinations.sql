USE [DBTravellers]
GO

if  exists (select * from sys.objects where object_id = OBJECT_ID(N'[Travellers].[spDestinations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Travellers].[spDestinations]
GO

/****** Object:  StoredProcedure [Travellers].[spDestinations]    Script Date: 22/12/2020 18:57:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		     Raúl Alfonzo
-- Description:	Manages Entity [Travellers].[Destinations] 
-- =============================================
create procedure [Travellers].[spDestinations]
@DestinationId int = null,
@TravelCode nvarchar(25) = null,
@Name nvarchar(25) = null,
@AvailableQty smallint = null,
@LocationPlace nvarchar(30) = null,
@Price money = null,
@Description nvarchar(250) = null		--							s																																																																																																																																																																																																	with encryption
as
begin
						set nocount on;
						declare @opmode nvarchar(50),
						@outputmessage nvarchar(max),
						@output int = 0



						if @TravelCode is not null and 
						@Name is not null and 
						@AvailableQty is not null and 
						@LocationPlace is not null and
						@Price is not null and 
						@Description is not null 
						begin
												set @opmode = 'update'
												if @DestinationId is null
												set @opmode = 'insert'

												begin try
												                        begin transaction
																		if @opmode = 'insert'
																		begin
																								insert into Travellers.Destinations
																								(
																													[TravelCode],
																													[Name],
																													[AvailableQty],
																													[LocationPlace],
																													[Price],
																													[Description]
																								)
																								values
																								(
																													@TravelCode,
																													@Name,
																													@AvailableQty,
																													@LocationPlace,
																													@Price,
																													@Description
																								)
																								select
																								@output = @@identity,
																								@outputmessage = (																								(
																										select 
																										m.[Message] 
																										from 
																										[Travellers].[vwMessages] m with (nolock)
																										where 
																										m.MessageID = 6))--'insert ok'
																								set @DestinationId =  @output
																		end
																		else if @opmode = 'update'
																		begin
																		                        if exists
																								(
																														select 
																														u.DestinationId 
																														from 
																														Travellers.vwDestinations u 
																														where 
																														u.DestinationId = @DestinationId
																								)
																								begin
																														update u set
																														u.[TravelCode] = @TravelCode,
																														u.[Name] = @Name,
																														u.[AvailableQty] = @AvailableQty,
																														u.[LocationPlace] = @LocationPlace,
																														u.[Price] = @Price,
																														u.[Description] = @Description
																														from Travellers.Destinations u
																														where
																														u.DestinationId = @DestinationId
																														select
																														@output = @DestinationId,
																														@outputmessage = (																								(
																										select 
																										m.[Message] 
																										from 
																										[Travellers].[vwMessages] m with (nolock)
																										where 
																										m.MessageID = 5
																								)--'delete ok'
)--'update ok'
																								end
																								else
																								select 
																								@output = @DestinationId,
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
																		patindex('%' + 'TravelCodeIsUnique' +'%',error_message())>0 
																		then 
																		(select replace(m.[Message],'*',@TravelCode) from [Travellers].[vwMessages] m with (nolock) where m.MessageID = 7)--replace(((select m.[Message] from [Travellers].[vwMessages] m where m.MessageID = 7)),'*',@TravelCode) 
																		when 
																		patindex('%' + 'Length(CardId)>0' +'%',error_message())>0 
																		then 
																		'TravelCode length must bigger than 0' 
																		when 
																		patindex('%' + 'Length([Name])>0' +'%',error_message())>0 
																		then 
																		'[Name] length must bigger than 0' 
																		when 
																		patindex('%' + 'Length([LocationPlace])>0' +'%',error_message())>0 
																		then 
																		'[LocationPlace] length must bigger than 0'
																		when 
																		patindex('%' + 'Length([Description])>0' +'%',error_message())>0 
																		then 
																		'[Description] length must bigger than 0' 
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
						else if @DestinationId is null
						begin
												set @opmode = 'get all'
												if exists
												(
																		select 
																		u.DestinationId 
																		from 
																		Travellers.vwDestinations u with (nolock)
												)
												select 
												*  
												from Travellers.vwDestinations u with (nolock)
												order 
												by
												u.TravelCode
						end
						else if @DestinationId > 0
						begin
												set @opmode = 'get one by Id'
												if exists(select u.DestinationId from Travellers.vwDestinations u with (nolock) where u.DestinationId = @DestinationId)
												select 
												*  
												from Travellers.vwDestinations u where u.DestinationId = @DestinationId
						end
						else if @DestinationId < 0
						begin
												set @opmode = 'delete'
												set @DestinationId = abs(@DestinationId)
												if exists(select u.DestinationId  from Travellers.Destinations u with (nolock) where u.DestinationId = @DestinationId)
												begin
																		begin try
																								begin transaction
																								delete from [Travellers].Destinations where
																								DestinationId = @DestinationId
																								select
																								@output = @DestinationId,
																								@outputmessage =
																								(
																										select 
																										m.[Message] 
																										from 
																										[Travellers].[vwMessages] m with (nolock) 
																										where 
																										m.MessageID = 8
																								)--'delete ok'
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
												@output = -@DestinationId,
												@opmode = 'delete failed',
												@outputmessage = replace('The selected Id (*) doesn''t exist','*',cast(@DestinationId as nvarchar(7)))

												select 
												@output as [output],
												isnull(@opmode,'') as [opmode],
												isnull(@outputmessage,'') as [outputmessage]
						end
end
go


