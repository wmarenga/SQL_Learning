/* TRABALHANDO COM DATESTYLE*/

SHOW DATESTYLE;

/* ALTERANDO O DATESTYLE:
1) IR NA PASTA C:\Program Files\PostgreSQL\15\data;
2) ABRIR O ARQUIVO postgresql.conf com notepad ++;
3) LOCALIZAR NA BUSCA DO NOTEPAD++ datestyle;
4) ANTES DE ALTERAR O PARÂMETRO datestyle = 'iso, mdy', 
CRIAR UMA COPIAR NA LINHA ABAIXO COM ASTERÍSTICO (COMENTÁRIO) #datestyle = 'iso, mdy';
<SALVAR>
5) ABRIR OS SERVIÇOS DO WINDOWS: LOPA/ SERVICES;
6) LOCALIZAR "postgresql-x64-15 - PostgreSQL Server 15" E CLICAR EM RESTART SERVICE.
7) BOTÃO DIREITO NO BANCO/ REFRESH.
8) SE O BANCO ESTIVER DESCONECTADO, CONECTÁ-LO NOVAMENTE.
*/

/* ABRINDO UM ARQUIVO SQL:
1) CLICAR EM OPEN FILE;
2) CLICAR EM EXECUTE/ REFRESH F5;
3) VERIFICAR EM data_science/ Schemas/ public/ Tables;
4) PODEMOS ABRIR OUTRAS "QUERY TOOL" PARA TRABALHAR EM PARALELO.
*/
/*FUNÇOES DE AGREGACAO*/

/*Query simples*/

select * from funcionarios;
select * from departamentos;

/* Contando o numero de ocorrencias */

select count(*) from funcionarios;
select count(*) from departamentos;
select count(*) from localizacao;

/* Agrupando por sexo com group by */

select count(*) from funcionarios
group by sexo;

/* colocando o nome da coluna */

select sexo, count(*) as "Quantidade" from funcionarios
group by sexo;

SELECT DIVISAO, COUNT(*) AS QUANTIDADE FROM DEPARTAMENTOS
GROUP BY DIVISAO;

/* mostrando o numero de funcionarios em cada departamento */

select departamento, count(*) AS QUANTIDADE
from funcionarios
group by departamento;

/* Exibindo o maximo de salarios - 149929 */

SELECT SALARIO FROM FUNCIONARIOS;

-- MOSTRA O MAIOR VALOR DA COLUNA SALARIO.
select max(salario) as "SALARIO MAXIMO" from funcionarios;

/* Exibindo o minimo de salarios - 40138 */

-- MOSTRA O MENOR VALOR DA COLUNA SALARIO.
select min(salario) as "SALARIO MENOR" from funcionarios;

/* Exibindo o máximo e o mínimo juntos */

-- MOSTRA (PROJETA) O MAIOR E MENOR VALORES EM COLUNAS DISTINTAS.
select min(salario) as "SALARIO MINIMO", max(salario) as "SALARIO MAXIMO"
from funcionarios;

/* Exibindo o máximo e o mínimo de cada departamento */

-- SÓ ACEITA ASPAS DUPLAS "SALARIO_MIN".
select departamento, min(salario) AS "SALARIO_MIN", max(salario) AS "SALARIO_MAX"
from funcionarios
group by departamento;

/* Exibindo o máximo e o mínimo por sexo */

select sexo, min(salario) AS "SALARIO_MIN", max(salario) AS "SALARIO_MAX"
from funcionarios
group by sexo;

/*Estatisticas*/

/* Mostrando uma quantidade limitada de linhas */
select * from funcionarios
limit 10;

/* Qual o gasto total de salario pago pela empresa? */
select sum(salario) from funcionarios;

-- Mudando o tipo monetário para dolar.
SET lc_monetary = 'EN_US';
select CAST(sum(salario) AS MONEY) from funcionarios;

-- Mudando o tipo monetário para Euro.
SET lc_monetary = 'EU_BE';
select CAST(sum(salario) AS MONEY) from funcionarios;

/* Qual o montante total que cada departamento recebe de salario */
SET lc_monetary = 'EU_BE';
select departamento, CAST(sum(salario) AS MONEY)
from funcionarios
group by departamento;

/* Por departamento, qual o total e a média paga para
os funcionarios? */

SET lc_monetary = 'EU_BE';
select CAST(sum(salario) AS MONEY), CAST(avg(salario) AS MONEY)
from funcionarios;

SET lc_monetary = 'EU_BE';
select departamento, CAST(sum(salario) AS MONEY), CAST(avg(salario) AS MONEY)
from funcionarios
group by departamento;

/*ordenando*/
select departamento, CAST(sum(salario) AS MONEY), CAST(avg(salario) AS MONEY)
from funcionarios
group by departamento
order by 3;

select departamento, CAST(sum(salario) AS MONEY), CAST(avg(salario) AS MONEY)
from funcionarios
group by departamento
order by 3 ASC;

select departamento, CAST(sum(salario) AS MONEY), CAST(avg(salario) AS MONEY)
from funcionarios
group by departamento
order by 3 DESC;

