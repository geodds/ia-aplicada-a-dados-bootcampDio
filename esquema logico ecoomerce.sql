CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

CREATE TABLE cliente (
    idcliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    Nmeioinicial VARCHAR(3),
    sobrenome VARCHAR(100),
    email VARCHAR(100),
    cpf VARCHAR(14),
    data_nascimento DATE,
    endereco VARCHAR(200)
);

CREATE TABLE fornecedor (
    idfornecedor INT AUTO_INCREMENT PRIMARY KEY,
    razaoSocial VARCHAR(100) NOT NULL,
    ongi VARCHAR(45)
);

CREATE TABLE produto (
    idproduto INT AUTO_INCREMENT PRIMARY KEY,
    categoria VARCHAR(100),
    descricao VARCHAR(200),
    valor VARCHAR(45)
);

CREATE TABLE terceiro_vendedor (
    idterceiro_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(45) NOT NULL,
    local VARCHAR(45),
    nome_fantasia VARCHAR(100)
);

CREATE TABLE estoque (
    idestoque INT AUTO_INCREMENT PRIMARY KEY,
    localizacao VARCHAR(100) NOT NULL,
    descricao VARCHAR(200)
);

CREATE TABLE pedido (
    idpedido INT AUTO_INCREMENT PRIMARY KEY,
    status ENUM('Em processamento', 'Enviado', 'Entregue', 'Cancelado') NOT NULL,
    descricao VARCHAR(200),
    cliente_idcliente INT NOT NULL,
    frete FLOAT,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_idcliente) REFERENCES cliente(idcliente)
);

CREATE TABLE relacao_produto_pedido (
    pedido_idpedido INT NOT NULL,
    produto_idproduto INT NOT NULL,
    quantidade INT NOT NULL,
    status ENUM('Disponível', 'Esgotado', 'Em espera'),
    PRIMARY KEY (pedido_idpedido, produto_idproduto),
    FOREIGN KEY (pedido_idpedido) REFERENCES pedido(idpedido),
    FOREIGN KEY (produto_idproduto) REFERENCES produto(idproduto)
);

CREATE TABLE disponibiliza_produto (
    fornecedor_idfornecedor INT NOT NULL,
    produto_idproduto INT NOT NULL,
    PRIMARY KEY (fornecedor_idfornecedor, produto_idproduto),
    FOREIGN KEY (fornecedor_idfornecedor) REFERENCES fornecedor(idfornecedor),
    FOREIGN KEY (produto_idproduto) REFERENCES produto(idproduto)
);

CREATE TABLE estoque_has_produto (
    estoque_idestoque INT NOT NULL,
    produto_idproduto INT NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY (estoque_idestoque, produto_idproduto),
    FOREIGN KEY (estoque_idestoque) REFERENCES estoque(idestoque),
    FOREIGN KEY (produto_idproduto) REFERENCES produto(idproduto)
);

CREATE TABLE produtos_por_vendedor_terceiro (
    produto_idproduto INT NOT NULL,
    terceiro_vendedor_idterceiro_vendedor INT NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY (produto_idproduto, terceiro_vendedor_idterceiro_vendedor),
    FOREIGN KEY (produto_idproduto) REFERENCES produto(idproduto),
    FOREIGN KEY (terceiro_vendedor_idterceiro_vendedor) REFERENCES terceiro_vendedor(idterceiro_vendedor)
);


-- insercao de dados nas tabelas
INSERT INTO cliente (nome, Nmeioinicial, sobrenome, email, cpf, data_nascimento, endereco) VALUES
('João', 'S', 'Silva', 'joao.silva@email.com', '123.456.789-01', '1990-05-15', 'Rua A, 123 - Centro'),
('Maria', 'A', 'Santos', 'maria.santos@email.com', '987.654.321-09', '1985-08-20', 'Av. B, 456 - Jardim'),
('Pedro', 'M', 'Oliveira', 'pedro.oliveira@email.com', '456.789.123-45', '1995-03-10', 'Rua C, 789 - Vila Nova');

INSERT INTO fornecedor (razaoSocial, ongi) VALUES
('Fornecedor ABC Ltda', 'ONG123'),
('Distribuidora XYZ S/A', 'ONG456'),
('Indústria QWE EIRELI', 'ONG789');

INSERT INTO produto (categoria, descricao, valor) VALUES
('Eletrônicos', 'Smartphone Modelo X', '1200.00'),
('Eletrodomésticos', 'Geladeira Frost Free', '2500.00'),
('Móveis', 'Sofá 3 Lugares', '1800.00'),
('Informática', 'Notebook i7', '3500.00'),
('Vestuário', 'Camiseta Premium', '89.90');

INSERT INTO terceiro_vendedor (razao_social, local, nome_fantasia) VALUES
('Vendedor Externo 1 ME', 'São Paulo', 'Loja Virtual 1'),
('Comércio Eletrônico 2 Ltda', 'Rio de Janeiro', 'Mega Shop'),
('Distribuidora Digital 3', 'Minas Gerais', 'Tech Store');

