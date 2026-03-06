-- 1. Arrumando a saúde da empresa: Multiplicando todas as Mensalidades por 8
UPDATE fato_financeiro SET valor = valor * 8 WHERE id_cc = 1;

-- 2. Criando o Vilão 1 (Goiânia - ID 2): Explosão de gastos com Obras/Reformas
UPDATE fato_financeiro SET valor = valor * 7 WHERE id_cc = 5 AND id_unidade = 2;

-- 3. Criando o Vilão 2 (Campo Grande - ID 5): Inchaço na Folha de Pagamento
UPDATE fato_financeiro SET valor = valor * 4 WHERE id_cc IN (3, 4) AND id_unidade = 5;
UPDATE fato_financeiro SET valor = valor * 0.5 WHERE id_cc = 1 AND id_unidade = 5;