/* REFLEXÃO SOBRE ESTATÍSTICA 
Concorrendo a vagas de Cientista de Dados Junior, você recebe propostas de 3 empresas.

A tabela a seguir mostra a média salarial das 3 empresas em questão:

Empresa      |  Média Salarial
Empresa A    |   R$ 3060.00
Empresa B    |   R$ 4160.00
Empresa C    |   R$ 2640.00

Qual a sua escolha?
Considere que você gostou das 3 empresas igualmente, considerando o ambiente de trabalho,
carga horária, localização e etc.

Lista dos Salários por Funcionários das 3 Empresas:

Empresa    |   Func 01  |   Func 02  |     Func 03    |   Func 04  |   Func 05   |   Média    |   Mediana
Empresa A  | R$ 2000.00 | R$ 2700.00 | **R$ 2800.00** | R$ 3700.00 | R$  4100.00 | R$ 3060.00 | R$ 2800.00
Empresa B  | R$ 1000.00 | R$ 1000.00 | **R$ 1300.00** | R$ 1500.00 | R$ 16000.00 | R$ 4160.00 | R$ 1300.00
Empresa C  | R$  700.00 | R$ 3100.00 | **R$ 3100.00** | R$ 3100.00 | R$  3200.00 | R$ 2640.00 | R$ 3100.00

Considerando a mediana, estaríamos mais inclinados a escolher a empresa com a menor média salarial, pois os
não ficam muito distantes de R$ 3100.00.

A mediana é o valor central de um set de dados. Quando temos "Outliers", a melhor maneira de analisar é pegando
o valor centrar do conjunto de dados.
A média é mais afetada por "Outliers" (valores discrepantes), sendo assim estes valores afetam 
o resultado da média e levando os valores para fora da realidade.
*/

/*
MAIS MEDIDAS ESTATÍTICAS PARA ANÁLISE DE DADOS:

Eu tenho 3 máquinas para empacotar sacos de 15Kg de grãos para venda.
A média que uma máquina deve encher os sacos, é de 15Kg. Para tanto eu irei
testar 3 tipos de máquinas para uma compra futura.

Maquina 01            Maquina 02              Maquina 03      
 Dia   |  Qtd          Dia   |   Qtd           Dia   |  Qtd
  1    |  15            1    |    15            1    |   15
  2    |  25            2    |  15.5            2    |   25
  3    |  25            3    |  14.5            3    |   10
  4    |   1            4    |  15.1            4    |   10
  5    |  13            5    |  14.9            5    |   20
  6    |  20            6    |    43            6    |   15
  7    |  35            7    |    15            7    |   10
  8    |   0            8    |  14.9            8    |   15
  9    |   1            9    |  15.1            9    |   15
 10    |  15           10    |    15           10    |   15
																		   EXCELL
 Soma        |   150|  Soma        |    178|   Soma        |    150|		SOMA()
 Max         |    35|  Max         |     43|   Max         |     25|		MAIOR()
 Min         |     0|  Min         |   14.5|   Min         |     10|		MENOR()
 Média       |    15|  Média       |     22|   Média       |     22|		MEDIA()
 Mediana     |    15|  Mediana     |     15|   Mediana     |     15|		MED()
 Moda        |    15|  Moda        |     15|   Moda        |     15|		MODO.MULT()
 Amplitude   |    35|  Amplitude   |   28.5|   Amplitude   |     15|		MAIOR() - MENOR()
 Variância   | 124.6|  Variância   | 70.614|   Variância   |     20|		VAR.P()
 Desvio Pad. | 11.16|  Desvio Pad. | 8.4032|   Desvio Pad. | 4.4721|		DESVPAD.P()
 Coef. Var.% |74.416|  Coef. Var.% |38.1964|   Coef. Var.% |20.3279|		CoefVar.% = (Desv / Media) * 100
 
** Coef. Var. Alto não é bom (Máquina 01). Quanto mais próximo de zero, mais os dados estão próximos.
*** Retirando o Outlier do dia 6 (43) a variância cai para 0.06, sendo assim a melhor máruina seria a 02.
 
Variância é quanto os dados variam relacionado uns aos outros em relação a média.

Como calcular a variância:
1) Tirar a média;
2) Substituir cada membro da média (média - valor)**2;
3) Elevar cada resultado ao quadrado;
4) Somar todos os quadrados;
5) Dividir o resultado pelo número de menor ocorrência ((média - valor)**2/ (QTD DIAS => registros);
6) Tirar a raiz da variância (DP => Desv. Padrão);
7) Dividir DP pela média (CV => Coef. Var.).
*/

/* Modelagem Banco de Dados x Data Science */

/* Banco de Dados -> 1,2 e 3 Formas normais
Evitam reduncancia, consequentemente poupam espaço em disco.
Consomem muito processamento em função de Joins. Queries lentas

Data Science e B.I -> Focam em agregaçoes e performance. Não se 
preocupam com espaço em disco. Em B.I, modelagem mínima (DW)
em Data Science, preferencialmente modelagem Colunar */


/* O servidor de maquinas gerou um arquivo de log CSV.
Vamos importá-lo e analisa-lo dentro do nosso banco */

/*Importando CSV*/

CREATE TABLE MAQUINAS(
	MAQUINA VARCHAR(20),
	DIA INT,  -- A data está em formato de número
	QTD NUMERIC(10,2)
);

C:\Scripts SQL DataScience

COPY MAQUINAS
FROM 'C:\arquivos\LogMaquinas.csv' 
DELIMITER ','
CSV HEADER; -- Automaticamente ele pula a primeira linha de cabeçalho.

SELECT * FROM MAQUINAS;

/*QUAL A MEDIA DE CADA MAQUINA */

SELECT MAQUINA, AVG(QTD) AS MEDIA_QTD
FROM MAQUINAS
GROUP BY MAQUINA
ORDER BY 2 DESC;

/*ARREDONDANDO */

-- ROUND(COLUNA,2)

SELECT MAQUINA, ROUND(AVG(QTD),2) AS MEDIA_QTD
FROM MAQUINAS
GROUP BY MAQUINA
ORDER BY 2 DESC;

/* QUAL A MODA DAS QUANTIDADES */

