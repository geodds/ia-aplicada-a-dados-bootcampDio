CREATE DATABASE IF NOT EXISTS oficina_mecanica;
USE oficina_mecanica;

-- Tabela Cliente
CREATE TABLE cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    telefone VARCHAR(20)
);

-- Tabela Veiculo
CREATE TABLE veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    tipo VARCHAR(30),
    placa VARCHAR(10) NOT NULL UNIQUE,
    cliente_idCliente INT NOT NULL,
    FOREIGN KEY (cliente_idCliente) REFERENCES cliente(idCliente)
);

-- Tabela Mecanico
CREATE TABLE mecanico (
    idMecanico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    funcao VARCHAR(50)
);

-- Tabela Equipe
CREATE TABLE equipe (
    idEquipe INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100)
);

-- Tabela Mecanico_Equipe (relacionamento muitos-para-muitos)
CREATE TABLE mecanico_equipe (
    mecanico_idMecanico INT NOT NULL,
    equipe_idEquipe INT NOT NULL,
    PRIMARY KEY (mecanico_idMecanico, equipe_idEquipe),
    FOREIGN KEY (mecanico_idMecanico) REFERENCES mecanico(idMecanico),
    FOREIGN KEY (equipe_idEquipe) REFERENCES equipe(idEquipe)
);

-- Tabela Peca
CREATE TABLE peca (
    idPeca INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    valor DECIMAL(10,2) NOT NULL
);

-- Tabela MaoDeObra
CREATE TABLE mao_de_obra (
    idMaoDeObra INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL,
    valor DECIMAL(10,2) NOT NULL
);

-- Tabela OrdemServico
CREATE TABLE ordem_servico (
    idOs INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(20) NOT NULL UNIQUE,
    status VARCHAR(30) NOT NULL,
    descricao TEXT,
    data_emissao DATE NOT NULL,
    data_entrega DATE,
    autorizacao_cliente BOOLEAN DEFAULT FALSE,
    valor_total DECIMAL(10,2),
    veiculo_idVeiculo INT NOT NULL,
    equipe_idEquipe INT NOT NULL,
    FOREIGN KEY (veiculo_idVeiculo) REFERENCES veiculo(idVeiculo),
    FOREIGN KEY (equipe_idEquipe) REFERENCES equipe(idEquipe)
);

-- Tabela OS_Peca (relacionamento muitos-para-muitos)
CREATE TABLE os_peca (
    os_idOs INT NOT NULL,
    peca_idPeca INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    PRIMARY KEY (os_idOs, peca_idPeca),
    FOREIGN KEY (os_idOs) REFERENCES ordem_servico(idOs),
    FOREIGN KEY (peca_idPeca) REFERENCES peca(idPeca)
);

-- Tabela OS_MaoDeObra (relacionamento muitos-para-muitos)
CREATE TABLE os_mao_de_obra (
    os_idOs INT NOT NULL,
    mao_de_obra_idMaoDeObra INT NOT NULL,
    PRIMARY KEY (os_idOs, mao_de_obra_idMaoDeObra),
    FOREIGN KEY (os_idOs) REFERENCES ordem_servico(idOs),
    FOREIGN KEY (mao_de_obra_idMaoDeObra) REFERENCES mao_de_obra(idMaoDeObra)
);

-- Inserindo clientes
INSERT INTO cliente (nome, endereco, telefone) VALUES
('João Silva', 'Rua A, 123 - Centro', '(11) 9999-8888'),
('Maria Santos', 'Av. B, 456 - Jardim', '(11) 7777-6666'),
('Carlos Oliveira', 'Rua C, 789 - Vila', '(11) 5555-4444');

-- Inserindo veículos
INSERT INTO veiculo (modelo, tipo, placa, cliente_idCliente) VALUES
('Fiat Uno', 'Hatch', 'ABC1234', 1),
('VW Gol', 'Hatch', 'DEF5678', 2),
('Chevrolet Onix', 'Sedan', 'GHI9012', 3);

-- Inserindo mecânicos
INSERT INTO mecanico (nome, endereco, funcao) VALUES
('Pedro Alves', 'Rua X, 100 - Centro', 'Mecânico Chefe'),
('Ana Costa', 'Av. Y, 200 - Jardim', 'Mecânico'),
('Lucas Pereira', 'Rua Z, 300 - Vila', 'Auxiliar');

-- Inserindo equipes
INSERT INTO equipe (descricao) VALUES
('Equipe Motor'),
('Equipe Elétrica'),
('Equipe Funilaria');

-- Associando mecânicos a equipes
INSERT INTO mecanico_equipe VALUES
(1, 1),
(2, 1),
(3, 2),
(2, 3);

-- Inserindo peças
INSERT INTO peca (nome, valor) VALUES
('Filtro de Óleo', 25.90),
('Pastilha de Freio', 120.50),
('Bateria', 350.00),
('Amortecedor', 280.75);

-- Inserindo mão de obra
INSERT INTO mao_de_obra (descricao, valor) VALUES
('Troca de óleo', 80.00),
('Alinhamento', 120.00),
('Balanceamento', 100.00),
('Reparo elétrico', 150.00);

-- Inserindo ordens de serviço
INSERT INTO ordem_servico (numero, status, descricao, data_emissao, data_entrega, autorizacao_cliente, veiculo_idVeiculo, equipe_idEquipe) VALUES
('OS-2023-001', 'Concluída', 'Troca de óleo e filtro', '2023-01-10', '2023-01-11', TRUE, 1, 1),
('OS-2023-002', 'Em andamento', 'Reparo no sistema elétrico', '2023-01-15', NULL, TRUE, 2, 2),
('OS-2023-003', 'Aguardando peças', 'Substituição de amortecedores', '2023-01-18', NULL, TRUE, 3, 1);

