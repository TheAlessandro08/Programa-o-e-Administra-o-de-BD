USE ERP_Treino;

SELECT
	c.ClienteId,
	c.Nome,
	p.Numero AS NumeroPedido,
	p.DataPedido,
	p.TotalProdutos
FROM dbo.Clientes AS c
INNER JOIN dbo.PedidosVenda AS p
	ON c.ClienteId = p.ClienteId;

--Exercício 1
SELECT
	c.ClienteId,
	c.Nome,
	p.Status,
	p.DataPedido,	
FROM dbo.Clientes AS c
INNER JOIN dbo.PedidosVenda AS p
	ON c.ClienteId = p.ClienteId;

--Exercício 2
SELECT
    pv.PedidoVendaId,
    c.Nome,
    pv.TotalProdutos    
FROM dbo.PedidosVenda AS pv
INNER JOIN dbo.Clientes AS c
    ON pv.ClienteId = c.ClienteId
WHERE pv.TotalProdutos > 500;

--Exercício 3
SELECT
	pr.Nome AS Produto,
	c.Nome AS NomeCliente
FROM dbo.Clientes AS c
INNER JOIN dbo.PedidosVenda AS pv
	ON c.ClienteId = pv.ClienteId
INNER JOIN dbo.PedidosVendaItens AS ipv
	ON pv.PedidoVendaId = ipv.PedidoVendaId
INNER JOIN dbo.Produtos AS pr
	ON pr.ProdutoId = pr.ProdutoId;

--Exercício 4
SELECT
	c.Nome AS NomeCliente,
	COUNT(pv.PedidoVendaId) AS QuantidadePedidos
FROM dbo.Clientes AS c
INNER JOIN dbo.PedidosVenda AS pv 
	ON c.ClienteId=pv.ClienteId
GROUP BY c.Nome HAVING COUNT(pv.PedidoVendaId)>3;





