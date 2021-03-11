USE [DBTravellers]
GO


/*
select
m.Message
from
[Travellers].[vwMessages] m
where
m.MessageID = 1
--Hola Star with Git
*/

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Travellers].[vwMessages]'))
DROP VIEW [Travellers].[vwMessages]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Travellers].[vwMessages]
																																																																																																							with encryption
AS
with CTEvwMessages
(
					[MessageID],
					[Message]
)
as
(
												select 
																			MessageID, 
																			[Message]
												from 
												(
																			values 
																			(1,'El  viajero fue eliminado satisfactoriamente'),
																			(2,'El viajero ha sido agregado satisfactoriamente'),
																			(3,'Operación fallida, el Nro. de CI ó Pasaporte ''*'' ya existe.'),
																			(4,'El viajero ha sido editado satisfactoriamente'),
																			(5,'El destino de viaje ha sido editado satisfactoriamente'),
																			(6,'El destino de viaje ha sido agregado satisfactoriamente'),
																			(7,'Operación fallida, el código de viaje ''*'' ya existe.'),
																			(8,'El destino de viaje ha sido eliminado.'),
																			(9,'el usuario ha sido agregado'),
																			(10,'el usuario ha sido modificado'),
																			(11,'el usuario ha sido eliminado'),
																			(12,'Acceso autorizado, bienvenid$'),
																			(13,'Password o Contraseña incorrecto. '),
																			(14,' intento (s) restante (s) para autenticar'),
																			(15,'Ud. ha sido bloqueado, tras varios intentos fallidos de autenticación'),
																			(16,'el Login ingresado es desconocido'),
																			(17,'Password incorrecto'),
																			(18,'Administrador'),
																			(19,'Operador'),
																			(20,'Bienvenid$ al Sistema # *'),
																			(21,'Hasta pronto # *, gracias por su visita'),
																			(22,'# & ($)'),
																			(23,', intento (s) restante (s) para autenticar'),
																			(24,'el usuario ha sido desbloqueado exitosamente'),
																			(25,', intento (s) restante (s) para autenticar')


												) 
												Qry 
												(
																			MessageID, 
																			[Message] 
												)
)
select
u.MessageID,
u.[Message]
from
CTEvwMessages u 


GO





