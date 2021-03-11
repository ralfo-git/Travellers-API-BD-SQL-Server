execute [Travellers].[spDestinations]
execute [Travellers].[spDestinations]   1
execute [Travellers].[spDestinations]   100

exec [Travellers].[spDestinations] 

execute [Travellers].[spDestinations]   2
execute [Travellers].[spDestinations] -2 
execute [Travellers].[spDestinations] -8
execute [Travellers].[spDestinations] 1,'@TravelCode','@Name',25,'@LocationPlace',87655.89,'@Description'





execute [Travellers].[spDestinations] 1, 'Raúl Adrián', 'Alfonzo Baptista','V10384191','+58 412-6058494','La Hacienda Caricuao, UD3 Bloque 7, piso 5 apto. 506, Caracas Municipio Libertador, Dtto. Capital'
execute [Travellers].[spDestinations] 100, 'Raúl Adrián', 'Alfonzo Baptista','V10384191','+58 412-6058494','La Hacienda Caricuao, UD3 Bloque 7, piso 5 apto. 506, Caracas Municipio Libertador, Dtto. Capital'

select @@SERVERNAME [SERVERNAME]