INSERT INTO estoque (localizacao, descricao) VALUES
('Galpão A', 'Estoque Principal'),
('Galpão B', 'Estoque Secundário'),
('Centro de Distribuição', 'CD Regional');

INSERT INTO pedido (status, descricao, cliente_idcliente, frete) VALUES
('Entregue', 'Pedido de eletrônicos', 1, 15.00),
('Enviado', 'Móveis para casa', 2, 35.50),
('Em processamento', 'Itens diversos', 3, 12.75);

INSERT INTO relacao_produto_pedido (pedido_idpedido, produto_idproduto, quantidade, status) VALUES
(1, 1, 2, 'Disponível'),
(1, 4, 1, 'Disponível'),
(2, 3, 1, 'Disponível'),
(3, 2, 1, 'Disponível'),
(3, 5, 3, 'Disponível');

INSERT INTO disponibiliza_produto (fornecedor_idfornecedor, produto_idproduto) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5);

INSERT INTO estoque_has_produto (estoque_idestoque, produto_idproduto, quantidade) VALUES
(1, 1, 50),
(1, 2, 30),
(2, 3, 20),
(2, 4, 15),
(3, 5, 100);

INSERT INTO produtos_por_vendedor_terceiro (produto_idproduto, terceiro_vendedor_idterceiro_vendedor, quantidade) VALUES
(1, 1, 10),
(2, 1, 5),
(3, 2, 8),
(4, 2, 3),
(5, 3, 20);


-- algumas queries

SELECT * FROM cliente;
SELECT idproduto, descricao, valor FROM produto WHERE valor > 1000;
SELECT idpedido, data_pedido, frete FROM pedido WHERE status = 'Entregue';


SELECT * FROM produto WHERE categoria = 'Eletrônicos' AND valor < 1500;
SELECT * FROM pedido WHERE cliente_idcliente = 2;
SELECT p.descricao, ehp.quantidade FROM estoque_has_produto ehp JOIN produto p ON ehp.produto_idproduto = p.idproduto JOIN estoque e ON ehp.estoque_idestoque = e.idestoque WHERE e.localizacao = 'Galpão A' AND ehp.quantidade > 20;


SELECT p.idpedido, p.data_pedido, SUM(rpp.quantidade * pr.valor) AS valor_produtos, p.frete, SUM(rpp.quantidade * pr.valor) + p.frete AS valor_total FROM pedido p JOIN relacao_produto_pedido rpp ON p.idpedido = rpp.pedido_idpedido JOIN produto pr ON rpp.produto_idproduto = pr.idproduto GROUP BY p.idpedido;
SELECT categoria, AVG(valor) AS media_valor, COUNT(*) AS quantidade_produtos FROM produto GROUP BY categoria;


SELECT * FROM produto ORDER BY valor DESC;
SELECT nome, sobrenome, email FROM cliente ORDER BY nome, sobrenome;
SELECT idpedido, status, data_pedido FROM pedido ORDER BY data_pedido DESC, status;


SELECT categoria, COUNT(*) AS total_produtos FROM produto GROUP BY categoria HAVING COUNT(*) > 1;
SELECT tv.nome_fantasia, p.descricao, pv.quantidade FROM produtos_por_vendedor_terceiro pv JOIN terceiro_vendedor tv ON pv.terceiro_vendedor_idterceiro_vendedor = tv.idterceiro_vendedor JOIN produto p ON pv.produto_idproduto = p.idproduto GROUP BY tv.nome_fantasia, p.descricao, pv.quantidade HAVING pv.quantidade > 5;
SELECT f.razaoSocial, COUNT(dp.produto_idproduto) AS total_produtos FROM disponibiliza_produto dp JOIN fornecedor f ON dp.fornecedor_idfornecedor = f.idfornecedor GROUP BY f.razaoSocial HAVING COUNT(dp.produto_idproduto) > 1;


SELECT p.idpedido, p.status, p.data_pedido, CONCAT(c.nome, ' ', c.sobrenome) AS cliente, c.email FROM pedido p JOIN cliente c ON p.cliente_idcliente = c.idcliente;
SELECT p.descricao AS produto, tv.nome_fantasia AS vendedor, tv.local AS localizacao_vendedor, pv.quantidade AS estoque_disponivel FROM produtos_por_vendedor_terceiro pv JOIN produto p ON pv.produto_idproduto = p.idproduto JOIN terceiro_vendedor tv ON pv.terceiro_vendedor_idterceiro_vendedor = tv.idterceiro_vendedor;
SELECT p.descricao AS produto, e.localizacao, ehp.quantidade, p.valor, ehp.quantidade * p.valor AS valor_total_estoque FROM estoque_has_produto ehp JOIN produto p ON ehp.produto_idproduto = p.idproduto JOIN estoque e ON ehp.estoque_idestoque = e.idestoque ORDER BY e.localizacao, p.descricao;
SELECT f.razaoSocial AS fornecedor, p.descricao AS produto, p.categoria, p.valor FROM disponibiliza_produto dp JOIN fornecedor f ON dp.fornecedor_idfornecedor = f.idfornecedor JOIN produto p ON dp.produto_idproduto = p.idproduto ORDER BY f.razaoSocial, p.descricao;
