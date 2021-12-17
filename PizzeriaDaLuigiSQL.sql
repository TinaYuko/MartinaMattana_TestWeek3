create database PizzeriaDaLuigi;

Create table Pizza(
IdPizza int Identity(1,1) NOT NULL primary key,
Nome nvarchar(50) NOT NULL,
Prezzo decimal(5,2) NOT NULL check(Prezzo>0)
);

Create table Ingrediente(
IdIngrediente int Identity(1,1) NOT NULL primary key,
Nome nvarchar(50) NOT NULL,
Costo decimal(5,2) NOT NULL check(Costo>0),
QtaMagazzino int NOT NULL check(QtaMagazzino>=0)
);

Create table Composizione(
IdPizza int NOT NULL foreign key references Pizza(IdPizza),
IdIngrediente int NOT NULL foreign key references  Ingrediente(IdIngrediente),
constraint PK_Composizione primary key (IdPizza, IdIngrediente)
);

Insert into Pizza values ('Margherita', 5),
						 ('Bufala', 7),
						 ('Diavola', 6),
						 ('Quattro Stagioni', 6.50),
						 ('Porcini', 7),
						 ('Dioniso', 8),
						 ('Ortolana', 8),
						 ('Patate e Salsiccia', 6),
						 ('Pomodorini', 6),
						 ('Quattro Formaggi', 7.50),
						 ('Caprese', 7.50),
						 ('Zeus', 7.50),
						 ('Sarda', 7);

Insert into Ingrediente values ('Pomodoro', 2, 100),
							   ('Mozzarella', 1.50, 50),
							   ('Mozzarella di bufala', 3, 20),
							   ('Spianata piccante', 5, 50),
							   ('Funghi', 1, 100),
							   ('Carciofi', 1.50, 30),
							   ('Prosciutto cotto', 1.50, 300),
							   ('Olive', 1, 50),
							   ('Funghi porcini', 1.50, 30),
							   ('Stracchino', 2.50, 100),
							   ('Speck', 3, 150),
							   ('Rucola', 2, 200),
							   ('Grana', 1.50, 250),
							   ('Verdure', 0.80, 1000),
							   ('Patate', 1, 550),
							   ('Salsiccia', 2.50, 300),
							   ('Ricotta', 2, 200),
							   ('Pomodorini', 1, 250),
							   ('Provola', 1.20, 100),
							   ('Gorgonzola', 2, 100),
							   ('Pomodoro fresco', 1.50, 800),
							   ('Basilico', 0.50, 200),
							   ('Bresaola', 2.50, 150),
							   ('Pecorino', 1.50, 250);

Insert into Composizione values(1,1),
							   (1,2),
							   (2,1),
							   (2,3),
							   (3,1),
							   (3,2),
							   (3,4),
							   (4,1),
							   (4,2),
							   (4,5),
							   (4,6),
							   (4,7),
							   (4,8),
							   (5,1),
							   (5,2),
							   (5,9),
							   (6,1),
							   (6,2),
							   (6,10),
							   (6,11),
							   (6,12),
							   (6,13),
							   (7,1),
							   (7,2),
							   (7,14),
							   (8,2),
							   (8,15),
							   (8,16),
							   (9,2),
							   (9,18),
							   (9,17),
							   (10,2),
							   (10,19),
							   (10,20),
							   (10,13),
							   (11,2),
							   (11,21),
							   (11,22),
							   (12,2),
							   (12,23),
							   (12,12),
							   (13, 1),
							   (13, 2),
							   (13, 16),
							   (13, 24);

--Query:
--1. Estrarre tutte le pizze con prezzo superiore a 6 euro.
select *
from Pizza
where prezzo >6

--2. Estrarre la pizza/le pizze più costosa/e.
select *
from Pizza 
where Prezzo= (select Max(Prezzo) from Pizza)

--3. Estrarre le pizze «bianche»
select distinct p.Nome, p.Prezzo
from Pizza p join Composizione c on p.IdPizza=c.IdPizza
             join Ingrediente i on c.IdIngrediente=i.IdIngrediente
where c.IdPizza not in (select c.IdPizza
			    	    from Composizione c join Ingrediente i on c.IdIngrediente = i.IdIngrediente
					    where i.Nome='Pomodoro')