select maquina, qtd, count(*) as moda
from maquinas
group by maquina, qtd
order by 3 desc;


/* QUAL A MODA DAS QUANTIDADES DE CADA MAQUINA */

SELECT MAQUINA, QTD, COUNT(*) AS MODA FROM MAQUINAS
WHERE MAQUINA = 'Maquina 01'
GROUP BY MAQUINA, QTD
ORDER BY 3 DESC
LIMIT 3; -- ALteramos para Limit 3, pois é multimodal (aparece 3 vezes).

SELECT MAQUINA, QTD, COUNT(*) AS MODA FROM MAQUINAS
WHERE MAQUINA = 'Maquina 02'
GROUP BY MAQUINA, QTD
ORDER BY 3 DESC
LIMIT 1;


SELECT MAQUINA, QTD, COUNT(*) AS MODA FROM MAQUINAS
WHERE MAQUINA = 'Maquina 03'
GROUP BY MAQUINA, QTD
ORDER BY 3 DESC
LIMIT 1;

/* moda do dataset inteiro */

SELECT  QTD, COUNT(*) AS MODA
FROM MAQUINAS
GROUP BY QTD
ORDER BY 2 DESC;


/* QUAL O MAXIMO E MINIMO E AMPLITUDE DE CADA MAQUINA  */

SELECT MAQUINA,
	   MAX(QTD) AS MAXIMO,
	   MIN(QTD) AS MINIMO,
	   MAX(QTD) - MIN(QTD) AS AMPLITUDE
	   FROM MAQUINAS
	   GROUP BY MAQUINA
	   ORDER BY 4 DESC;
		

/* ACRESCENTE A MEDIA AO RELATORIO */

SELECT MAQUINA,
	   ROUND(AVG(QTD),2) AS MEDIA,
	   MAX(QTD) AS MAXIMO,
	   MIN(QTD) AS MINIMO,
	   MAX(QTD) - MIN(QTD) AS AMPLITUDE
	   FROM MAQUINAS
	   GROUP BY MAQUINA
	   ORDER BY 4 DESC;


/* DESVIO PADRAO E VARIANCIA */

-- STDDEV_POP(coluna)
-- VAR_POP(coluna)

SELECT MAQUINA,
	   ROUND(AVG(QTD),2) AS MEDIA,
	   MAX(QTD) AS MAXIMO,
	   MIN(QTD) AS MINIMO,
	   MAX(QTD) - MIN(QTD) AS AMPLITUDE,
	   ROUND(STDDEV_POP(QTD),2) AS DESV_PAD,
	   ROUND(VAR_POP(QTD),2) AS VARIANCIA
	   FROM MAQUINAS
	   GROUP BY MAQUINA
	   ORDER BY 4 DESC;   

/* FUNCAO E ANALISE DA MEDIANA NO ARQUIVO 02 - Funcao de Mediana.sql */

CREATE OR REPLACE FUNCTION _final_median(NUMERIC[])
   RETURNS NUMERIC AS
$$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
   ) sub;
$$
LANGUAGE 'sql' IMMUTABLE;
										 
CREATE AGGREGATE median(NUMERIC) (
  SFUNC=array_append,
  STYPE=NUMERIC[],
  FINALFUNC=_final_median,
  INITCOND='{}'
);
					
										 
SELECT ROUND(MEDIAN(QTD),2) AS MEDIANA
FROM MAQUINAS;

SELECT ROUND(MEDIAN(QTD),2) AS MEDIANA
FROM MAQUINAS
WHERE MAQUINA = 'Maquina 01';
								
SELECT ROUND(MEDIAN(QTD),2) AS MEDIANA
FROM MAQUINAS
WHERE MAQUINA = 'Maquina 02';
										 
SELECT ROUND(MEDIAN(QTD),2) AS MEDIANA
FROM MAQUINAS
WHERE MAQUINA = 'Maquina 03';

INSERT INTO MAQUINAS VALUES('Maquina 01',11,15.9);
INSERT INTO MAQUINAS VALUES('Maquina 02',11,15.4);
INSERT INTO MAQUINAS VALUES('Maquina 03',11,15.7);
INSERT INTO MAQUINAS VALUES('Maquina 01',12,30);
INSERT INTO MAQUINAS VALUES('Maquina 02',12,24);
INSERT INTO MAQUINAS VALUES('Maquina 03',12,45);
										 
delete from maquinas where dia = 11 or dia = 12;

/*
	QUANTIDADE
	TOTAL
	MEDIA
	MAXIMO
	MINIMO
	AMPLITUDE
	VARIANCIA
	DESVIO PADRAO
	MEDIANA
	COEF VAR.
*/

SELECT MAQUINA,
	   COUNT(QTD) AS "QUANTIDADE",
	   SUM(QTD) AS "TOTAL",
	   ROUND(AVG(QTD),2) AS "MEDIA",
	   MAX(QTD) AS "MAXIMO",
	   MIN(QTD) AS "MINIMO",
	   MAX(QTD) - MIN(QTD) AS "AMPLIT. TOTAL",
	   ROUND(VAR_POP(QTD),2) AS "VARIANCIA",
	   ROUND(STDDEV_POP(QTD),2) AS "DESV. PADRAO",
	   ROUND(MEDIAN(QTD),2) AS "MEDIANA",
	   ROUND((STDDEV_POP(QTD) / AVG(QTD)) * 100,2) AS "COEF. VARIACAO"
FROM MAQUINAS
GROUP BY MAQUINA
ORDER BY 1;

delete from maquinas where dia = 11 or dia = 12;

/* MODA - MODE() WITHIN GROUP(ORDER BY COLUNA)  */

SELECT * FROM MAQUINAS;

