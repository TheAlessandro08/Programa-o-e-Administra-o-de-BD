USE ERP_Treino;

--Prática 1

SELECT PedidoVendaId, COUNT(*)
FROM dbo.PedidosVendaItens
GROUP BY PedidoVendaId;

--Prática 2

SELECT
	C.Nome,
	SUM(pv.TotalProdutos) AS TotalFaturamentos
FROM dbo.Clientes AS c
INNER JOIN dbo.PedidosVenda AS pv
	ON c.ClienteId=pv.ClienteId
GROUP BY c.Nome;

--Prática 3

SELECT
	C.Nome,
	SUM(pv.TotalProdutos) AS TotalFaturamentos
FROM dbo.Clientes AS c
INNER JOIN dbo.PedidosVenda AS pv
	ON c.ClienteId=pv.ClienteId
GROUP BY c.Nome
HAVING SUM(pv.TotalProdutos)>10;

--Prática 4

SELECT
	c.Nome,
	pv.PedidoVendaId,
	AVG(pvi.PrecoUnitario) AS MediaPrecoUnitario
FROM dbo.Clientes AS c
INNER JOIN dbo.PedidosVenda AS pv
	ON c.ClienteId=pv.ClienteId
INNER JOIN dbo.PedidosVendaItens AS pvi
	ON pv.PedidoVendaId=pvi.PedidoVendaId
GROUP BY c.Nome, pv.PedidoVendaId;

--Exercício 1
--Liste o nome do cliente e a quantidade total de pedidos efetuados.
--Aplique um filtro para retornar apenas aqueles que fizeram mais de 2 pedidos no histórico.

SELECT
	c.Nome,
	COUNT(pv.TotalPedido)AS TotalPedido
FROM dbo.Clientes AS c
INNER JOIN dbo.PedidosVenda AS pv
	ON c.ClienteId=pv.ClienteId
GROUP BY c.Nome
HAVING count(pv.TotalPedido)>0;



