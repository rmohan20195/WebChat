USE [master]
GO
/****** Object:  Database [ChatDB]    Script Date: 11/19/2018 6:34:30 PM ******/
CREATE DATABASE [ChatDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ChatDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ChatDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ChatDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ChatDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [ChatDB] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ChatDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ChatDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ChatDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ChatDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ChatDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ChatDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [ChatDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ChatDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ChatDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ChatDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ChatDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ChatDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ChatDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ChatDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ChatDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ChatDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ChatDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ChatDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ChatDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ChatDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ChatDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ChatDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ChatDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ChatDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ChatDB] SET  MULTI_USER 
GO
ALTER DATABASE [ChatDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ChatDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ChatDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ChatDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ChatDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ChatDB] SET QUERY_STORE = OFF
GO
USE [ChatDB]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [ChatDB]
GO
/****** Object:  Table [dbo].[Friends]    Script Date: 11/19/2018 6:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Friends](
	[userid] [uniqueidentifier] NOT NULL,
	[friendid] [uniqueidentifier] NOT NULL,
	[active] [bit] NOT NULL,
 CONSTRAINT [PK_Friends] PRIMARY KEY CLUSTERED 
(
	[userid] ASC,
	[friendid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Messages]    Script Date: 11/19/2018 6:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Messages](
	[messageid] [uniqueidentifier] NOT NULL,
	[msgfrom] [uniqueidentifier] NOT NULL,
	[msgto] [uniqueidentifier] NOT NULL,
	[message] [nvarchar](max) NOT NULL,
	[delivered] [bit] NULL,
	[isviewd] [bit] NULL,
	[timestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED 
(
	[messageid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 11/19/2018 6:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[userid] [uniqueidentifier] NOT NULL,
	[email] [nvarchar](50) NOT NULL,
	[password] [nvarchar](50) NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[isactive] [bit] NOT NULL,
	[isonline] [bit] NULL,
	[code] [int] NULL,
	[image] [nvarchar](max) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[Friend_Add]    Script Date: 11/19/2018 6:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Friend_Add]
@userid uniqueidentifier,
@friendid uniqueidentifier
as
begin
	insert into Friends(userid,friendid,active)
		values(@userid,@friendid,1)
end
GO
/****** Object:  StoredProcedure [dbo].[Friends_GetAll]    Script Date: 11/19/2018 6:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Friends_GetAll]
@id uniqueidentifier
as
begin
	select  u.userid,
			u.username,
			u.email,
			u.isonline
	from Users u
		inner join Friends f
		on u.userid = f.userid
		where	u.userid = @id 
			and u.isactive = 1
end

GO
/****** Object:  StoredProcedure [dbo].[Message_GetChat]    Script Date: 11/19/2018 6:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Message_GetChat]
@userid uniqueidentifier,
@friendid uniqueidentifier
as
begin
	select 
		* 
	from Messages m
	where 
			(m.msgfrom = @userid or m.msgfrom = @friendid)
		and (m.msgto = @userid or m.msgto = @friendid)
end
GO
/****** Object:  StoredProcedure [dbo].[Message_Send]    Script Date: 11/19/2018 6:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Message_Send]
@from nvarchar(MAX),
@to nvarchar(MAX),
@message nvarchar(MAX),
@timestamp datetime
as
begin
	insert into Messages (msgfrom,msgto,message,delivered,isviewd,[timestamp])
		values(@from,@to,@message,1,0,@timestamp)
end
GO
/****** Object:  StoredProcedure [dbo].[User_Activate]    Script Date: 11/19/2018 6:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[User_Activate]
@id uniqueidentifier,
@code int
as
begin
	if exists(select 1 from Users where userid = @id and code = @code)
	begin
		update Users set isactive = 1 where userid = @id
	end
	else
	begin
		select 0;
	end
end
GO
/****** Object:  StoredProcedure [dbo].[User_ChangeImg]    Script Date: 11/19/2018 6:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[User_ChangeImg]
@image nvarchar(max),
@userid uniqueidentifier
as
begin
	update Users 
		set image = @image
		where userid = @userid
end
GO
/****** Object:  StoredProcedure [dbo].[User_Create]    Script Date: 11/19/2018 6:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[User_Create]
@email nvarchar(MAX),
@password nvarchar(MAX),
@username nvarchar(MAX),
@image nvarchar(MAX)
as
begin
	
	insert into Users(userid,email,password,username,isactive,isonline,code,image)
	values(newid(),@email,@password,@username,0,1,(select convert(numeric(6,0),rand() * 899999) + 100000),@image)
end
GO
/****** Object:  StoredProcedure [dbo].[User_Login]    Script Date: 11/19/2018 6:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[User_Login]
@username nvarchar(MAX),
@email nvarchar(MAX),
@password nvarchar(MAX)
as
begin
	select 
		* from Users u
	where	u.email = @email 
		or	u.username=@username
		and u.password=@password
end
GO
/****** Object:  StoredProcedure [dbo].[User_Search]    Script Date: 11/19/2018 6:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[User_Search]
@username nvarchar(max)
as
begin
	select 
		userid,
		username 	
		from Users 
	where userid = @username
end
GO
USE [master]
GO
ALTER DATABASE [ChatDB] SET  READ_WRITE 
GO