SELECT MODE() WITHIN GROUP(ORDER BY QTD) AS "MODA" FROM MAQUINAS;

SELECT MAQUINA, MODE() WITHIN GROUP(ORDER BY QTD) AS "MODA" 
FROM MAQUINAS
GROUP BY MAQUINA;

SELECT MAQUINA,
	   COUNT(QTD) AS "QUANTIDADE",
	   SUM(QTD) AS "TOTAL",
	   ROUND(AVG(QTD),2) AS "MEDIA",
	   MAX(QTD) AS "MAXIMO",
	   MIN(QTD) AS "MINIMO",
	   MAX(QTD) - MIN(QTD) AS "AMPLIT. TOTAL",
	   ROUND(VAR_POP(QTD),2) AS "VARIANCIA",
	   ROUND(STDDEV_POP(QTD),2) AS "DESV. PADRAO",
	   ROUND(MEDIAN(QTD),2) AS "MEDIANA",
	   ROUND((STDDEV_POP(QTD) / AVG(QTD)) * 100,2) AS "COEF. VARIACAO",
	   MODE() WITHIN GROUP(ORDER BY QTD) AS "MODA"
	   FROM MAQUINAS
	   GROUP BY MAQUINA
	   ORDER BY 1;
	   
/* create table as select */

/*Podemos criar uma tabela com o resultado de uma querie
e essa é a forma de realizar uma modelagem colunar 
CREATE TABLE AS SELECT
*/


CREATE TABLE GENERO(
	ID_GENERO INT PRIMARY KEY,
	NOME VARCHAR(30)
);

INSERT INTO GENERO VALUES(1,'FANTASIA');
INSERT INTO GENERO VALUES(2,'AVENTURA');
INSERT INTO GENERO VALUES(3,'SUSPENSE');
INSERT INTO GENERO VALUES(4,'AÇÃO');
INSERT INTO GENERO VALUES(5,'DRAMA');

CREATE TABLE FILME(
	ID_FILME INT PRIMARY KEY,
	NOME VARCHAR(50),
	ANO INT,
    FK_ID_GENERO INT,
	FOREIGN KEY(FK_ID_GENERO)
	REFERENCES GENERO(ID_GENERO)
);

INSERT INTO FILME VALUES(100,'KILL BILL I',2007,2);
INSERT INTO FILME VALUES(200,'DRACULA',1998,3);
INSERT INTO FILME VALUES(300,'SENHOR DOS ANEIS',2008,1);
INSERT INTO FILME VALUES(400,'UM SONHO DE LIBERDADE',2008,5);
INSERT INTO FILME VALUES(500,'OS BAD BOYS',2008,4);
INSERT INTO FILME VALUES(600,'GUERRA CIVIL',2016,2);
INSERT INTO FILME VALUES(700,'CADILLAC RECORDS',2009,5);
INSERT INTO FILME VALUES(800,'O HOBBIT',2008,1);
INSERT INTO FILME VALUES(900,'TOMATES VERDES FRITOS',2008,5);
INSERT INTO FILME VALUES(1000,'CORRIDA MORTAL',2008,4);

CREATE TABLE LOCACAO(
	ID_LOCACAO INT PRIMARY KEY,
	DATA DATE,
	MIDIA INT,
	DIAS INT,
	FK_ID_FILME INT,
	FOREIGN KEY(FK_ID_FILME)
	REFERENCES FILME(ID_FILME)
);

select * from locacao

INSERT INTO LOCACAO VALUES(1,'01/08/2019',23,3,100);
INSERT INTO LOCACAO VALUES(2,'01/02/2019',56,1,400);
INSERT INTO LOCACAO VALUES(3,'02/07/2019',23,3,400);
INSERT INTO LOCACAO VALUES(4,'02/02/2019',43,1,500);
INSERT INTO LOCACAO VALUES(5,'02/02/2019',23,2,100);
INSERT INTO LOCACAO VALUES(6,'03/07/2019',76,3,700);
INSERT INTO LOCACAO VALUES(7,'03/02/2019',45,1,700);
INSERT INTO LOCACAO VALUES(8,'04/08/2019',89,3,100);
INSERT INTO LOCACAO VALUES(9,'04/02/2019',23,3,800);
INSERT INTO LOCACAO VALUES(10,'05/07/2019',23,3,500);
INSERT INTO LOCACAO VALUES(11,'05/02/2019',38,3,800);
INSERT INTO LOCACAO VALUES(12,'01/10/2019',56,1,100);
INSERT INTO LOCACAO VALUES(13,'06/12/2019',23,3,400);
INSERT INTO LOCACAO VALUES(14,'01/02/2019',56,2,300);
INSERT INTO LOCACAO VALUES(15,'04/10/2019',76,3,300);
INSERT INTO LOCACAO VALUES(16,'01/09/2019',32,2,400);
INSERT INTO LOCACAO VALUES(17,'08/02/2019',89,3,100);
INSERT INTO LOCACAO VALUES(18,'01/02/2019',23,1,200);
INSERT INTO LOCACAO VALUES(19,'08/09/2019',45,3,300);
INSERT INTO LOCACAO VALUES(20,'01/12/2019',89,1,400);
INSERT INTO LOCACAO VALUES(21,'09/07/2019',23,3,1000);
INSERT INTO LOCACAO VALUES(22,'01/12/2019',21,3,1000);
INSERT INTO LOCACAO VALUES(23,'01/02/2019',34,2,100);
INSERT INTO LOCACAO VALUES(24,'09/08/2019',67,1,1000);
INSERT INTO LOCACAO VALUES(25,'01/02/2019',76,3,1000);
INSERT INTO LOCACAO VALUES(26,'01/02/2019',66,3,200);
INSERT INTO LOCACAO VALUES(27,'09/12/2019',90,1,400);
INSERT INTO LOCACAO VALUES(28,'03/02/2019',23,3,100);
INSERT INTO LOCACAO VALUES(29,'01/12/2019',65,5,1000);
INSERT INTO LOCACAO VALUES(30,'03/08/2019',43,1,1000);
INSERT INTO LOCACAO VALUES(31,'01/02/2019',27,31,200);

