-- 1. CRIANDO OS CAMPUS HERÓIS (Brasília - 1 e Centro Esportivo - 3)
-- Multiplicamos as receitas deles por 6 (salas cheias, mensalidades altas)
UPDATE fato_financeiro 
SET valor = valor * 6 
WHERE tipo_movimento = 'Receita' AND id_unidade IN (1, 3);

-- Cortamos as despesas operacionais deles pela metade (alta eficiência)
UPDATE fato_financeiro 
SET valor = valor * 0.4 
WHERE tipo_movimento = 'Despesa' AND id_unidade IN (1, 3);

-- 2. ENXUGANDO A SEDE ADMINISTRATIVA (ID 4)
-- A Sede não vende cursos, mas gasta muito. Vamos reduzir o custo da diretoria.
UPDATE fato_financeiro 
SET valor = valor * 0.3 
WHERE tipo_movimento = 'Despesa' AND id_unidade = 4;