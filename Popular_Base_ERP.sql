USE ERP_Treino;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRAN;

    IF (SELECT COUNT(*) FROM dbo.Clientes) < 5
    BEGIN
        ;WITH src AS (
            SELECT * FROM (VALUES
                ('CLI0001', N'Cliente Alpha Ltda',  '11111111111',  N'alpha@skirr.com',  N'+55 11 99999-1001', 1),
                ('CLI0002', N'Cliente Beta ME',     '22222222222',  N'beta@skirr.com',   N'+55 11 99999-1002', 1),
                ('CLI0003', N'Cliente Gama SA',     '33333333333',  N'gama@skirr.com',   N'+55 11 99999-1003', 1),
                ('CLI0004', N'Cliente Delta EPP',   '44444444444',  N'delta@skirr.com',  N'+55 11 99999-1004', 1),
                ('CLI0005', N'Cliente Épsilon',     '55555555555',  N'epsilon@skirr.com',N'+55 11 99999-1005', 1)
            ) v(Codigo, Nome, Documento, Email, Telefone, Ativo)
        )
        INSERT INTO dbo.Clientes (Codigo, Nome, Documento, Email, Telefone, Ativo)
        SELECT s.Codigo, s.Nome, s.Documento, s.Email, s.Telefone, s.Ativo
        FROM src s
        WHERE NOT EXISTS (SELECT 1 FROM dbo.Clientes c WHERE c.Codigo = s.Codigo);
    END

    IF (SELECT COUNT(*) FROM dbo.Fornecedores) < 5
    BEGIN
        ;WITH src AS (
            SELECT * FROM (VALUES
                ('FOR0001', N'Fornecedor Aço Forte LTDA',    '12345678000199', N'acoforte@skirr.com',   N'+55 11 3333-2001', 1),
                ('FOR0002', N'Fornecedor Papel & Cia SA',    '22345678000199', N'papelcia@skirr.com',   N'+55 11 3333-2002', 1),
                ('FOR0003', N'Fornecedor Química Norte ME',  '32345678000199', N'quimicanorte@skirr.com',N'+55 11 3333-2003', 1),
                ('FOR0004', N'Fornecedor Tech Parts EPP',    '42345678000199', N'techparts@skirr.com',  N'+55 11 3333-2004', 1),
                ('FOR0005', N'Fornecedor Agro Sul LTDA',     '52345678000199', N'agrosul@skirr.com',    N'+55 11 3333-2005', 1)
            ) v(Codigo, RazaoSocial, Documento, Email, Telefone, Ativo)
        )
        INSERT INTO dbo.Fornecedores (Codigo, RazaoSocial, Documento, Email, Telefone, Ativo)
        SELECT s.Codigo, s.RazaoSocial, s.Documento, s.Email, s.Telefone, s.Ativo
        FROM src s
        WHERE NOT EXISTS (SELECT 1 FROM dbo.Fornecedores f WHERE f.Codigo = s.Codigo);
    END

    IF (SELECT COUNT(*) FROM dbo.Armazens) < 5
    BEGIN
        ;WITH src AS (
            SELECT * FROM (VALUES
                ('MATRIZ',  N'Armazém Matriz', 1),
                ('FILIAL1', N'Armazém Filial 1', 1),
                ('FILIAL2', N'Armazém Filial 2', 1),
                ('CD01',    N'Centro de Distribuição 01', 1),
                ('OUTLET',  N'Loja/Outlet', 1)
            ) v(Codigo, Nome, Ativo)
        )
        INSERT INTO dbo.Armazens (Codigo, Nome, Ativo)
        SELECT s.Codigo, s.Nome, s.Ativo
        FROM src s
        WHERE NOT EXISTS (SELECT 1 FROM dbo.Armazens a WHERE a.Codigo = s.Codigo);
    END

    IF (SELECT COUNT(*) FROM dbo.Produtos) < 5
    BEGIN
        ;WITH src AS (
            SELECT * FROM (VALUES
                ('SKU-001', N'Parafuso Aço 10mm', 'UN', CAST(1.50 AS DECIMAL(18,2)), CAST(0.60 AS DECIMAL(18,2)), 1),
                ('SKU-002', N'Porca Aço 10mm',    'UN', CAST(1.10 AS DECIMAL(18,2)), CAST(0.40 AS DECIMAL(18,2)), 1),
                ('SKU-003', N'Arruela 10mm',      'UN', CAST(0.35 AS DECIMAL(18,2)), CAST(0.10 AS DECIMAL(18,2)), 1),
                ('SKU-004', N'Tinta Acrílica 1L', 'UN', CAST(29.90 AS DECIMAL(18,2)),CAST(18.00 AS DECIMAL(18,2)),1),
                ('SKU-005', N'Cabo Elétrico 2,5mm','M', CAST(4.90 AS DECIMAL(18,2)), CAST(2.70 AS DECIMAL(18,2)), 1)
            ) v(SKU, Nome, Unidade, PrecoVenda, CustoPadrao, Ativo)
        )
        INSERT INTO dbo.Produtos (SKU, Nome, Unidade, PrecoVenda, CustoPadrao, Ativo)
        SELECT s.SKU, s.Nome, s.Unidade, s.PrecoVenda, s.CustoPadrao, s.Ativo
        FROM src s
        WHERE NOT EXISTS (SELECT 1 FROM dbo.Produtos p WHERE p.SKU = s.SKU);
    END

    IF (SELECT COUNT(*) FROM dbo.Estoques) < 5
    BEGIN
        ;WITH combos AS (
            SELECT TOP (5)
                p.ProdutoId,
                a.ArmazemId
            FROM dbo.Produtos p
            CROSS JOIN dbo.Armazens a
            ORDER BY p.ProdutoId, a.ArmazemId
        )
        INSERT INTO dbo.Estoques (ProdutoId, ArmazemId, Quantidade, QuantidadeMin)
        SELECT c.ProdutoId, c.ArmazemId, CAST(0 AS DECIMAL(18,3)), CAST(5 AS DECIMAL(18,3))
        FROM combos c
        WHERE NOT EXISTS (
            SELECT 1 FROM dbo.Estoques e
            WHERE e.ProdutoId = c.ProdutoId AND e.ArmazemId = c.ArmazemId
        );
    END

    IF (SELECT COUNT(*) FROM dbo.Compras) < 5
    BEGIN
        DECLARE @F1 INT = (SELECT TOP 1 FornecedorId FROM dbo.Fornecedores WHERE Codigo='FOR0001');
        DECLARE @F2 INT = (SELECT TOP 1 FornecedorId FROM dbo.Fornecedores WHERE Codigo='FOR0002');
        DECLARE @F3 INT = (SELECT TOP 1 FornecedorId FROM dbo.Fornecedores WHERE Codigo='FOR0003');
        DECLARE @F4 INT = (SELECT TOP 1 FornecedorId FROM dbo.Fornecedores WHERE Codigo='FOR0004');
        DECLARE @F5 INT = (SELECT TOP 1 FornecedorId FROM dbo.Fornecedores WHERE Codigo='FOR0005');

        ;WITH src AS (
            SELECT * FROM (VALUES
                ('OC-0001', @F1, 'RECEBIDA', CONVERT(date, DATEADD(day,-20,GETDATE())), CAST(0 AS DECIMAL(18,2))),
                ('OC-0002', @F2, 'RECEBIDA', CONVERT(date, DATEADD(day,-15,GETDATE())), CAST(0 AS DECIMAL(18,2))),
                ('OC-0003', @F3, 'RECEBIDA', CONVERT(date, DATEADD(day,-10,GETDATE())), CAST(0 AS DECIMAL(18,2))),
                ('OC-0004', @F4, 'ABERTA',   CONVERT(date, DATEADD(day,-5, GETDATE())), CAST(0 AS DECIMAL(18,2))),
                ('OC-0005', @F5, 'ABERTA',   CONVERT(date, DATEADD(day,-2, GETDATE())), CAST(0 AS DECIMAL(18,2)))
            ) v(Numero, FornecedorId, Status, DataCompra, TotalProdutos)
        )
        INSERT INTO dbo.Compras (Numero, FornecedorId, Status, DataCompra, TotalProdutos)
        SELECT s.Numero, s.FornecedorId, s.Status, s.DataCompra, s.TotalProdutos
        FROM src s
        WHERE s.FornecedorId IS NOT NULL
          AND NOT EXISTS (SELECT 1 FROM dbo.Compras c WHERE c.Numero = s.Numero);
    END

    IF (SELECT COUNT(*) FROM dbo.ComprasItens) < 5
    BEGIN
        DECLARE @OC1 INT = (SELECT TOP 1 CompraId FROM dbo.Compras WHERE Numero='OC-0001');
        DECLARE @OC2 INT = (SELECT TOP 1 CompraId FROM dbo.Compras WHERE Numero='OC-0002');
        DECLARE @OC3 INT = (SELECT TOP 1 CompraId FROM dbo.Compras WHERE Numero='OC-0003');
        DECLARE @OC4 INT = (SELECT TOP 1 CompraId FROM dbo.Compras WHERE Numero='OC-0004');
        DECLARE @OC5 INT = (SELECT TOP 1 CompraId FROM dbo.Compras WHERE Numero='OC-0005');

        DECLARE @P1 INT = (SELECT TOP 1 ProdutoId FROM dbo.Produtos WHERE SKU='SKU-001');
        DECLARE @P2 INT = (SELECT TOP 1 ProdutoId FROM dbo.Produtos WHERE SKU='SKU-002');
        DECLARE @P3 INT = (SELECT TOP 1 ProdutoId FROM dbo.Produtos WHERE SKU='SKU-003');
        DECLARE @P4 INT = (SELECT TOP 1 ProdutoId FROM dbo.Produtos WHERE SKU='SKU-004');
        DECLARE @P5 INT = (SELECT TOP 1 ProdutoId FROM dbo.Produtos WHERE SKU='SKU-005');

        ;WITH src AS (
            SELECT * FROM (VALUES
                (@OC1, @P1, CAST(100 AS DECIMAL(18,3)), CAST(0.60 AS DECIMAL(18,2))),
                (@OC2, @P2, CAST(120 AS DECIMAL(18,3)), CAST(0.40 AS DECIMAL(18,2))),
                (@OC3, @P3, CAST(300 AS DECIMAL(18,3)), CAST(0.10 AS DECIMAL(18,2))),
                (@OC4, @P4, CAST(20  AS DECIMAL(18,3)), CAST(18.00 AS DECIMAL(18,2))),
                (@OC5, @P5, CAST(200 AS DECIMAL(18,3)), CAST(2.70 AS DECIMAL(18,2)))
            ) v(CompraId, ProdutoId, Quantidade, CustoUnitario)
        )
        INSERT INTO dbo.ComprasItens (CompraId, ProdutoId, Quantidade, CustoUnitario)
        SELECT s.CompraId, s.ProdutoId, s.Quantidade, s.CustoUnitario
        FROM src s
        WHERE s.CompraId IS NOT NULL AND s.ProdutoId IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM dbo.ComprasItens ci
              WHERE ci.CompraId = s.CompraId AND ci.ProdutoId = s.ProdutoId
          );
    END

    UPDATE c
       SET c.TotalProdutos = x.Total
    FROM dbo.Compras c
    JOIN (
        SELECT CompraId, CAST(SUM(Quantidade * CustoUnitario) AS DECIMAL(18,2)) AS Total
        FROM dbo.ComprasItens
        GROUP BY CompraId
    ) x ON x.CompraId = c.CompraId;

    IF (SELECT COUNT(*) FROM dbo.PedidosVenda) < 5
    BEGIN
        DECLARE @C1 INT = (SELECT TOP 1 ClienteId FROM dbo.Clientes WHERE Codigo='CLI0001');
        DECLARE @C2 INT = (SELECT TOP 1 ClienteId FROM dbo.Clientes WHERE Codigo='CLI0002');
        DECLARE @C3 INT = (SELECT TOP 1 ClienteId FROM dbo.Clientes WHERE Codigo='CLI0003');
        DECLARE @C4 INT = (SELECT TOP 1 ClienteId FROM dbo.Clientes WHERE Codigo='CLI0004');
        DECLARE @C5 INT = (SELECT TOP 1 ClienteId FROM dbo.Clientes WHERE Codigo='CLI0005');

        ;WITH src AS (
            SELECT * FROM (VALUES
                ('PV-0001', @C1, 'FATURADO', CONVERT(date, DATEADD(day,-12,GETDATE())), CAST(0 AS DECIMAL(18,2))),
                ('PV-0002', @C2, 'FATURADO', CONVERT(date, DATEADD(day,-9, GETDATE())), CAST(0 AS DECIMAL(18,2))),
                ('PV-0003', @C3, 'ABERTO',   CONVERT(date, DATEADD(day,-4, GETDATE())), CAST(0 AS DECIMAL(18,2))),
                ('PV-0004', @C4, 'ABERTO',   CONVERT(date, DATEADD(day,-1, GETDATE())), CAST(0 AS DECIMAL(18,2))),
                ('PV-0005', @C5, 'CANCELADO',CONVERT(date, DATEADD(day,-3, GETDATE())), CAST(0 AS DECIMAL(18,2)))
            ) v(Numero, ClienteId, Status, DataPedido, TotalProdutos)
        )
        INSERT INTO dbo.PedidosVenda (Numero, ClienteId, Status, DataPedido, TotalProdutos)
        SELECT s.Numero, s.ClienteId, s.Status, s.DataPedido, s.TotalProdutos
        FROM src s
        WHERE s.ClienteId IS NOT NULL
          AND NOT EXISTS (SELECT 1 FROM dbo.PedidosVenda pv WHERE pv.Numero = s.Numero);
    END

    IF (SELECT COUNT(*) FROM dbo.PedidosVendaItens) < 5
    BEGIN
        DECLARE @PV1 INT = (SELECT TOP 1 PedidoVendaId FROM dbo.PedidosVenda WHERE Numero='PV-0001');
        DECLARE @PV2 INT = (SELECT TOP 1 PedidoVendaId FROM dbo.PedidosVenda WHERE Numero='PV-0002');
        DECLARE @PV3 INT = (SELECT TOP 1 PedidoVendaId FROM dbo.PedidosVenda WHERE Numero='PV-0003');
        DECLARE @PV4 INT = (SELECT TOP 1 PedidoVendaId FROM dbo.PedidosVenda WHERE Numero='PV-0004');

        DECLARE @P1v INT = (SELECT TOP 1 ProdutoId FROM dbo.Produtos WHERE SKU='SKU-001');
        DECLARE @P2v INT = (SELECT TOP 1 ProdutoId FROM dbo.Produtos WHERE SKU='SKU-002');
        DECLARE @P3v INT = (SELECT TOP 1 ProdutoId FROM dbo.Produtos WHERE SKU='SKU-003');
        DECLARE @P4v INT = (SELECT TOP 1 ProdutoId FROM dbo.Produtos WHERE SKU='SKU-004');
        DECLARE @P5v INT = (SELECT TOP 1 ProdutoId FROM dbo.Produtos WHERE SKU='SKU-005');

        ;WITH src AS (
            SELECT * FROM (VALUES
                (@PV1, @P1v, CAST(10 AS DECIMAL(18,3)), CAST(1.50 AS DECIMAL(18,2))),
                (@PV1, @P2v, CAST(5  AS DECIMAL(18,3)), CAST(1.10 AS DECIMAL(18,2))),
                (@PV2, @P4v, CAST(2  AS DECIMAL(18,3)), CAST(29.90 AS DECIMAL(18,2))),
                (@PV3, @P5v, CAST(30 AS DECIMAL(18,3)), CAST(4.90 AS DECIMAL(18,2))),
                (@PV4, @P3v, CAST(50 AS DECIMAL(18,3)), CAST(0.35 AS DECIMAL(18,2)))
            ) v(PedidoVendaId, ProdutoId, Quantidade, PrecoUnitario)
        )
        INSERT INTO dbo.PedidosVendaItens (PedidoVendaId, ProdutoId, Quantidade, PrecoUnitario)
        SELECT s.PedidoVendaId, s.ProdutoId, s.Quantidade, s.PrecoUnitario
        FROM src s
        WHERE s.PedidoVendaId IS NOT NULL AND s.ProdutoId IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM dbo.PedidosVendaItens pvi
              WHERE pvi.PedidoVendaId = s.PedidoVendaId AND pvi.ProdutoId = s.ProdutoId
          );
    END

    UPDATE pv
       SET pv.TotalProdutos = x.Total
    FROM dbo.PedidosVenda pv
    JOIN (
        SELECT PedidoVendaId, CAST(SUM(Quantidade * PrecoUnitario) AS DECIMAL(18,2)) AS Total
        FROM dbo.PedidosVendaItens
        GROUP BY PedidoVendaId
    ) x ON x.PedidoVendaId = pv.PedidoVendaId;

    IF (SELECT COUNT(*) FROM dbo.MovimentosEstoque) < 5
    BEGIN
        DECLARE @A1 INT = (SELECT TOP 1 ArmazemId FROM dbo.Armazens WHERE Codigo='MATRIZ');

        ;WITH base AS (
            SELECT TOP (5)
                ci.ProdutoId,
                @A1 AS ArmazemId,
                CAST('E' AS CHAR(1)) AS Tipo,
                ci.Quantidade,
                ci.CustoUnitario,
                CONCAT(N'OC:', c.Numero) AS Referencia,
                CONCAT(N'Entrada via compra ', c.Numero) AS Observacao
            FROM dbo.ComprasItens ci
            JOIN dbo.Compras c ON c.CompraId = ci.CompraId
            ORDER BY c.CompraId, ci.ProdutoId
        )
        INSERT INTO dbo.MovimentosEstoque (ProdutoId, ArmazemId, Tipo, Quantidade, CustoUnitario, Referencia, Observacao)
        SELECT b.ProdutoId, b.ArmazemId, b.Tipo, b.Quantidade, b.CustoUnitario, b.Referencia, b.Observacao
        FROM base b
        WHERE NOT EXISTS (
            SELECT 1 FROM dbo.MovimentosEstoque m
            WHERE m.Referencia = b.Referencia
              AND m.ProdutoId = b.ProdutoId
              AND m.ArmazemId = b.ArmazemId
              AND m.Tipo = b.Tipo
        );

        INSERT INTO dbo.Estoques (ProdutoId, ArmazemId, Quantidade, QuantidadeMin)
        SELECT DISTINCT m.ProdutoId, m.ArmazemId, CAST(0 AS DECIMAL(18,3)), CAST(5 AS DECIMAL(18,3))
        FROM dbo.MovimentosEstoque m
        WHERE m.ArmazemId = @A1
          AND NOT EXISTS (
              SELECT 1 FROM dbo.Estoques e
              WHERE e.ProdutoId = m.ProdutoId AND e.ArmazemId = m.ArmazemId
          );

        ;WITH mov AS (
            SELECT
                ProdutoId,
                ArmazemId,
                SUM(CASE Tipo WHEN 'S' THEN -Quantidade ELSE Quantidade END) AS Delta
            FROM dbo.MovimentosEstoque
            GROUP BY ProdutoId, ArmazemId
        )
        UPDATE e
           SET e.Quantidade = CASE WHEN (e.Quantidade + m.Delta) < 0 THEN 0 ELSE (e.Quantidade + m.Delta) END,
               e.AtualizadoEm = SYSUTCDATETIME()
        FROM dbo.Estoques e
        JOIN mov m
          ON m.ProdutoId = e.ProdutoId AND m.ArmazemId = e.ArmazemId;
    END

    COMMIT;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    THROW;
END CATCH
GO

SELECT 'Clientes'            AS Tabela, COUNT(*) AS Linhas FROM dbo.Clientes UNION ALL
SELECT 'Fornecedores',              COUNT(*) FROM dbo.Fornecedores UNION ALL
SELECT 'Produtos',                  COUNT(*) FROM dbo.Produtos UNION ALL
SELECT 'Armazens',                  COUNT(*) FROM dbo.Armazens UNION ALL
SELECT 'Estoques',                  COUNT(*) FROM dbo.Estoques UNION ALL
SELECT 'MovimentosEstoque',         COUNT(*) FROM dbo.MovimentosEstoque UNION ALL
SELECT 'PedidosVenda',              COUNT(*) FROM dbo.PedidosVenda UNION ALL
SELECT 'PedidosVendaItens',         COUNT(*) FROM dbo.PedidosVendaItens UNION ALL
SELECT 'Compras',                   COUNT(*) FROM dbo.Compras UNION ALL
SELECT 'ComprasItens',              COUNT(*) FROM dbo.ComprasItens;
GO