SELECT F.NOME, G.NOME, L.DATA, L.DIAS, L.MIDIA
FROM GENERO G
INNER JOIN FILME F
ON G.ID_GENERO = F.FK_ID_GENERO
INNER JOIN LOCACAO L
ON L.FK_ID_FILME = F.ID_FILME
ORDER BY 1;

SELECT * FROM FUNCIONARIOS
ORDER BY 2;

CREATE TABLE REL_LOCADORA AS
SELECT F.NOME AS FILME, G.NOME AS GENERO, L.DATA AS DATA, L.DIAS AS DIAS, L.MIDIA AS MIDIA
FROM GENERO G
INNER JOIN FILME F
ON G.ID_GENERO = F.FK_ID_GENERO
INNER JOIN LOCACAO L
ON L.FK_ID_FILME = F.ID_FILME;

SELECT * FROM REL_LOCADORA;

-- EXPORTANDO PARA UM ARQUIVO .CSV (COPY FROM => IMPORTA/ COPY TO => EXPORTA)

COPY REL_LOCADORA TO
'C:\arquivos\REL_LOCADORA.csv'
DELIMITER ';'
CSV HEADER;

/* SINCRONIZANDO TABELAS E RELATORIOS */

DROP TABLE LOCACAO;

CREATE TABLE LOCACAO(
	ID_LOCACAO INT PRIMARY KEY,
	DATA TIMESTAMP,
	MIDIA INT,
	DIAS INT,
	FK_ID_FILME INT,
	FOREIGN KEY(FK_ID_FILME)
	REFERENCES FILME(ID_FILME)

);

-- SEQUENCES SÃO VERORES DE NÚMEROS CRIADAS FORA DA TABELA [1,2,3,4,5,6,...]
CREATE SEQUENCE SEQ_LOCACAO;

-- NEXTVAL('SEQ_LOCACAO');

INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/08/2018',23,3,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',56,1,400);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'02/07/2018',23,3,400);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'02/02/2018',43,1,500);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'02/02/2018',23,2,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'03/07/2018',76,3,700);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'03/02/2018',45,1,700);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'04/08/2018',89,3,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'04/02/2018',23,3,800);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'05/07/2018',23,3,500);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'05/02/2018',38,3,800);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/10/2018',56,1,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'06/12/2018',23,3,400);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',56,2,300);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'04/10/2018',76,3,300);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/09/2018',32,2,400);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'08/02/2018',89,3,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',23,1,200);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'08/09/2018',45,3,300);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/12/2018',89,1,400);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'09/07/2018',23,3,1000);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/12/2018',21,3,1000);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',34,2,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'09/08/2018',67,1,1000);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',76,3,1000);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',66,3,200);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'09/12/2018',90,1,400);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'03/02/2018',23,3,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/12/2018',65,5,1000);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'03/08/2018',43,1,1000);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',27,31,200);

SELECT * FROM LOCACAO;	
SELECT * FROM GENERO;
SELECT * FROM FILME;
SELECT * FROM REL_LOCADORA;

DROP REL_LOCADORA;

SELECT L.ID_LOCACAO, F.NOME AS FILME, G.NOME AS GENERO, L.DATA AS DATA, L.DIAS AS DIAS, L.MIDIA AS MIDIA
FROM GENERO G
INNER JOIN FILME F
ON G.ID_GENERO = F.FK_ID_GENERO
INNER JOIN LOCACAO L
ON L.FK_ID_FILME = F.ID_FILME;

CREATE TABLE RELATORIO_LOCADORA AS 
SELECT L.ID_LOCACAO, F.NOME AS FILME, G.NOME AS GENERO, L.DATA AS DATA, L.DIAS AS DIAS, L.MIDIA AS MIDIA
FROM GENERO G
INNER JOIN FILME F
ON G.ID_GENERO = F.FK_ID_GENERO
INNER JOIN LOCACAO L
ON L.FK_ID_FILME = F.ID_FILME;

SELECT * FROM RELATORIO_LOCADORA;
SELECT * FROM LOCACAO;

/* SELECT PARA TRAZER OS REGISTROS NOVOS */

SELECT MAX(ID_LOCACAO) AS RELATORIO, (SELECT MAX(ID_LOCACAO) FROM LOCACAO) AS LOCACAO
FROM RELATORIO_LOCADORA;
					
SELECT L.ID_LOCACAO, F.NOME AS FILME, G.NOME AS GENERO, L.DATA AS DATA, L.DIAS AS DIAS, L.MIDIA AS MIDIA
FROM GENERO G
INNER JOIN FILME F
ON G.ID_GENERO = F.FK_ID_GENERO
INNER JOIN LOCACAO L
ON L.FK_ID_FILME = F.ID_FILME
WHERE ID_LOCACAO NOT IN (SELECT ID_LOCACAO FROM RELATORIO_LOCADORA);

/* INSERINDO OS REGISTROS NOVOS */

