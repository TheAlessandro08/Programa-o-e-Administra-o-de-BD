USE ERP_Treino;

--Exercício 1
SELECT
	pv.PedidoVendaId,
	pv.Numero,
	pv.DataPedido,
	pv.TotalProdutos
FROM dbo.PedidosVenda AS pv
WHERE pv.TotalProdutos > (
	SELECT AVG(pv2.TotalProdutos)
	FROM dbo.PedidosVenda AS pv2
);

--Exercício 2
SELECT
	c.ClienteId,
	c.Nome	
FROM dbo.Clientes AS c
WHERE c.ClienteId IN(
	SELECT pv.ClienteId
	FROM dbo.PedidosVenda AS pv
	WHERE pv.Status='FATURADO'
);

--Exercício 3
SELECT
	c.ClienteId,
	c.Nome	
FROM dbo.Clientes AS c
WHERE c.ClienteId NOT IN(
	SELECT pv.ClienteId
	FROM dbo.PedidosVenda AS pv
	WHERE pv.Status='FATURADO'
);

--Exercício 4
SELECT
	p.ProdutoId,
	p.SKU,
	p.Nome,
	p.Unidade,
	p.PrecoVenda
FROM dbo.Produtos AS p
	WHERE p.PrecoVenda > ALL(
		SELECT p2.PrecoVenda
		FROM dbo.Produtos AS p2
		WHERE p2.Ativo=1
		 AND p2.Unidade='UN'
);

--Atividade 5
SELECT
	p.ProdutoId,
	p.SKU,
	p.Nome,
	p.Unidade,
	p.PrecoVenda
FROM dbo.Produtos AS p
	WHERE p.PrecoVenda > ANY(
		SELECT p2.PrecoVenda
		FROM dbo.Produtos AS p2
		WHERE p2.Ativo=1
		 AND p2.Unidade='UN'
);