-- Associando peças às OS
INSERT INTO os_peca VALUES
(1, 1, 1),
(1, 2, 1),
(3, 4, 2);

-- Associando mão de obra às OS
INSERT INTO os_mao_de_obra VALUES
(1, 1),
(2, 4),
(3, 2),
(3, 3);

SELECT * FROM cliente;
SELECT idOs, numero, status FROM ordem_servico;
SELECT nome, valor FROM peca;

-- Clientes que moram no Centro
SELECT * FROM cliente WHERE endereco LIKE '%Centro%';

-- Ordens de serviço concluídas
SELECT * FROM ordem_servico WHERE status = 'Concluída';

-- Peças com valor acima de R$ 100
SELECT * FROM peca WHERE valor > 100;

-- Valor total estimado por OS (peças + mão de obra)
SELECT 
    os.idOs,
    os.numero,
    COALESCE(SUM(p.valor * op.quantidade), 0) AS total_pecas,
    COALESCE(SUM(m.valor), 0) AS total_mao_de_obra,
    COALESCE(SUM(p.valor * op.quantidade), 0) + COALESCE(SUM(m.valor), 0) AS valor_total
FROM ordem_servico os
LEFT JOIN os_peca op ON os.idOs = op.os_idOs
LEFT JOIN peca p ON op.peca_idPeca = p.idPeca
LEFT JOIN os_mao_de_obra om ON os.idOs = om.os_idOs
LEFT JOIN mao_de_obra m ON om.mao_de_obra_idMaoDeObra = m.idMaoDeObra
GROUP BY os.idOs, os.numero;

-- Média de valor das peças por tipo de veículo
SELECT 
    v.tipo,
    AVG(p.valor) AS media_valor_pecas
FROM veiculo v
JOIN ordem_servico os ON v.idVeiculo = os.veiculo_idVeiculo
JOIN os_peca op ON os.idOs = op.os_idOs
JOIN peca p ON op.peca_idPeca = p.idPeca
GROUP BY v.tipo;

-- Peças ordenadas pelo valor (decrescente)
SELECT * FROM peca ORDER BY valor DESC;

-- Ordens de serviço mais recentes primeiro
SELECT * FROM ordem_servico ORDER BY data_emissao DESC;

-- Mecânicos ordenados por função e nome
SELECT * FROM mecanico ORDER BY funcao, nome;

-- Clientes com mais de 1 veículo cadastrado
SELECT 
    c.nome,
    COUNT(v.idVeiculo) AS total_veiculos
FROM cliente c
JOIN veiculo v ON c.idCliente = v.cliente_idCliente
GROUP BY c.nome
HAVING COUNT(v.idVeiculo) > 1;

-- Equipes com mais de 2 mecânicos
SELECT 
    e.descricao,
    COUNT(me.mecanico_idMecanico) AS total_mecanicos
FROM equipe e
JOIN mecanico_equipe me ON e.idEquipe = me.equipe_idEquipe
GROUP BY e.descricao
HAVING COUNT(me.mecanico_idMecanico) > 2;

-- Peças utilizadas em mais de 1 OS
SELECT 
    p.nome,
    COUNT(op.os_idOs) AS vezes_utilizada
FROM peca p
JOIN os_peca op ON p.idPeca = op.peca_idPeca
GROUP BY p.nome
HAVING COUNT(op.os_idOs) > 1;

-- Lista completa de ordens de serviço com detalhes do cliente e veículo
SELECT 
    os.numero,
    os.status,
    os.data_emissao,
    c.nome AS cliente,
    v.modelo AS veiculo,
    v.placa
FROM ordem_servico os
JOIN veiculo v ON os.veiculo_idVeiculo = v.idVeiculo
JOIN cliente c ON v.cliente_idCliente = c.idCliente;

-- Detalhes de peças e mão de obra por OS
SELECT 
    os.numero,
    GROUP_CONCAT(p.nome SEPARATOR ', ') AS pecas_utilizadas,
    GROUP_CONCAT(m.descricao SEPARATOR ', ') AS servicos_realizados
FROM ordem_servico os
LEFT JOIN os_peca op ON os.idOs = op.os_idOs
LEFT JOIN peca p ON op.peca_idPeca = p.idPeca
LEFT JOIN os_mao_de_obra om ON os.idOs = om.os_idOs
LEFT JOIN mao_de_obra m ON om.mao_de_obra_idMaoDeObra = m.idMaoDeObra
GROUP BY os.numero;

-- Relação de mecânicos por equipe
SELECT 
    e.descricao AS equipe,
    GROUP_CONCAT(m.nome SEPARATOR ', ') AS mecanicos
FROM equipe e
JOIN mecanico_equipe me ON e.idEquipe = me.equipe_idEquipe
JOIN mecanico m ON me.mecanico_idMecanico = m.idMecanico
GROUP BY e.descricao;

-- Histórico de serviços por cliente
SELECT 
    c.nome AS cliente,
    v.modelo AS veiculo,
    os.numero AS os,
    os.status,
    os.data_emissao,
    os.data_entrega
FROM cliente c
JOIN veiculo v ON c.idCliente = v.cliente_idCliente
JOIN ordem_servico os ON v.idVeiculo = os.veiculo_idVeiculo
ORDER BY c.nome, os.data_emissao DESC;