INSERT INTO RELATORIO_LOCADORA
SELECT L.ID_LOCACAO, F.NOME AS FILME, G.NOME AS GENERO, L.DATA AS DATA, L.DIAS AS DIAS, L.MIDIA AS MIDIA
FROM GENERO G
INNER JOIN FILME F
ON G.ID_GENERO = F.FK_ID_GENERO
INNER JOIN LOCACAO L
ON L.FK_ID_FILME = F.ID_FILME
WHERE ID_LOCACAO NOT IN (SELECT ID_LOCACAO FROM RELATORIO_LOCADORA);

SELECT MAX(ID_LOCACAO) AS RELATORIO, (SELECT MAX(ID_LOCACAO) FROM LOCACAO) AS LOCACAO
FROM RELATORIO_LOCADORA;					
					
/* VAMOS DEIXAR ESSE PROCEDIMENTO AUTOMATICO POR MEIO
DE UMA TRIGGER */

CREATE OR REPLACE FUNCTION ATUALIZA_REL()
RETURNS TRIGGER AS $$
BEGIN

	INSERT INTO RELATORIO_LOCADORA
	SELECT L.ID_LOCACAO, F.NOME AS FILME, G.NOME AS GENERO, L.DATA AS DATA, L.DIAS AS DIAS, L.MIDIA AS MIDIA
	FROM GENERO G
	INNER JOIN FILME F
	ON G.ID_GENERO = F.FK_ID_GENERO
	INNER JOIN LOCACAO L
	ON L.FK_ID_FILME = F.ID_FILME
	WHERE ID_LOCACAO NOT IN (SELECT ID_LOCACAO FROM RELATORIO_LOCADORA);

	COPY RELATORIO_LOCADORA TO
	'C:\arquivos\RELATORIO_LOCADORA.csv'
	DELIMITER ';'
	CSV HEADER;

RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;				

/* COMANDO PARA APAGAR UMA TRIGGER */

DROP TRIGGER TG_RELATORIO ON LOCACAO;

CREATE TRIGGER TG_RELATORIO
AFTER INSERT ON LOCACAO
FOR EACH ROW -- PARA CADA LINHA QUE FOR INSERIDA.
	EXECUTE PROCEDURE ATUALIZA_REL();

				
/* INSERINDO NOVOS REGISTROS */

INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),NOW(),100,7,300);

INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),NOW(),500,1,200);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),NOW(),800,6,500);

SELECT * FROM LOCACAO;
SELECT * FROM RELATORIO_LOCADORA;

/* SINCRONIZANDO COM REGISTROS DELETADOS */

CREATE OR REPLACE FUNCTION DELETE_LOCACAO()
RETURNS TRIGGER AS
$$
BEGIN

DELETE FROM RELATORIO_LOCADORA
WHERE ID_LOCACAO = OLD.ID_LOCACAO;

	COPY RELATORIO_LOCADORA TO
	'C:\arquivos\RELATORIO_LOCADORA.csv'
	DELIMITER ';'
	CSV HEADER;

RETURN OLD;
END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER DELETE_REG
	BEFORE DELETE ON LOCACAO 
	FOR EACH ROW
	EXECUTE PROCEDURE DELETE_LOCACAO();

SELECT * FROM LOCACAO;	

SELECT * FROM RELATORIO_LOCADORA;	

DELETE FROM LOCACAO 
WHERE ID_LOCACAO = 1;

/* VARIÁVEIS DUMMY PARA MACHINE LEARNING 
> Em ML os dados são mais fáceis de ser trabalhados em INT ou melhor ainda em Binário (0, 1).
Para isso criamos colunas Dummy com dados binários.
Ex.
Sexo  | DM  | DF  |  
  M   |  1  |  0  |
  F   |  0  |  1  |
  M   |  1  |  0  |
  M   |  1  |  0  |
  F   |  0  |  1  |
  F   |  0  |  1  |
*/

/* UTILIZANDO O CASE */

SELECT NOME, SEXO FROM FUNCIONARIOS;

SELECT NOME, CARGO, 
CASE
	WHEN CARGO = 'Finacial Advisor' THEN 'Condicao 01'
	WHEN CARGO = 'Structural Engineer' THEN 'Condicao 02'
	WHEN CARGO = 'Executive Secretary' THEN 'Condicao 03'
	WHEN CARGO = 'Sales Associate' THEN 'Condicao 04'
	ELSE 'Outras Condicoes'

END AS "CONDICOES"
FROM FUNCIONARIOS;

SELECT CARGO FROM FUNCIONARIOS;

/* CASE PARA SEXO */

SELECT NOME,
CASE
	WHEN SEXO = 'Masculino' THEN 'M'
	ELSE 'F'
END AS 'SEXO'
FROM FUNCIONARIOS;

/* UTILIZANDO VALORES BOOLEANOS */

SELECT NOME, CARGO,
CASE
	WHEN (SEXO = 'Masculino') = true THEN 1
	ELSE 0
END AS "MASCULINO",
CASE
	WHEN (SEXO = 'Feminino') = true THEN 1
	ELSE 0
END AS "FEMININO"
FROM FUNCIONARIOS;


/* FILTROS DE GRUPO */

/* FILTROS BASEADOS EM VALORES NUMÉRICOS */

SELECT NOME, DEPARTAMENTO, SALARIO
FROM FUNCIONARIOS
WHERE SALARIO > 100000
ORDER BY SALARIO DESC;

/* FILTROS BASEADOS EM STRINGS */

SELECT NOME, DEPARTAMENTO, SALARIO
FROM FUNCIONARIOS
WHERE DEPARTAMENTO = 'Ferramentas';

/* PARTE DO TEXTO */

SELECT NOME, DEPARTAMENTO, SALARIO
FROM FUNCIONARIOS
WHERE DEPARTAMENTO LIKE 'F%';

