-- Corrigindo os lançamentos contábeis no banco de dados
UPDATE fato_financeiro SET tipo_movimento = 'Receita' WHERE id_cc IN (1, 2);
UPDATE fato_financeiro SET tipo_movimento = 'Despesa' WHERE id_cc IN (3, 4, 5, 6, 7);