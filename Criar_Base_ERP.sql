SET NOCOUNT ON;
SET XACT_ABORT ON;

IF DB_ID(N'ERP_Treino') IS NULL
BEGIN
    CREATE DATABASE ERP_Treino;
END
GO

USE ERP_Treino;
GO

ALTER DATABASE ERP_Treino SET RECOVERY SIMPLE WITH NO_WAIT;
GO

IF OBJECT_ID(N'dbo.Clientes', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Clientes (
        ClienteId        INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Clientes PRIMARY KEY,
        Codigo           VARCHAR(20) NOT NULL,
        Nome             NVARCHAR(200) NOT NULL,
        Documento        VARCHAR(20) NULL,
        Email            NVARCHAR(254) NULL,
        Telefone         NVARCHAR(30) NULL,
        Ativo            BIT NOT NULL CONSTRAINT DF_Clientes_Ativo DEFAULT (1),
        CriadoEm         DATETIME2(0) NOT NULL CONSTRAINT DF_Clientes_CriadoEm DEFAULT (SYSUTCDATETIME()),
        AtualizadoEm     DATETIME2(0) NOT NULL CONSTRAINT DF_Clientes_AtualizadoEm DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT UQ_Clientes_Codigo UNIQUE (Codigo),
        CONSTRAINT CK_Clientes_Email CHECK (Email IS NULL OR Email LIKE N'%_@_%._%')
    );

    CREATE INDEX IX_Clientes_Nome ON dbo.Clientes (Nome);
END
GO

IF OBJECT_ID(N'dbo.Fornecedores', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Fornecedores (
        FornecedorId     INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Fornecedores PRIMARY KEY,
        Codigo           VARCHAR(20) NOT NULL,
        RazaoSocial      NVARCHAR(200) NOT NULL,
        Documento        VARCHAR(20) NULL,
        Email            NVARCHAR(254) NULL,
        Telefone         NVARCHAR(30) NULL,
        Ativo            BIT NOT NULL CONSTRAINT DF_Fornecedores_Ativo DEFAULT (1),
        CriadoEm         DATETIME2(0) NOT NULL CONSTRAINT DF_Fornecedores_CriadoEm DEFAULT (SYSUTCDATETIME()),
        AtualizadoEm     DATETIME2(0) NOT NULL CONSTRAINT DF_Fornecedores_AtualizadoEm DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT UQ_Fornecedores_Codigo UNIQUE (Codigo),
        CONSTRAINT CK_Fornecedores_Email CHECK (Email IS NULL OR Email LIKE N'%_@_%._%')
    );

    CREATE INDEX IX_Fornecedores_Razao ON dbo.Fornecedores (RazaoSocial);
END
GO

IF OBJECT_ID(N'dbo.Produtos', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Produtos (
        ProdutoId        INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Produtos PRIMARY KEY,
        SKU              VARCHAR(40) NOT NULL,
        Nome             NVARCHAR(200) NOT NULL,
        Unidade          VARCHAR(10) NOT NULL CONSTRAINT DF_Produtos_Unidade DEFAULT ('UN'),
        PrecoVenda       DECIMAL(18,2) NOT NULL CONSTRAINT DF_Produtos_PrecoVenda DEFAULT (0),
        CustoPadrao      DECIMAL(18,2) NOT NULL CONSTRAINT DF_Produtos_CustoPadrao DEFAULT (0),
        Ativo            BIT NOT NULL CONSTRAINT DF_Produtos_Ativo DEFAULT (1),
        CriadoEm         DATETIME2(0) NOT NULL CONSTRAINT DF_Produtos_CriadoEm DEFAULT (SYSUTCDATETIME()),
        AtualizadoEm     DATETIME2(0) NOT NULL CONSTRAINT DF_Produtos_AtualizadoEm DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT UQ_Produtos_SKU UNIQUE (SKU),
        CONSTRAINT CK_Produtos_Precos CHECK (PrecoVenda >= 0 AND CustoPadrao >= 0)
    );

    CREATE INDEX IX_Produtos_Nome ON dbo.Produtos (Nome);
END
GO

IF OBJECT_ID(N'dbo.Armazens', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Armazens (
        ArmazemId        INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Armazens PRIMARY KEY,
        Codigo           VARCHAR(20) NOT NULL,
        Nome             NVARCHAR(120) NOT NULL,
        Ativo            BIT NOT NULL CONSTRAINT DF_Armazens_Ativo DEFAULT (1),
        CriadoEm         DATETIME2(0) NOT NULL CONSTRAINT DF_Armazens_CriadoEm DEFAULT (SYSUTCDATETIME()),
        AtualizadoEm     DATETIME2(0) NOT NULL CONSTRAINT DF_Armazens_AtualizadoEm DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT UQ_Armazens_Codigo UNIQUE (Codigo)
    );
END
GO

IF OBJECT_ID(N'dbo.Estoques', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Estoques (
        EstoqueId        INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Estoques PRIMARY KEY,
        ProdutoId        INT NOT NULL,
        ArmazemId        INT NOT NULL,
        Quantidade       DECIMAL(18,3) NOT NULL CONSTRAINT DF_Estoques_Qtd DEFAULT (0),
        QuantidadeMin    DECIMAL(18,3) NOT NULL CONSTRAINT DF_Estoques_QtdMin DEFAULT (0),
        AtualizadoEm     DATETIME2(0) NOT NULL CONSTRAINT DF_Estoques_AtualizadoEm DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT FK_Estoques_Produtos FOREIGN KEY (ProdutoId) REFERENCES dbo.Produtos(ProdutoId),
        CONSTRAINT FK_Estoques_Armazens FOREIGN KEY (ArmazemId) REFERENCES dbo.Armazens(ArmazemId),
        CONSTRAINT UQ_Estoques_Produto_Armazem UNIQUE (ProdutoId, ArmazemId),
        CONSTRAINT CK_Estoques_Qtd CHECK (Quantidade >= 0 AND QuantidadeMin >= 0)
    );

    CREATE INDEX IX_Estoques_Produto ON dbo.Estoques (ProdutoId);
    CREATE INDEX IX_Estoques_Armazem ON dbo.Estoques (ArmazemId);
END
GO

IF OBJECT_ID(N'dbo.MovimentosEstoque', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.MovimentosEstoque (
        MovimentoId      BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_MovimentosEstoque PRIMARY KEY,
        ProdutoId        INT NOT NULL,
        ArmazemId        INT NOT NULL,
        Tipo             CHAR(1) NOT NULL, -- E=Entrada, S=Saída, A=Ajuste
        Quantidade       DECIMAL(18,3) NOT NULL,
        CustoUnitario    DECIMAL(18,2) NULL,
        Referencia       NVARCHAR(60) NULL,
        Observacao       NVARCHAR(400) NULL,
        CriadoEm         DATETIME2(0) NOT NULL CONSTRAINT DF_MovEst_CriadoEm DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT FK_MovEst_Produtos FOREIGN KEY (ProdutoId) REFERENCES dbo.Produtos(ProdutoId),
        CONSTRAINT FK_MovEst_Armazens FOREIGN KEY (ArmazemId) REFERENCES dbo.Armazens(ArmazemId),
        CONSTRAINT CK_MovEst_Tipo CHECK (Tipo IN ('E','S','A')),
        CONSTRAINT CK_MovEst_Qtd CHECK (Quantidade > 0),
        CONSTRAINT CK_MovEst_Custo CHECK (CustoUnitario IS NULL OR CustoUnitario >= 0)
    );

    CREATE INDEX IX_MovEst_Data ON dbo.MovimentosEstoque (CriadoEm DESC);
    CREATE INDEX IX_MovEst_ProdutoArmazem ON dbo.MovimentosEstoque (ProdutoId, ArmazemId, CriadoEm DESC);
END
GO

IF OBJECT_ID(N'dbo.PedidosVenda', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PedidosVenda (
        PedidoVendaId    INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PedidosVenda PRIMARY KEY,
        Numero           VARCHAR(30) NOT NULL,
        ClienteId        INT NOT NULL,
        Status           VARCHAR(12) NOT NULL CONSTRAINT DF_PV_Status DEFAULT ('ABERTO'),
        DataPedido       DATE NOT NULL CONSTRAINT DF_PV_Data DEFAULT (CONVERT(date, GETDATE())),
        TotalProdutos    DECIMAL(18,2) NOT NULL CONSTRAINT DF_PV_TotalProd DEFAULT (0),
        TotalPedido      AS (TotalProdutos) PERSISTED,
        CriadoEm         DATETIME2(0) NOT NULL CONSTRAINT DF_PV_CriadoEm DEFAULT (SYSUTCDATETIME()),
        AtualizadoEm     DATETIME2(0) NOT NULL CONSTRAINT DF_PV_AtualizadoEm DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT UQ_PedidosVenda_Numero UNIQUE (Numero),
        CONSTRAINT FK_PV_Clientes FOREIGN KEY (ClienteId) REFERENCES dbo.Clientes(ClienteId),
        CONSTRAINT CK_PV_Status CHECK (Status IN ('ABERTO','FATURADO','CANCELADO')),
        CONSTRAINT CK_PV_Total CHECK (TotalProdutos >= 0)
    );

    CREATE INDEX IX_PV_Cliente_Data ON dbo.PedidosVenda (ClienteId, DataPedido DESC);
END
GO

IF OBJECT_ID(N'dbo.PedidosVendaItens', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PedidosVendaItens (
        PedidoVendaItemId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PedidosVendaItens PRIMARY KEY,
        PedidoVendaId     INT NOT NULL,
        ProdutoId         INT NOT NULL,
        Quantidade        DECIMAL(18,3) NOT NULL,
        PrecoUnitario     DECIMAL(18,2) NOT NULL,
        TotalItem         AS (Quantidade * PrecoUnitario) PERSISTED,
        CONSTRAINT FK_PVI_PV FOREIGN KEY (PedidoVendaId) REFERENCES dbo.PedidosVenda(PedidoVendaId),
        CONSTRAINT FK_PVI_Produtos FOREIGN KEY (ProdutoId) REFERENCES dbo.Produtos(ProdutoId),
        CONSTRAINT CK_PVI_Qtd CHECK (Quantidade > 0),
        CONSTRAINT CK_PVI_Preco CHECK (PrecoUnitario >= 0)
    );

    CREATE INDEX IX_PVI_Pedido ON dbo.PedidosVendaItens (PedidoVendaId);
    CREATE INDEX IX_PVI_Produto ON dbo.PedidosVendaItens (ProdutoId);
END
GO

IF OBJECT_ID(N'dbo.Compras', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Compras (
        CompraId         INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Compras PRIMARY KEY,
        Numero           VARCHAR(30) NOT NULL,
        FornecedorId     INT NOT NULL,
        Status           VARCHAR(12) NOT NULL CONSTRAINT DF_OC_Status DEFAULT ('ABERTA'),
        DataCompra       DATE NOT NULL CONSTRAINT DF_OC_Data DEFAULT (CONVERT(date, GETDATE())),
        TotalProdutos    DECIMAL(18,2) NOT NULL CONSTRAINT DF_OC_TotalProd DEFAULT (0),
        TotalCompra      AS (TotalProdutos) PERSISTED,
        CriadoEm         DATETIME2(0) NOT NULL CONSTRAINT DF_OC_CriadoEm DEFAULT (SYSUTCDATETIME()),
        AtualizadoEm     DATETIME2(0) NOT NULL CONSTRAINT DF_OC_AtualizadoEm DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT UQ_Compras_Numero UNIQUE (Numero),
        CONSTRAINT FK_OC_Fornecedores FOREIGN KEY (FornecedorId) REFERENCES dbo.Fornecedores(FornecedorId),
        CONSTRAINT CK_OC_Status CHECK (Status IN ('ABERTA','RECEBIDA','CANCELADA')),
        CONSTRAINT CK_OC_Total CHECK (TotalProdutos >= 0)
    );

    CREATE INDEX IX_OC_Fornecedor_Data ON dbo.Compras (FornecedorId, DataCompra DESC);
END
GO

IF OBJECT_ID(N'dbo.ComprasItens', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ComprasItens (
        CompraItemId     INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ComprasItens PRIMARY KEY,
        CompraId         INT NOT NULL,
        ProdutoId        INT NOT NULL,
        Quantidade       DECIMAL(18,3) NOT NULL,
        CustoUnitario    DECIMAL(18,2) NOT NULL,
        TotalItem        AS (Quantidade * CustoUnitario) PERSISTED,
        CONSTRAINT FK_OCI_OC FOREIGN KEY (CompraId) REFERENCES dbo.Compras(CompraId),
        CONSTRAINT FK_OCI_Produtos FOREIGN KEY (ProdutoId) REFERENCES dbo.Produtos(ProdutoId),
        CONSTRAINT CK_OCI_Qtd CHECK (Quantidade > 0),
        CONSTRAINT CK_OCI_Custo CHECK (CustoUnitario >= 0)
    );

    CREATE INDEX IX_OCI_Compra ON dbo.ComprasItens (CompraId);
    CREATE INDEX IX_OCI_Produto ON dbo.ComprasItens (ProdutoId);
END
GO