/* FILTROS BASEADOS EM MULTIPLOS TIPOS E COLUNAS - CONSIDERAR OR E AND 
EM RELACIONAMENTO 1 X 1, O FILTRO AND TRATANDO DE UMA ÚNICA COLUNA SEMPRE
SERÁ FALSO. */

SELECT NOME, DEPARTAMENTO, SALARIO
FROM FUNCIONARIOS
WHERE DEPARTAMENTO = 'Ferramentas' AND SALARIO > 100000;

/* FILTROS BASEADOS EM UM ÚNICO TIPO E COLUNA - ATENÇÃO PARA A REGRA DO AND E OR */

SELECT NOME, DEPARTAMENTO, SALARIO
FROM FUNCIONARIOS
WHERE DEPARTAMENTO = 'Ferramentas' AND DEPARTAMENTO = 'Books';

/* FILTROS BASEADOS EM PADRÃO DE CARACTERES */

SELECT DEPARTAMENTO, SUM(SALARIO) AS "TOTAL"
FROM FUNCIONARIOS
WHERE DEPARTAMENTO LIKE 'B%'
GROUP BY DEPARTAMENTO;

/* FILTROS BASEADOS EM PADRÃO DE CARACTERES CO MAIS LETRAS */

SELECT DEPARTAMENTO, SUM(SALARIO) AS "TOTAL"
FROM FUNCIONARIOS
WHERE DEPARTAMENTO LIKE 'Bo%' -- COMEÇA COM "Bo"
GROUP BY DEPARTAMENTO;

/* UTILIZANDO O CARACTER CORINGA NO MEIO DA PALAVRA */

SELECT DEPARTAMENTO, SUM(SALARIO) AS "TOTAL"
FROM FUNCIONARIOS
WHERE DEPARTAMENTO LIKE 'B%s' -- COMEÇA COM "B" E TERMINAR COM "s"
GROUP BY DEPARTAMENTO;

/* E SE EU QUISESSE FILTRAR O AGRUPAMENTO PELO SALARIO? 
POR EXEMPLO: MAIOR QUE 40.000.00 
COLUNAS NÃO AGREGADAS => USAR WHERE
COLUNAS AGREGADAS     => USAR HAVING*/
-- NÃO FUNCIONA POIS TEMOS COLUNAS AGREGADAS (SUM(SALARIO) AS "TOTAL"), COM NÃO AGREGADA (DEPARTAMENTO).
-- PARA RESOLVER, TEMOS QUE USAR O "HAVING".

SELECT DEPARTAMENTO, SUM(SALARIO) AS "TOTAL"
FROM FUNCIONARIOS
WHERE DEPARTAMENTO LIKE 'B%s'
GROUP BY DEPARTAMENTO
HAVING SUM(SALARIO) > 4000000;

/* MULTIPLOS CONTADORES */

SELECT COUNT(*) FROM FUNCIONARIOS; -- CONTA AS LINHAS DA TABELA.

-- ESTA FORMA, USANDO SUBQUERY NA PROJEÇÃO DEGRADA A PERFORMANCE DO BANCO.
SELECT COUNT(*) AS "TOTAL_FUNC", 
(SELECT COUNT(*)
FROM FUNCIONARIOS
WHERE SEXO = 'Masculino'
GROUP BY SEXO) AS "Masculino"
FROM FUNCIONARIOS;

-- FORMA MAIS EFICIENTE DE FAZER.

SELECT COUNT(*) AS "QUANTIDADE TOTAL",
COUNT(*) FILTER(WHERE SEXO = 'Masculino') AS "MASCULINO"
FROM FUNCIONARIOS;

-- PODEMOS FILTRAR MAIS PROJEÇÕES.

SELECT COUNT(*) AS "QUANTIDADE TOTAL",
COUNT(*) FILTER(WHERE SEXO = 'Masculino') AS "MASCULINO",
COUNT(*) FILTER(WHERE DEPARTAMENTO = 'Books') AS "BOOKS"
FROM FUNCIONARIOS;

-- MISTURANDO OS FILTROS (STRING COM NUMÉRICOS).

SELECT COUNT(*) AS "QUANTIDADE TOTAL",
COUNT(*) FILTER(WHERE SEXO = 'Masculino') AS "MASCULINO",
COUNT(*) FILTER(WHERE DEPARTAMENTO = 'Books') AS "BOOKS",
COUNT(*) FILTER(WHERE SALARIO > 140000) AS "SAL_MAIS_140K"
FROM FUNCIONARIOS;

-- **ATENÇÃO!** O FILTER SÓ PODE SER USADO COM O COUNT.

/* REFORMATAÇÃO DE STRINGS */

-- PARA LISTAR:

SELECT DEPARTAMENTO FROM FUNCIONARIOS;

-- DISTINCT: => TRAZ OS DEPARTAMENTOS SEM REPETIÇÕES

SELECT DISTINCT DEPARTAMENTO FROM FUNCIONARIOS;

-- UPPER CASE => TRAZER EM LETRAS MAIÚSCULAS.

SELECT DISTINCT UPPER(DEPARTAMENTO) FROM FUNCIONARIOS;

-- LOWER CASE => TRAZER EM LETRAS MAIÚSCULAS.

SELECT DISTINCT LOWER(DEPARTAMENTO) FROM FUNCIONARIOS;

-- CONCATENAÇÃO ||.

SELECT CARGO || ' - ' || DEPARTAMENTO AS CARG_DEPT
FROM FUNCIONARIOS;

SELECT UPPER(CARGO || ' - ' || DEPARTAMENTO) AS "CARG_DEPT"
FROM FUNCIONARIOS;

-- REMOVER ESPAÇOS.

SELECT '      UNIDADOS   ';

-- CONTANDO CARACTERES.