--4. Estrarre le pizze che contengono funghi (di qualsiasi tipo)
select distinct p.Nome, p.Prezzo
from Pizza p join Composizione c on p.IdPizza=c.IdPizza
             join Ingrediente i on c.IdIngrediente=i.IdIngrediente
where i.Nome like 'Funghi%'

--Procedure:
--1. Inserimento di una nuova pizza (parametri: nome, prezzo) 
Create procedure InserisciPizza
@Nome nvarchar(50),
@Prezzo decimal(5,2)
As
Begin
	Begin try
	Insert into Pizza(Nome, Prezzo) Values (@Nome, @Prezzo);
	End try

	Begin catch
	select ERROR_LINE() as 'Riga', ERROR_MESSAGE()as 'Messaggio'
	End catch

End

Execute InserisciPizza 'Gennargentu', 8.50;

--2. Assegnazione di un ingrediente a una pizza (parametri: nome pizza, nome 
--ingrediente) 
Create procedure InserisciIngredienteXPizza
@NomePizza nvarchar(50),
@NomeIngrediente nvarchar(50)

As
Begin
	Begin try
	declare @IdPizza int

	select @IdPizza=IdPizza
	from Pizza 
	where Nome=@NomePizza

	declare @IdIngrediente int

	select @IdIngrediente=IdIngrediente
	from Ingrediente
	where Nome=@NomeIngrediente

	Insert into Composizione(IdPizza, IdIngrediente) Values (@IdPizza, @IdIngrediente);
	End try

	Begin catch
	select ERROR_LINE() as 'Riga', ERROR_MESSAGE()as 'Messaggio'
	End catch

End

execute InserisciIngredienteXPizza 'Gennargentu', 'Pomodoro'
execute InserisciIngredienteXPizza 'Gennargentu', 'Mozzarella'
execute InserisciIngredienteXPizza 'Gennargentu', 'Patate'
execute InserisciIngredienteXPizza 'Gennargentu', 'Salsiccia'
execute InserisciIngredienteXPizza 'Gennargentu', 'Pecorino'

--3. Aggiornamento del prezzo di una pizza (parametri: nome pizza e nuovo prezzo)
Create procedure AggiornaPrezzoPizza
@Nome nvarchar(50),
@NuovoPrezzo decimal(5,2)
As
Begin
	Begin try
	Update Pizza set Prezzo=@NuovoPrezzo where Nome=@Nome
	End try

	Begin catch
	select ERROR_LINE() as 'Riga', ERROR_MESSAGE()as 'Messaggio'
	End catch

End

execute AggiornaPrezzoPizza 'Caprese', 6.50

--4. Eliminazione di un ingrediente da una pizza (parametri: nome pizza, nome 
--ingrediente) 
Create procedure EliminaIngredienteXPizza
@NomePizza nvarchar(50),
@NomeIngrediente nvarchar(50)

As
Begin
	Begin try
	declare @IdPizza int

	select @IdPizza=IdPizza
	from Pizza 
	where Nome=@NomePizza

	declare @IdIngrediente int

	select @IdIngrediente=IdIngrediente
	from Ingrediente
	where Nome=@NomeIngrediente

	delete from Composizione where IdPizza=@IdPizza and IdIngrediente=@IdIngrediente
	End try

	Begin catch
	select ERROR_LINE() as 'Riga', ERROR_MESSAGE()as 'Messaggio'
	End catch

End

execute EliminaIngredienteXPizza 'Dioniso', 'Stracchino'

--5. Incremento del 10% del prezzo delle pizze contenenti un ingrediente 
--(parametro: nome ingrediente) 
create procedure IncrementaPizzaXIngrediente
@NomeIngrediente nvarchar (50)
as
begin
    begin try
	declare @IdPizza int 
	select @IdPizza = c.IdPizza
	from Composizione c join Ingrediente i on c.IdIngrediente = i.IdIngrediente
	where i.Nome = @NomeIngrediente

	declare @IdIngrediente int
	select @IdIngrediente = i.IdIngrediente
	from Ingrediente i
	where i.Nome = @NomeIngrediente

	update Pizza set Prezzo = (Prezzo + Prezzo*10/100) 
	from Pizza p join Composizione c on p.IdPizza=c.IdPizza
	where p.IdPizza = @IdPizza
	End try

	Begin catch
	select ERROR_LINE() as 'Riga', ERROR_MESSAGE()as 'Messaggio'
	End catch

End

execute IncrementaPizzaXIngrediente 'Carciofi'

