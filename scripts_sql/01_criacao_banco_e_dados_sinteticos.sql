-- ==============================================================================
-- 0. LIMPANDO O TERRENO (Para evitar erro de "Tabela já existe")
-- ==============================================================================
DROP VIEW IF EXISTS vw_dados_financeiros_bi;
DROP TABLE IF EXISTS fato_financeiro;
DROP TABLE IF EXISTS dim_centro_custo;
DROP TABLE IF EXISTS dim_unidade;

-- ==============================================================================
-- 1. CRIAÇÃO DAS TABELAS (STAR SCHEMA)
-- ==============================================================================

CREATE TABLE dim_unidade (
    id_unidade SERIAL PRIMARY KEY,
    nome_unidade VARCHAR(100),
    tipo_unidade VARCHAR(50),
    estado VARCHAR(2)
);

CREATE TABLE dim_centro_custo (
    id_cc SERIAL PRIMARY KEY,
    nome_cc VARCHAR(100),
    grupo_custo VARCHAR(50)
);

CREATE TABLE fato_financeiro (
    id_lancamento SERIAL PRIMARY KEY,
    data_lancamento DATE,
    id_unidade INT REFERENCES dim_unidade(id_unidade),
    id_cc INT REFERENCES dim_centro_custo(id_cc),
    tipo_movimento VARCHAR(20),
    valor NUMERIC(15, 2)
);

-- ==============================================================================
-- 2. INSERÇÃO DE DADOS MESTRE (LUMINA GROUP)
-- ==============================================================================

INSERT INTO dim_unidade (nome_unidade, tipo_unidade, estado) VALUES
('Campus Lumina Brasília', 'Educação Básica', 'DF'),
('Instituto Lumina Goiânia', 'Educação Básica', 'GO'),
('Sede Administrativa Central', 'Administração', 'DF'),
('Centro Esportivo Lumina', 'Eventos e Esportes', 'MT'),
('Campus Lumina Campo Grande', 'Educação Básica', 'MS');

INSERT INTO dim_centro_custo (nome_cc, grupo_custo) VALUES
('Mensalidades e Matrículas', 'Receita Operacional'),
('Eventos e Locações', 'Receita Institucional'),
('Folha de Pagamento (Docentes)', 'Despesa com Pessoal'),
('Folha de Pagamento (Admin)', 'Despesa com Pessoal'),
('Reformas e Novas Construções', 'CAPEX (Infraestrutura)'),
('Manutenção Predial e Limpeza', 'Despesa Operacional Fixa'),
('Energia, Água e Internet', 'Despesa Operacional Fixa');

-- ==============================================================================
-- 3. GERAÇÃO DE DADOS SINTÉTICOS (FATOS) 
-- ==============================================================================

INSERT INTO fato_financeiro (data_lancamento, id_unidade, id_cc, tipo_movimento, valor)
SELECT 
    data_gen::date AS data_lancamento,
    (random() * 4 + 1)::int AS id_unidade, 
    (random() * 6 + 1)::int AS id_cc,      
    CASE 
        WHEN (random() * 6 + 1)::int IN (1, 2) THEN 'Receita' 
        ELSE 'Despesa' 
    END AS tipo_movimento,
    CASE 
        WHEN (random() * 6 + 1)::int = 5 THEN ROUND((random() * 50000 + 10000)::numeric, 2) 
        WHEN (random() * 6 + 1)::int IN (3, 4) THEN ROUND((random() * 20000 + 5000)::numeric, 2) 
        ELSE ROUND((random() * 5000 + 500)::numeric, 2) 
    END AS valor
FROM generate_series('2024-01-01'::timestamp, '2025-12-31'::timestamp, '12 hours'::interval) AS data_gen;

-- ==============================================================================
-- 4. CRIAÇÃO DA VIEW (A CAMADA DE CONSUMO DO BI)
-- ==============================================================================

CREATE OR REPLACE VIEW vw_dados_financeiros_bi AS
SELECT 
    f.id_lancamento,
    f.data_lancamento,
    u.nome_unidade,
    u.estado,
    c.nome_cc,
    c.grupo_custo,
    f.tipo_movimento,
    f.valor
FROM fato_financeiro f
INNER JOIN dim_unidade u ON f.id_unidade = u.id_unidade
INNER JOIN dim_centro_custo c ON f.id_cc = c.id_cc;