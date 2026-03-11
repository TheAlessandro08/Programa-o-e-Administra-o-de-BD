USE ERP_Treino;
SET STATISTICS IO, TIME ON;

SELECT f.RazaoSocial
FROM dbo.Fornecedores f
WHERE EXISTS (
	SELECT 1
	FROM dbo.Compras c
	JOIN dbo.ComprasItens ci ON ci.CompraId=c.CompraId
	JOIN dbo.Estoques e ON e.ProdutoId=ci.ProdutoId
	WHERE c.FornecedorId=f.FornecedorId AND e.Quantidade<e.QuantidadeMin
);

SELECT f.RazaoSocial
FROM dbo.Fornecedores f
WHERE f.FornecedorId IN (
	SELECT c.FornecedorId
	FROM dbo.Compras c
	JOIN dbo.ComprasItens ci ON ci.CompraId=c.CompraId
	JOIN dbo.Estoques e ON e.ProdutoId=ci.ProdutoId
	WHERE e.Quantidade<e.QuantidadeMin
);

SELECT DISTINCT f.RazaoSocial
FROM dbo.Fornecedores f
	JOIN dbo.Compras c ON c.FornecedorId=f.FornecedorId
	JOIN dbo.ComprasItens ci ON ci.CompraId=c.CompraId
	JOIN dbo.Estoques e ON e.ProdutoId=ci.ProdutoId
WHERE e.Quantidade<e.QuantidadeMin;