--Funzioni:
--1. Tabella listino pizze (nome, prezzo) (parametri: nessuno)
create function MostraListino()
returns table
as 
return
select Nome, Prezzo
from Pizza
go

select * 
from dbo.MostraListino()

--2. Tabella listino pizze (nome, prezzo) contenenti un ingrediente (parametri: nome
--ingrediente)
create function MostraListinoPerIngrediente(
@NomeIngrediente nvarchar(50))
returns table
as 
return
select p.Nome, p.Prezzo
from Pizza p join Composizione c on p.IdPizza=c.IdPizza
             join Ingrediente i on c.IdIngrediente=i.IdIngrediente
where i.Nome=@NomeIngrediente
go

select * 
from dbo.MostraListinoPerIngrediente('Rucola')

--3. Tabella listino pizze (nome, prezzo) che non contengono un certo ingrediente
--(parametri: nome ingrediente)
create function MostraListinoSenzaIngrediente(
@NomeIngrediente nvarchar(50))
returns table
as 
return
select p.Nome, p.Prezzo
from Pizza p join Composizione c on p.IdPizza=c.IdPizza
             join Ingrediente i on c.IdIngrediente=i.IdIngrediente
where c.IdPizza not in (select c.IdPizza
			    	    from Composizione c join Ingrediente i on c.IdIngrediente = i.IdIngrediente
					    where i.Nome=@NomeIngrediente)
go

select distinct * 
from dbo.MostraListinoSenzaIngrediente('Mozzarella')

--4. Calcolo numero pizze contenenti un ingrediente (parametri: nome ingrediente)
Create function NumPizzeConIngrediente(
@NomeIngrediente nvarchar(50))
returns int
as 
begin

declare @numeroPizze int

select @numeroPizze=Count(*) 
from Pizza p join Composizione c on p.IdPizza=c.IdPizza
			 join Ingrediente i on c.IdIngrediente=i.IdIngrediente
where i.Nome=@NomeIngrediente

return @numeroPizze
end

select dbo.NumPizzeConIngrediente('Provola') as [Numero Pizze]

--5. Calcolo numero pizze che non contengono un ingrediente (parametri: codice
--ingrediente)
Create function NumPizzeSenzaIngrediente(
@IdIngrediente int)
returns int
as 
begin

declare @numeroPizze int

select @numeroPizze=Count(distinct p.IdPizza) 
from Pizza p join Composizione c on p.IdPizza=c.IdPizza
             join Ingrediente i on c.IdIngrediente=i.IdIngrediente
where c.IdPizza not in (select c.IdPizza
			    	    from Composizione c join Ingrediente i on c.IdIngrediente = i.IdIngrediente
					    where i.IdIngrediente=@IdIngrediente)

return @numeroPizze
end

select dbo.NumPizzeSenzaIngrediente(5) as [Numero Pizze]

--6. Calcolo numero ingredienti contenuti in una pizza (parametri: nome pizza)
create function NumIngredientiXPizza(
@NomePizza nvarchar (50))
returns int
as 
begin
declare @numeroIngredienti int

select @numeroIngredienti=Count(c.IdIngrediente)
from Composizione c join Pizza p on c.IdPizza=p.IdPizza
where p.Nome=@NomePizza

return @numeroIngredienti
end

select dbo.NumIngredientiXPizza('Margherita') as [Numero Ingredienti]


--View
--1. Realizzare una view che rappresenta il menù con tutte le pizze.
Create view ListinoPizze as
Select p.Nome, p.Prezzo, i.Nome as Ingredienti
from   Composizione c join Ingrediente i on c.IdIngrediente = i.IdIngrediente 
					  join Pizza p on c.IdPizza = p.IdPizza


select * from ListinoPizze

/*Opzionale: la vista deve restituire una tabella con prima colonna
contenente il nome della pizza, seconda colonna il prezzo e terza
colonna la lista unica di tutti gli ingredienti separati da virgola
*/
create view ListinoPizzeBellinetto as
select p.Nome, p.Prezzo,
	   stuff((select ', '+  i.Nome
	         from Ingrediente i, Composizione c
			 where i.IdIngrediente = c.IdIngrediente and p.IdPizza = c.IdPizza
			 order by p.IdPizza
			 for xml path('')), 1, 1, '') [Ingredienti]
from Pizza p
group by p.IdPizza, p.Nome, p.Prezzo


select * from ListinoPizzeBellinetto

