/*
execute [travellers].[spUsers] @UserId, @RoleId, @Login, @Password, @FirstName, @LastName, @GenderId
*/
execute [travellers].[spUsers] -- Get All Users
execute [travellers].[spUsers] 2 -- Get one by Id
execute [travellers].[spUsers] -2 -- Delete user by Id
execute [travellers].[spUsers] null, null, 'ralfonzo', 'abc.01' -- Authentication try (Success)
execute [travellers].[spUsers] null, null, 'alaguna', 'alaguna.01' -- Authentication try (Success)
execute [travellers].[spUsers] null, null, 'lgomez', 'abc.01' -- Authentication try (Success)
execute [travellers].[spUsers] null, null, 'oalfonzo', 'abc.01' -- Authentication try (Success)

execute [travellers].[spUsers] null, null, 'ralfonzo', 'abc.01s' -- Authentication try (Fail)
execute [travellers].[spUsers] null, null, 'alaguna', 'alaguna.02' -- Authentication try (Fail)

execute [travellers].[spUsers] null, null, 'ralfonzo', 'abc.02', 'abc.01' -- Password change provided current one (Success)
execute [travellers].[spUsers] null, null, 'ralfonzo', 'abc.01', 'abc.02' -- Password change provided current one (Fail)
execute [travellers].[spUsers] null, null, 'ralfonzo', 'abc.02', 'abc.03' -- Password change provided current one (Success)
execute [travellers].[spUsers] null, null, 'ralfonzo', null ,'abc.01' -- Password change by Administrator (Success)
execute [travellers].[spUsers] null, null, 'ralfonzo.resetLogin' -- Reset login for being locked
execute [travellers].[spUsers] null, null, 'lgomez.resetLogin' -- Reset login for being locked
execute [travellers].[spUsers] null, null, 'alaguna.resetLogin' -- Reset login for being locked

execute [travellers].[spUsers] null, 1 ,'etorrealba','frito.$','Edgar','Torrealba','M'
execute [travellers].[spUsers] null, 1 ,'arobles','abc.01','Austin','Robles','M'
execute [travellers].[spUsers] 9, 1 ,'arobles','austin.$','Austin','Robles','M'

execute [travellers].[spUsers] null, 1 ,'ralfonzo','abc.01','Raúl','Alfonzo','M' -- Add a new user
execute [travellers].[spUsers] null, 2 ,'lgomez','abc.01','Luzmila','Gomez','F' -- Add a new user
execute [travellers].[spUsers] null, 2 ,'alaguna', 'alaguna.01','Abel','Laguna','M' -- Add a new user
execute [travellers].[spUsers] null, 1 ,'cjohan', 'cjohan.01','Cortés','Johan', 'M' -- Add a new user
execute [travellers].[spUsers] null, 1 ,'yvargas','yvarg.01','Yaritza','Vargas','F'

execute [travellers].[spUsers] null, 1 ,'rgonzalez','rgonza.$','Rafael','Gonzalez','M'
execute [travellers].[spUsers] null, 1 ,'rvalera','xyz.01','Renny','Valera','M'
execute [travellers].[spUsers] null, 1 ,'alaguna','admin.01','Abel','Laguna','M'
execute [travellers].[spUsers] null, 2 ,'lgomez','abc.01','Luzmila','Gomez','F'
execute [travellers].[spUsers] null, 2 ,'oalfonzo','5mentario.bro','Omar','Alfonzo','M'
execute [travellers].[spUsers] null, 2 ,'dstrong','abc.01','Delilah','Strong','F'
execute [travellers].[spUsers] null, 2 ,'sdee','abc.01','Sophie','Dee','F'

execute [travellers].[spUsers] 4, 1 ,'oalfonzo','','Omar','Alfonzo','M'
