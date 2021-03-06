USE [master]
GO
/****** Object:  Database [PizzeriaDaLuigi]    Script Date: 17-Dec-21 03:08:28 PM ******/
CREATE DATABASE [PizzeriaDaLuigi]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PizzeriaDaLuigi', FILENAME = N'C:\Users\martina.mattana\PizzeriaDaLuigi.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PizzeriaDaLuigi_log', FILENAME = N'C:\Users\martina.mattana\PizzeriaDaLuigi_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [PizzeriaDaLuigi] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PizzeriaDaLuigi].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ARITHABORT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET  MULTI_USER 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PizzeriaDaLuigi] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PizzeriaDaLuigi] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [PizzeriaDaLuigi] SET QUERY_STORE = OFF
GO
USE [PizzeriaDaLuigi]
GO
/****** Object:  UserDefinedFunction [dbo].[NumIngredientiXPizza]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[NumIngredientiXPizza](
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
GO
/****** Object:  UserDefinedFunction [dbo].[NumPizzeConIngrediente]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[NumPizzeConIngrediente](
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
GO
/****** Object:  UserDefinedFunction [dbo].[NumPizzeSenzaIngrediente]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[NumPizzeSenzaIngrediente](
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
GO
/****** Object:  Table [dbo].[Pizza]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pizza](
	[IdPizza] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [nvarchar](50) NOT NULL,
	[Prezzo] [decimal](5, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPizza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[MostraListino]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[MostraListino]()
returns table
as 
return
select Nome, Prezzo
from Pizza
GO
/****** Object:  Table [dbo].[Ingrediente]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ingrediente](
	[IdIngrediente] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [nvarchar](50) NOT NULL,
	[Costo] [decimal](5, 2) NOT NULL,
	[QtaMagazzino] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Composizione]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Composizione](
	[IdPizza] [int] NOT NULL,
	[IdIngrediente] [int] NOT NULL,
 CONSTRAINT [PK_Composizione] PRIMARY KEY CLUSTERED 
(
	[IdPizza] ASC,
	[IdIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[MostraListinoPerIngrediente]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[MostraListinoPerIngrediente](
@NomeIngrediente nvarchar(50))
returns table
as 
return
select p.Nome, p.Prezzo
from Pizza p join Composizione c on p.IdPizza=c.IdPizza
             join Ingrediente i on c.IdIngrediente=i.IdIngrediente
where i.Nome=@NomeIngrediente
GO
/****** Object:  UserDefinedFunction [dbo].[MostraListinoSenzaIngrediente]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[MostraListinoSenzaIngrediente](
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
GO
/****** Object:  View [dbo].[ListinoPizze]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[ListinoPizze] AS
Select p.Nome, p.Prezzo, i.Nome as Ingredienti
from   Composizione c join Ingrediente i on c.IdIngrediente = i.IdIngrediente 
					  join Pizza p on c.IdPizza = p.IdPizza
GO
/****** Object:  View [dbo].[ListinoPizzeBellinetto]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[ListinoPizzeBellinetto] AS
select p.Nome, p.Prezzo,
	   stuff((select ', '+  i.Nome
	         from Ingrediente i, Composizione c
			 where i.IdIngrediente = c.IdIngrediente and p.IdPizza = c.IdPizza
			 order by p.IdPizza
			 for xml path('')), 1, 1, '') [Ingredienti]
from Pizza p
group by p.IdPizza, p.Nome, p.Prezzo

GO
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (1, 1)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (1, 2)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (2, 1)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (2, 3)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (3, 1)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (3, 2)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (3, 4)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (4, 1)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (4, 2)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (4, 5)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (4, 6)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (4, 7)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (4, 8)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (5, 1)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (5, 2)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (5, 9)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (6, 1)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (6, 2)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (6, 11)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (6, 12)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (6, 13)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (7, 1)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (7, 2)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (7, 14)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (8, 2)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (8, 15)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (8, 16)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (9, 2)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (9, 17)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (9, 18)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (10, 2)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (10, 13)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (10, 19)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (10, 20)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (11, 2)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (11, 21)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (11, 22)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (12, 2)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (12, 12)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (12, 23)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (13, 1)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (13, 2)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (13, 16)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (13, 24)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (14, 1)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (14, 2)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (14, 15)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (14, 16)
INSERT [dbo].[Composizione] ([IdPizza], [IdIngrediente]) VALUES (14, 24)
GO
SET IDENTITY_INSERT [dbo].[Ingrediente] ON 

INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (1, N'Pomodoro', CAST(2.00 AS Decimal(5, 2)), 100)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (2, N'Mozzarella', CAST(1.50 AS Decimal(5, 2)), 50)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (3, N'Mozzarella di bufala', CAST(3.00 AS Decimal(5, 2)), 20)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (4, N'Spianata piccante', CAST(5.00 AS Decimal(5, 2)), 50)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (5, N'Funghi', CAST(1.00 AS Decimal(5, 2)), 100)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (6, N'Carciofi', CAST(1.50 AS Decimal(5, 2)), 30)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (7, N'Prosciutto cotto', CAST(1.50 AS Decimal(5, 2)), 300)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (8, N'Olive', CAST(1.00 AS Decimal(5, 2)), 50)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (9, N'Funghi porcini', CAST(1.50 AS Decimal(5, 2)), 30)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (10, N'Stracchino', CAST(2.50 AS Decimal(5, 2)), 100)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (11, N'Speck', CAST(3.00 AS Decimal(5, 2)), 150)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (12, N'Rucola', CAST(2.00 AS Decimal(5, 2)), 200)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (13, N'Grana', CAST(1.50 AS Decimal(5, 2)), 250)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (14, N'Verdure', CAST(0.80 AS Decimal(5, 2)), 1000)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (15, N'Patate', CAST(1.00 AS Decimal(5, 2)), 550)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (16, N'Salsiccia', CAST(2.50 AS Decimal(5, 2)), 300)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (17, N'Ricotta', CAST(2.00 AS Decimal(5, 2)), 200)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (18, N'Pomodorini', CAST(1.00 AS Decimal(5, 2)), 250)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (19, N'Provola', CAST(1.20 AS Decimal(5, 2)), 100)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (20, N'Gorgonzola', CAST(2.00 AS Decimal(5, 2)), 100)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (21, N'Pomodoro fresco', CAST(1.50 AS Decimal(5, 2)), 800)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (22, N'Basilico', CAST(0.50 AS Decimal(5, 2)), 200)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (23, N'Bresaola', CAST(2.50 AS Decimal(5, 2)), 150)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [Nome], [Costo], [QtaMagazzino]) VALUES (24, N'Pecorino', CAST(1.50 AS Decimal(5, 2)), 250)
SET IDENTITY_INSERT [dbo].[Ingrediente] OFF
GO
SET IDENTITY_INSERT [dbo].[Pizza] ON 

INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (1, N'Margherita', CAST(5.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (2, N'Bufala', CAST(7.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (3, N'Diavola', CAST(6.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (4, N'Quattro Stagioni', CAST(7.15 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (5, N'Porcini', CAST(7.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (6, N'Dioniso', CAST(8.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (7, N'Ortolana', CAST(8.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (8, N'Patate e Salsiccia', CAST(6.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (9, N'Pomodorini', CAST(6.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (10, N'Quattro Formaggi', CAST(7.50 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (11, N'Caprese', CAST(6.50 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (12, N'Zeus', CAST(7.50 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (13, N'Sarda', CAST(7.00 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [Nome], [Prezzo]) VALUES (14, N'Gennargentu', CAST(8.50 AS Decimal(5, 2)))
SET IDENTITY_INSERT [dbo].[Pizza] OFF
GO
ALTER TABLE [dbo].[Composizione]  WITH CHECK ADD FOREIGN KEY([IdIngrediente])
REFERENCES [dbo].[Ingrediente] ([IdIngrediente])
GO
ALTER TABLE [dbo].[Composizione]  WITH CHECK ADD FOREIGN KEY([IdPizza])
REFERENCES [dbo].[Pizza] ([IdPizza])
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD CHECK  (([Costo]>(0)))
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD CHECK  (([QtaMagazzino]>=(0)))
GO
ALTER TABLE [dbo].[Pizza]  WITH CHECK ADD CHECK  (([Prezzo]>(0)))
GO
/****** Object:  StoredProcedure [dbo].[AggiornaPrezzoPizza]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[AggiornaPrezzoPizza]
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
GO
/****** Object:  StoredProcedure [dbo].[EliminaIngredienteXPizza]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[EliminaIngredienteXPizza]
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
GO
/****** Object:  StoredProcedure [dbo].[IncrementaPizzaXIngrediente]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[IncrementaPizzaXIngrediente]
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
GO
/****** Object:  StoredProcedure [dbo].[InserisciIngredienteXPizza]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[InserisciIngredienteXPizza]
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
GO
/****** Object:  StoredProcedure [dbo].[InserisciPizza]    Script Date: 17-Dec-21 03:08:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[InserisciPizza]
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
GO
USE [master]
GO
ALTER DATABASE [PizzeriaDaLuigi] SET  READ_WRITE 
GO