SELECT LENGTH('      UNIDADOS   ');

-- APLICANDO TRIM.

SELECT TRIM('      UNIDADOS   ');

SELECT LENGTH(TRIM('      UNIDADOS   '));

/* DESAFIO:

CRIAR UMA COLUNA AO LADO DA COLUNA CARGO QUE DICA SE A PESSOA É ASSISTENTE OU NÃO.
*/

SELECT NOME, CARGO,
CASE
	WHEN CARGO LIKE '%Ass%' THEN 'Sim'
	ELSE 'Não'
END AS "ASSISTENTE?"
FROM FUNCIONARIOS
ORDER BY CARGO;

/* EXERCÍCIOS:

Qual a moda dos salários. A moda dos salários diz algo de relevante?

Qual a moda departamental = Qual o departamento que mais emprega?

Qual o desvio padrao de cada departamento?

Calcule a mediana selarial de todo o set de dados?

Qual a amplitude de todos os salários?

Calcule as principais medidas estatísticas por departamento.

Qual departamento te dá uma maior probabilidade de ganhar mais? -- Outdoor

SELECT MAQUINA,
	   COUNT(QTD) AS "QUANTIDADE",
	   SUM(QTD) AS "TOTAL",
	   ROUND(AVG(QTD),2) AS "MEDIA",
	   MAX(QTD) AS "MAXIMO",
	   MIN(QTD) AS "MINIMO",
	   MAX(QTD) - MIN(QTD) AS "AMPLIT. TOTAL",
	   ROUND(VAR_POP(QTD),2) AS "VARIANCIA",
	   ROUND(STDDEV_POP(QTD),2) AS "DESV. PADRAO",
	   ROUND(MEDIAN(QTD),2) AS "MEDIANA",
	   ROUND((STDDEV_POP(QTD) / AVG(QTD)) * 100,2) AS "COEF. VARIACAO",
	   MODE() WITHIN GROUP(ORDER BY QTD) AS "MODA"
	   FROM MAQUINAS
	   GROUP BY MAQUINA
	   ORDER BY 1;

*/

-- Qual a moda dos salários. A moda dos salários diz algo de relevante?

SELECT MODE() WITHIN GROUP(ORDER BY SALARIO) AS "MODA_SAL"
FROM FUNCIONARIOS;

-- Qual a moda departamental = Qual o departamento que mais emprega?

SELECT DEPARTAMENTO, COUNT(*)
FROM FUNCIONARIOS
GROUP BY DEPARTAMENTO;

SELECT MODE() WITHIN GROUP(ORDER BY DEPARTAMENTO) AS "MODA_DEPART"
FROM FUNCIONARIOS;

-- Qual o desvio padrao de cada departamento?

SELECT DEPARTAMENTO, ROUND(STDDEV_POP(SALARIO),2) AS "DESV. PADRAO"
FROM FUNCIONARIOS
GROUP BY DEPARTAMENTO
ORDER BY 2 DESC;

-- Calcule a mediana selarial de todo o set de dados?

SELECT ROUND(MEDIAN(SALARIO),2) AS "MEDIANA"
FROM FUNCIONARIOS;

-- Qual a amplitude de todos os salários?

SELECT MAX(SALARIO) - MIN(SALARIO) AS "AMPLIT. TOTAL"
FROM FUNCIONARIOS;

-- Calcule as principais medidas estatísticas por departamento.

SELECT DEPARTAMENTO,
	   COUNT(SALARIO) AS "FUNCIONÁRIOS",
	   SUM(SALARIO) AS "SOMA SALARIOS",
	   ROUND(AVG(SALARIO),2) AS "MEDIA",
	   MAX(SALARIO) AS "MAXIMO",
	   MIN(SALARIO) AS "MINIMO",
	   MAX(SALARIO) - MIN(SALARIO) AS "AMPLIT. TOTAL",
	   ROUND(VAR_POP(SALARIO),2) AS "VARIANCIA",
	   ROUND(STDDEV_POP(SALARIO),2) AS "DESV. PADRAO",
	   ROUND(MEDIAN(SALARIO),2) AS "MEDIANA",
	   ROUND((STDDEV_POP(SALARIO) / AVG(SALARIO)) * 100,2) AS "COEF. VARIACAO",
	   MODE() WITHIN GROUP(ORDER BY SALARIO) AS "MODA"
	   FROM FUNCIONARIOS
	   GROUP BY DEPARTAMENTO
	   ORDER BY 1;
	   

-- Qual departamento te dá uma maior probabilidade de ganhar mais? -- Outdoor
-- É o Outdoors, pois possui a maior Mediana.

SELECT DEPARTAMENTO,
	   COUNT(SALARIO) AS "FUNCIONÁRIOS",
	   SUM(SALARIO) AS "SOMA SALARIOS",
	   ROUND(AVG(SALARIO),2) AS "MEDIA",
	   MAX(SALARIO) AS "MAXIMO",
	   MIN(SALARIO) AS "MINIMO",
	   MAX(SALARIO) - MIN(SALARIO) AS "AMPLIT. TOTAL",
	   ROUND(VAR_POP(SALARIO),2) AS "VARIANCIA",
	   ROUND(STDDEV_POP(SALARIO),2) AS "DESV. PADRAO",
	   ROUND(MEDIAN(SALARIO),2) AS "MEDIANA",
	   ROUND((STDDEV_POP(SALARIO) / AVG(SALARIO)) * 100,2) AS "COEF. VARIACAO",
	   MODE() WITHIN GROUP(ORDER BY SALARIO) AS "MODA"
	   FROM FUNCIONARIOS
	   GROUP BY DEPARTAMENTO
	   ORDER BY 10;