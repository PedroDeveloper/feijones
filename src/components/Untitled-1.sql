---------------------------------------------------------------------------
GO

/****** Object:  Table [Cliente]    Script Date: 4/13/2021 12:55:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Cliente](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Cnpj] [varchar](20) NULL,
	[Cpf] [varchar](20) NULL,
	[Nome] [varchar](250) NULL,
	[DtNas] [varchar](100) NULL,
	[RazaoSoci] [nvarchar](50) NULL,
	[Email] [varchar](100) NOT NULL,
	[Tel] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE UNIQUE INDEX foo ON cliente(cnpj) WHERE cnpj IS NOT NULL;
CREATE UNIQUE INDEX foo2 ON cliente(cpf) WHERE cpf IS NOT NULL;
---------------------------------------------------------------------------

GO

/****** Object:  Table [Endereco]    Script Date: 4/13/2021 9:42:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE Endereco(
	[ID_end] [int] IDENTITY(1,1) NOT NULL,
	[ID_cliente] [int] NULL,
	[Nome_end] [varchar](250) NOT NULL,
	[Tel_end] [varchar](15) NOT NULL,
	[Cep] [varchar](9) NOT NULL,
	[Endereco] [varchar](250) NOT NULL,
	[Numero] [varchar](15) NOT NULL,
	[Complemento] [varchar](100) NOT NULL,
	[Bairro] [varchar](50) NOT NULL,
	[Cidade] [varchar](50) NOT NULL,
	[Estado] [char](2) NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [Endereco]  WITH CHECK ADD  CONSTRAINT [FK_Endereco] FOREIGN KEY([ID_cliente])
REFERENCES [Cliente] ([ID])
ON DELETE CASCADE
GO

ALTER TABLE [Endereco] CHECK CONSTRAINT [FK_Endereco]
GO

