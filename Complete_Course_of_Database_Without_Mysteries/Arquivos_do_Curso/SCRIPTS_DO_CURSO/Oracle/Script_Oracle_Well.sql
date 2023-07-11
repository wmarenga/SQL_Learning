/* Nova Conexão:
1) Aba Conections/ +;
2) Nome: Administrator/ Username: system (root: MySql/ sa: SQLServer)/ Password: XXXX
<Test> testa a conexão com banco/ <Save>/ <Connect>

Ferramentas de Bancos de Dados SQL:

SQL Plus (terminal)=> Melhor interface, pois não necessita de interface gráfica.
Enterprise Manager (EM) WEB => Interface bem feia e limitada de recursos.
PLSQL Developer (pago) => Robusto e com mais recursos. Mais famoso e mais usado.
Oracle SQL Developer (free) => Oficial da Oracle.

Estruturas Físicas e Lógicas:

Estruturas Primárias => Índices e tabelas.

Tabelas => Armazenamento
Índices => Velocidade de recuperação (melhorar performance)

Estruturas Lógicas de armazenamento

          TABELAS    ÍNDICES   VIEWS    PROCEDURES
             |         /        /          /
             |        /        /          /
             |       /        /          /
			 v______v________v__________v
		     |                          |
		     |         UNIDADES         |----------> ESPAÇO FÍSICO
		     |         LÓGICAS          |
             |__________________________|

1) Segmento:

Segmentos são os objetos dos bancos de dados Oracle.
Toda unidade lógica ocupa espaço físico na memória. Os segmentos são armazenados em DATABLOCKS.
DATABLOCKS são unidades mínimas de armazenamento (bloco de dados).
Tamanhos padrão dos Datablocks (2Kb, 4Kb, 8Kb, 16Kb, 32Kb)
Os Blocos são compostos por (HEADER/ ESPAÇO/ DADOS). O HEADER tem um ponteiro com o endereço 
para a continuação dos dados no próximo bloco.

Tipos de bancos:

OLTP (Transacionais)        => INSERT, DELETE, UPDATE. A proposta princípal são os 3 comandos,
mas também possui SELECT;
OLAP (ANALÍTICOS, CONSULTA) => SELECT

Quanto maior o bloco, a leitura é mais rápida e quanto menor o bloco, a gravação é mais rápida.

Para bancos OLTP é recomendado blocos de tamanhos menores (2Kb e 4Kb).
Para bancos OLAP é recomendado blocos de tamanhos maiores (16Kb e 32 Kb).
Os blocos de tamanho 8Kb são utilizados tanto em OLTP, quanto em OLAP (híbridos).

Quando criamos os nossos objetos, o padrão é 8Kb (não podendo ser alterados o padrão), mas podendo
ser alterados o tamanho dos objetos em blocos de tamanhos diferentes.

Datablock => Blocos no disco.
Segmentos => Objetos do banco de dados.
Extents => Tamanho ocupado É a soma dos Datablocks (ocupa um tamanho EXTENT).

Ao criar uma tabela (segment), ela ocupa Extents, que são compostos por Datablocks, ocupando espaços
no disco.
  _________________
 | DB  | DB  | DB  |
 | 8kB | 8kB | 8kB | => EXTENT DE 24Kb (tamanho)
 |_____|_____|_____|

Quando uma tabela é criada, ela aloca o seu espaço em EXTENTS que são formados por DATABLOCKS contínuos.
Quando essa tabela cresce de tamanho, ela aloca mais extensão (EXTENT) que não necessariamente está contínua
com o EXTENT inicial.
Os EXTENTS são armazenados em TABLESPACES, que são criadas com um tamanho pré-definido de EXTENTS livres. A
medida que os objetos vão sendo alocados, esses EXTENTS vão sendo ocupados.

ESTRUTURAS LÓGICAS:

									TABLESPACE
     ______________________________________________________________________________
	|                                       ____________________                   |
	|                                      |                    |                  |
	|	 TABELA                    ÍNDICE  |       SEGMENT      |                  |
	|  ___________                         |____________________|                  |
	| |           |                                                                |
	| |           |                                TABELA                          |
	| |           |                         _____________________                  |
	| |  SEGMENTO | ===> EXTENT            |  DB  |  DB  |  DB  |                  |
	| |           |                        |______|______|______|                  |
	| |           |                        |  DB  |  DB  |  DB  | DB => datablocks |
	| |           |                        |______|______|______|                  |
	| |___________|                        |  DB  |  DB  |  DB  |                  |
	|                                      |______|______|______|                  |
	|______________________________________________________________________________|


Sempre que criarmos uma tabela, ela deverá ser direcionada para uma TableSpace (espaço lógico).
Se não for especificado a TS, ela irá para uma TS padrão (Ex. TableSpace system).
Em uma TS, temos arquivos (.dbf) que são gerados com o mesmo tabanho da TS, ou podemos gerar
alguns arquivos (.dbf), onde a soma deles é o tamanho da TS.
Atenção pois não podemos criar a mesma tabela em TS diferentes.

ESTRUTURAS FÍSICAS:

Datafiles => Estruturas físicas de armazenamento do banco de dados Oracle. Datafiles compõem as 
TableSpaces e a soma dos seus tamanhos é a capacidade total da TableSpace. Os datafiles armazenam
arquivos dos usuários (INPUT).
No Windows os Datafiles possuem a extensão (.DBF).
No Linux a extensão dos Datafiles pode ser renomeada para qualquer coisa, porém não é recomendado
alterar o padrão de nomenclatura, pois poderá causar exclusões acidentais.
      ________________________________________________________________________
	 |  ______________________   _____________________   ___________________  |
     | |                      | |                     | |                   | |
	 | |                      | |                     | |                   | |
	 | |                      | |                     | |                   | |
	 | |       Datafile       | |      Datafile       | |     Datafile      | |
	 | |         333Mb        | |        333Mb        | |       334Mb       | |
	 | |                      | |                     | |                   | |
	 | |                      | |                     | |                   | |
	 | |______________________| |_____________________| |___________________| |
     |                                                                        |
	 |                			TableSpace Total 1Gb                          |
	 |________________________________________________________________________|
	 
Unidades Físicas => As unidades físicas são transparentes principalmente para os usuários. O DBA na 
maioria dos casos, também trabalha com as estruturas lógicas, a não ser quando preocupa-se especificamente
com as estruturas físicas. Po isso é tão importante conhecer a estrutura, arquitetura e os links entre
estruturas lógicas e físicas do Oracle.
O DBA não tem controle sobre em qual .DBF as informações serão armazenadas (CREATE, ALTER).
Geralmente nós criamos um objeto (O) e apontamos para um estrutura lógica (L) que será direcionada para 
uma estrutura física (F). => OLF

Os Datafiles são destinados a diferentes funções, de acordo com a função da TableSpace.

Existem 2 tipos de TableSpaces:

TableSpace Permanente => Dicionário de Dados (Metadata), Dados de aplicações.

TableSpace Temporária => Dados temporários.
____________________________________________

TableSpaces Padrão do Oracle:

As TableSpaces são sempre compostas por unidades físicas.

System e Sysaux => Armazena toda a parte de processamento/ CORE do banco, ou seja, todo o dicionário de
dados é armazenada nessas duas TableSpaces. Elas pertencem ao owner do banco. Tudo contido nessas TS é
crítico, sendo possível parar o banco.

Undo => Trabalha com a integridade do banco de dados, auxiliando na leitura consistente. Exemplificando,
os dados que não estão COMITADOS. Algumas literaturas também podem chamar o TS de Undo de TS de Rollback.
Está TS auxiliar para que possamos voltar o banco na situação anterior a alteração (Roolback).

Temp => Como já explicado anteriormente nas estruturas físicas, a TS Temp é utilizada para auxiliar a 
memória do Oracle em operações mais pesadas.

Existem outros arquivos físicos existentes além dos datafiles. Um deles é o CONTROLFILE. São responsáveis
pelo controle de funcionamento da base de dados Oracle. Toda base de dados Oracle deve ter pelo menos um
CONTROLFILE, podendo chegar ao máximo de oito. Caso haja mais de um, os mesmos servirão para redundância,
pois as informações serão as mesmas. Os CONTROLFILES fornecem informações para START UP ou para SHUT DOWN,
informando se os dois processos foram executados de maneira correta e síncrona. Os CONTROLFILES também
informam a localização dos DATAFILES para que o banco de dados possa ser ABERTO. Os CONTROLFILES também
armazenam informações como o nome da database, a data de criação e a hora (timestamp) e o único checkpoint 
ocorrido com os Datafiles.

Redo Log Files => Armazenam as transações executadas e confirmadas com COMMIT. São o log de transações.
O objetivo é permitir a maior recuperação de dados comitados. Quando executamos um COMMIT, os dados permanecem
em memória (RAM), pois o acesso a ela é mais rápido do que o acesso a DISCO (ROM). Sendo assim, os dados comitados
são gravados também nos REDO LOGS, afim de recuperar em caso de perdas antes da sincronização com os DATAFILES.

Archive => Como o Redolog funcionam de maneira circular, os dados são sobrescritos em determinado momento. Para
evitar perda de dados, podemos colocar o banco de dados em modo ARCHIVE, onde um arquivo é gerado com a cópia dos
REDOS a cada mudança de arquivo. O arquivo de ARCHIVE não é obrigatório no Oracle, porém é amplamente utilizado
em ambientes de produção.
Colocar o banco em modo ARCHIVE, significa arquivar periodicamente os REDOLOGS a cada cópia ou mudança que é feita.
    ___________
   |           |
   | REDOLOG 1 |
   |___________|
		 |
		 v
	___________	 
   |           |
   | REDOLOG 2 |
   |___________|
		 |
		 v
    ___________	 
   |           |
   | REDOLOG 3 |
   |___________|
		 |
		 v
    ___________	 
   |           |
   |  ARCHIVE  |
   |___________|
		 
Como os arquivos são armazenados?

FILE SYSTEM => Sistema Operacional - É a opção padrão.

O Oracle requisita a gravação de arquivos ao SO. que gerencia através de seu GERENCIADOR DE VOLUMES e grava em seu 
sistema de arquivos, que por sua vez, avisa ao Oracle da gravação.

ASM => Automatic Storage Management, onde o Oracle controla o acesso aos seus arquivos, sem passar pelo sistema
operacional. O SO não conhece os volumes que o Oracle gerencia, e nem sabe que existem arquivos no espaço em disco 
destinado ao Oracle. O ASM aumenta a performance do banco.

Arquivos de Parâmetros => São os arquivos lidos no momento em que um banco de dados sobe, ou seja, no momento em que
ele fica operacional. Como parâmetros, são por exemploa quantidade de memória, parâmetros de sessão, etc.

São dois tipos de arquivos:

SPFILE => A instância do banco de dados lê esse arquivo no momento da inicialização. Esse arquivo é binário e deixa os
parâmetros persistentes.

PFILE => É um arquivo idêntico ao SPFILE, porém é um arquivo texto e pode ser editado manualmente pelo usuário.

Situação Prática:

Necessito realizar uma manutenção onde preciso que o banco suba de determinado modo, porém não utilizarei tão cedo o banco
da mesma forma.

Em vez de tornar o parâmetro permanente no SPFILE, posso apenas editar o PFILE e mandar o banco inicializar lendo o PFILE,
e na próxima vez que o banco iniciar, o banco lerá o SPFILE que não terá armazenado o parâmetro.

Há 2 tipos de parâmetros: 

Estático => Necessita reinicialização;
Dinâmico => A maioria dos parâmetros.

Escopos:

1) Na memória => É alterado automaticamente, parra isso necessita ser dinâmico.(comando: SCOPE = MEMORY)
2) Na reinicialização => SPFILE, alteração válida somente após reinicialização e não está alocado na memória. Por mais que
seja dinâmico, não desejo fazer no mesmo momento, (comando: SCOPE = SPFILE);
3) No mesmo momento e persistente => Devo trabalhar com um parâmetro dinâmico (SPFILE) e deixar sem escopo (PFILE), pois ele
tratará como padrão(comando: SCOPE = BOTH).

Testando Parâmetros:

O comando ALTER SESSION SET, reconfigura um parâmetro apenas para a sessão corrente, ou seja, é ideal paea se testar algo como
por exemplo, performance. Ao desligar a sessão, a alteração é desfeita e não está disponível para nenhuma outra sessão.

Dica: Verificando os parâmetros:
select * from v$parameter

v$ é usado para views dinâmicas do Oracle.

Arquivos Secundários:

Passwordfile => Arquivo de senhas criptografadas para autenticação no banco de dados.

Arquivos de Bachup => Geralmente compostos de DBF's, Controlfiles, archivelogs e os arquivos de inicializaçao.

Arquivos de Log (sistema) => São os arquivos TRACE, ou .TRC, que servem para monitorar o banco de dados.

Arquivos de Alerta => Alert Logs, arquivos de alertas automáticos de todas as situações que ocorrem nos Bancos de Dados.

ESTRUTURAS DE MEMÓRIA:

Memória => A memória RAM padrão alocada pelo Oracle no momento da instalação é de 40% da memória total do servidor.
A memória alocada é dividida em compartilhada, que é utilizada por todos os usuários e processos do Oracle, e a
memória dedicada, onde cada usuário possui o seu próprio espaço, ou processo.

Memória Compartilhada => Se chama SGA (System Global Area). A SGA é uma área de memória compartilhada por todos os usuários
da base de dados. Seu objetivo é compartilhar o acesso, melhorando assim a performance. Cada instância possui a sua própria SGA.
A SGA evita o retrabalho dos usuários.
A instância é a instalação do SQL no computador, cada instância possui seu próprio SGA independente e os mesmos não se comunicam
entre sí.

Sub-areas da SGA:

Shared Pool => Verifica a requisição SQL Sintaticamente, ou seja, se o comando foi digitado corretamente (Ex.: FROM e não ROM).
Após a análise Sintática ser bem sucedida, é iniciada uma análise Semântica, onde é verificado se o usuário tem permissão para o
a requisição. Após as análise Sintáticas e Semânticas (chamada Parse) é criado um Plano de Execução. O resultado deste plano é o
resultado da resposta SQL.
A Shared Pool é dividida em duas áreas (Library Cache e Data Dictionary Cache)
Library Cache => SQL, PLSQL, Procedures, Functions.
Data Dictionary Cache -> Definições de dicionários.

Database Buffer Cache => Se a Query já tiver sido feita (Shared Pool) ele vai pegar no bloco de memória do Database Buffer Cache.

Memória Dedicada => Se chama PGA (Program Global Area).

DATABASE BUFFER CACHE:

Quanto ao tamanho de DBBC, ele irá corresponder ao tamanhos do bloco configurado na criação da database (2, 4, 8, 16 e 32Kb).

Quando um usuário faz uma operação de DML, o bloco é copiado para a área de memória e toda a manipulação passa a ser feita nessa
área e não no disco. O DBBC mantém uma lista com os blocos mais utilizados e vai liberando espaço de acordo com os blocos menos
utilizados, sempre que necessário para acessar informações novas. Ao realizar a operação e efetuar um commit, os blocos do DBBC
não são gravados na hora em disco, nesse momento é feita a gravação no REDO LOG e o DBBC mantém ainda os blocos alterados para que
esses sejam gravados em conjunto com os outros blocos em um momento oportuno.

REDOLOG BUFFER => É a área de memória correspondente aos REDO LOGS no disco. Assim que uma transação é comitada, ela é guardada no 
REDO LOG BUFFER, que escreverá no arquivo de REDO LOG no disco.

    ________COMMIT_____________                 _____________________
   |  DATABASE BEFFER CACHE  |               |   REDOLOG BEFFER   |
   |               _______   |               |       ________     |
   |              |       |  |               |      |        |    |
   |      Bloco	  |  8Kb  |===========================> 8Kb  |    |
   | 	Alterado  |_______|  |               |      |____| __|    |
   |_________________________|               |___________|________|
                                                         |
														 |
														 V
												      _______
													 |   HD  |
													 |   O   |
								       REDOLOG FILES |   |   |
													 |   |   |
													 |_______|

OUTRAS ESTRUTURAS:

Ainda na SGA (System Global Area): Área compartilhada.

LARGE POOL => Para objetos grandes não ocuparem a SHARED POOL, como por exemplo, rotinas de backup. A LARGE POOL também permite o
paralelismo no Oracle.

JAVA POOL => Armazena códigos JAVA e JVM

STREAMS POOL => Área que armazena o serviço de mensagens para replicação de dados.

A ESTRUTURA PGA => É alocada uma área de PGA por sessão, que auxilia os usuários com cláusulas ORDER BY ou DISTINCT, variáveis
BIND ou VARIÁVEIS DE SESSÃO.                            _____
                                                       |     |
    _____                     _____                    | PGA |
   |     |     	             |     |<----- USER1 <-----|_____|
   | PGA |------> USER3----->| SGA |                    _____
   |_____|		             |_____|<----- USER2 <-----|     |
                                                       | PGA |
													   |_____|

FORMAS DE CONFIGURAÇÃO:

Existem 3 formas de configurar as áreas de PGA e SGA.

Manual - Parâmetro a parâmetro de cada uma das áreas que compõe as duas áreas de memória.

AMM - Dois parâmetros referentes a SGA e PGA, onde as duas alocam dinamicamente o tamanho das suas áreas internas.

ASMM - Apenas um parâmetro para a SGA e PGA onde nenhuma das áreas tem um tamanho fixo assim como as suas áreas internas.

Versões                                                       - DATABASE_CACHE_SIZE
Antigas   =============>      MANUAL       ===============>   - SHARED_POOL_SIZE
                                                              - PGA_AGGREGATE_TARGET

                          AUTOMATIC                           - SGA_TARGET
10G       =============>  MEMORY           ===============>   - PGA_AGGREGATE_TARGET
                          MANAGEMENT(AMM) 

                          AUTOMATIC
11G/ 12G  =============>  SHARED           ===============>   - MEMORY_TARGET (GERAL)
                          MEMORY                                ** O Oracle determina a alocação de SGA e PGA dinamicamente.
                          MANAGEMENT (ASMN)

PROCESSOS:

PMON => Responsável por monitorar todos os outros processos. Quando um processo termina irregularmente, é o PMON que libera
os dados (lock) e recupera esse processo.

SMON => Tarefas diversas, mas como principal, a recuperação automática da instância no Startup.

DBWriter => Responsável por gravar o conteúdo dos Databases Buffer Cache DBBC nos respectivos Datafiles. A gravação ocorre
quando o DBBC necessita de espaço, então o DBWRITER grava os dados que já foram comitados, liberando espaço para novas transações.

LGWR => Faz a ponte entre o REDO LOG BUFFER e os arquivos de REDO LOG FILES. É acionado sempre que o usuário efetua um commit,
liberando a entrada do buffer para uma nova transação. A transação gravada pelo LGWR recebe um número chamado SCN.

CKPT => Responsável por sinalizar ao DBW o momento da gravação do DBBC no seus datafiles, ou seja, da memória para o disco.

MMON => Associado ao AWriter. Captura as estatísticas do banco.

MMNL => Grava as estatísticas do banco ASH e parte do AWR em disco.

RECO => Recupera ou finaliza falhas de transações. Somente bases de dados distribuídas.

ANALISANDO QUERIES NO ORACLE (Como ocorre uma operação de DML):

** O Oracle é composto por Instância e Processos + Banco de Dados (O = I e P + BD)

			                                		            INSTÂNCIA ORACLE
		
                                            SHARED POOL   |      DATABASE            |     REDOLOG
											              |    BUFFER CACHE	         |     BUFFER
		          			                              |                          |
		         			               PARSE SQL (A)  |  2000 (C) ==> 5000 (F)   |  100, 2000, 5000 (D)
			        			           + Plano de     |   (lock) => SCN 5000 (K) |
			        			             execução     |      |		     ^       | 	Gera SCN (H)				
			        			                    	  |      |           |       |
				        		            COMMIT ou     |      V           |       |
                                             ROLLBACK     |    2000(E)    ROLLBACK ======> Não é gerado SCN number
                                                          |    UNDO  	             |
                                                          |      | (L)               |   Limpeza do REDOLOG BUFFER(J)   
														  |      |                   |
														  |      v                   |
														  |  < COMMIT >              |
			                                              |
			
Processos de =====>        Server              CKPT                DBWRT               LGWRT
Backgroun			        Proc
                                           _____(M)____                            ______________________
                                          |  2000 (B)  |          ARQUIVOS        | SCN 100,2000,5000 (H)|
                         USUÁRIO =====>   |  DATAFILE  |  <====== FÍSICOS ======> |   REDOLOG FILES      |
                                          |____ HD_____|                          | Gravação em disco(I) |
										                                          |______________________|   
** Processos rodando no WIndows: Oracleabcnomeinstacia										  
** Processos rodando no Linux e Unix: Top (ver cada processo rodando).

AÇÕES DO USUÁRIO (antes do COMMIT):

1) Update funcionários set salario = 5000
   where idfunc = 100
 
(A) O parse do SQL e a checagem do acesso aos objetos do dicionário são armazrnados no Shared Pool

(B) O bloco de dados é lido na database (Database File). 2000 seria o salário antigo do funcionário com id=100.

(C) Uma cópia do bloco é colocada na memória, no Database Buffer Cache, Esse bloco permanece em LOCK.

(D) ANTES do update ocorrer a transação é gerada no Redolog buffer.

(E) É criado um bloco de UNDO com o valor antigo do bloco 2000.

(F) O valor do bloco é atualizado para 5000.

(G) Ao efetuar um ROOLBACK, o valor do bloco de UNDO, sobrescreve o bloco na memória e a transação do REDOLOG
é apagada e o LOCK retirado.

(H) É gerado um número único de SCN no REDOLOG, que caracteriza a transação como única.

(I) A transação é gravada em disco, nos REDOLOG FILES.

(J) O REDOLOG BUFFER é limpo.

(K) O LOCK é retirado e o bloco é identificado com o SCN da transação.

(L) A área de UNDO nesse momento pode ser sobrescrita.

(M) O valor é sincronizado com os Datafiles.

** O processo de CKPT avisa ao processo DBWRT para escrever os dados no disco, entretanto este processo é opcional,
podendo ser assumido todo pelo DBWRT.
O DBWRT tem a função de fazer a sincronização dos dados no disco.

PROGRAMAS ÚTEIS:

- WINSCP => Mais fácil para copiar arquivos. Conecta via SSH em uma máquina Windows. Para conectar no servidor via SSH.
Conecta também via FTP para troca de arquivos entre Windows e Linux.

- PuTTY => Conecta via SSH. Mais fácil e completo para trabalhar um modo texto (terminal).

- MobaXterm (melhor) => Possibilita trazer interface gráfica de algum programa durante a instalação pelo X server. SSH,
FTP, etc.

Fazendo um SSH com a Máquina Virtual no MobaXterm (Linux):

$ ssh root@192.168.56.100 <Enter>
password: 1234

$ ls -lart (ver os diretórios)

$ shutdown -h 0 (reboot Linux) 0 => indicar o tempo para reboot
** Somente conseguimos desligar a máquina como usuário root.

$ su - (loga como root)

Xming X Server for Windows  => Permite que instalemos a interface gráfica no Linux VM.

Conectando com o usuário Oracle:

$ ssh oracle@192.168.56.102 <Enter>
password: 1234

Testar se a interface gráfica está funcionando (relógio Linux):

$ xclock

Para criar o banco de dados (Linux):
(Database Configuration Assistant for Oracle)

$ dbca

<Next>

x Create a DATABASE
<Next>

Like block size (Datablock sike) -> OLTP (Arquivos físicos):

x General Purpose or Transaction Processing (blocos menores: gravação rápida/ leitura lenta)
o Custom DATABASE (escolha do DBA)
o Data Warehouse (blocos maiores: gravação lenta/ leitura rápida)

<Show Details> Detalhamento dos arquivos e suas localizações <Close>
<Next>

* Podemos definir nomes globais mais detalhados (orcl.matriz.com)
Global Database Name: orcl
SID: orcl (nome da instância)

Enterprise Manager => Gerenciador Oracle com interface gráfica (WEB).

x Configure Enterprise Manager

x Configure Databse Control for local management.

<Aba> (Automatic Maintenance Tasks)

run Netca: para rodar o comando Netca, nós precisamos abrir uma segunda janela (sessão) no 
MobaXterm, pois a primeira janela está emulando o Oracle.
logar:
$ ssh oracle@192.168.56.102 <Enter>
password: 1234

$ netca <Enter>

Criar o Listener:

x Listener configuration <Next>

x Add <Next>

Listener name: LISTENER (ou custom) <Next>

Protocolos utilizados:
Selected Protocols: TCP (padrão) <Next>

x Use the standard port number of 1521 <Next>

Would you like to configure another listener? No <Next>
<Next>
<Finish>

** O que é um Listener?
É o responsável por ouvir todas as requisições (chamadas) para o Oracle (pela porta 1521).
Este serviço fica rodando em background no servidor Oracle.

Voltar para primeira janela:
<Aba> (Automatic Maintenance Tasks) <OK>

<click Aba novamente> (Automatic Maintenance Tasks)
x Enable automatic maintenance tasks
<Next>

Podemos usar o mesmo Password para todas as contas:
x Use the Same Administrative Password for All Accounts
Password: 1234
Confirm Password: 1234
<Next>

Do you want to continue? <Yes>

x Use Oracle_Manages Files (O Oracle gerencia o armazenamento em disco)
<File Location Variables> (Mostra onde estão os arquivos que o Oracle está gerenciando)
<Next>

x Specify Fast Recovery Area (Armazena os arquivos essenciais para uma possível restauração rápida)

o Enable Archiving (habilita a criação de um 4 arquivo que armazena os REDO1, REDO2 e REDO3 ciclicamente)
<Next>

<Aba Sample Schemas>
x Sample Schemas (exemplos do Oracle)

<Aba Custom Scripts> (Podemos indicar alguns scripts para rodar após a criação da DATABASE)
o No scripts to run
<Next>

<Aba Memory>
x Typical (40% da memória alocada para o Oracle => SGA e PGA).
   x Use Automatic Memory Management

<Aba Sizing> (processos em Background)
Processes: 550

<Aba Character Sets> (depende da aplicação ou da orientação de uso)
x Use the default

<Aba Connection Mode>
x Dedicated Server Mode (PGA)
<Next>

OMF => Oracle-Managed Files
<Next>

Select the database creation options:
x Create DATABASE
x Save as a Database Template

Name: orcl
Description: Template do primeiro banco de dados criado no curso.

x Generate Database Creation Scripts
<Finish>

<Save as an HTML file>
<OK>

The template "orcl" creation completed <OK>

The generation of the script <OK>

Inicia a criação da Database....

Copiar a URL: The Databse Control URL is https://localhost:1158/em
<Exit>

Conferindo se alguns processos estão rodando (Linux):

[oracle@localhost ~] $ ps
[oracle@localhost ~] $ ps -ef | grep smon 
[oracle@localhost ~] $ ps -ef | grep pmon

Ver se está conectando
[oracle@localhost ~] $ sqlplus / as sysdba

SQL> exit

[oracle@localhost ~] $ su - root
Password: 1234
[root@localhost ~] shutdown -h 0

logar novamente:
$ ssh oracle@192.168.56.102 <Enter>
password: 1234

** Atenção: Não confundir Listening (conexão cliente externo) com conexão remota.
A conexão SSH tem acesso ao servidor todo (todas as funcionalidades).
O Listening permiter que outra máquina com o Oracle cliente, acesse ao servidor externamente,
porém com limitações que permitem apenas acesso ao serviços do servidor (não é possível
reiniciar a máquina e etc.).

Inicializando o serviço do Listening:

[oracle@localhost ~] $ lsnrctl start <enter>
A partir desta inicialização, um client Oracle terá acesso externamente pela porta 1521.

Conectando o banco Oracle
[oracle@localhost ~] $ sqlplus / as sysdba

SQL> select * from dict; <enter>
ERRO: Pois a instância não foi inicializada ainda.
Estamos sem acesso aos arquivos do banco (dbf, etc)

Para inicializar o banco, temos que usar o comando abaixo:

SQL> startup <enter>

Agora é possível ver o dicionário de dados:
SQL> select * from dict; <enter>

Start do serviço do EM (Enterprise Manager):
- Abrir o browser;
- Digitar o IP do servidor: https://192.168.56.102:1158/em 
Atenção: Este endereço foi informado ao final da instalação do banco (endereço WEB).

** Dentro do Servidor, nós temos instâncias (instalações Oracle). Estas instâncias são
versões do Oracle (11G, 12C). E dentro de cada instância nós podemos ter vários bancos.
Quando usamos o comando STARTUP, antes temos que apontar o ORACLE-SID para o banco que
queremos subir.

Inicializando o Servidor WEB:

ATENÇÃO: Temos que sair do banco de dados ($ exit) e dar o comando do Sistema Operacional.

SQL> exit <enter>

[oracle@localhost ~] $ emctl start dbconsole <enter>

- Abrir o browser <refresh>;
- Mensagem de conexão não segura;
- Ir em avançado e adicionar excessão;
- Digitar o IP do servidor: https://192.168.56.102:1158/em
- Enterprise Manager:
Usuário: system
senha: 1234
<login>

Instalação no Windows:

Alterar o nome do computador (VirtualBox).
Propriedades do sistema/ Nome do Computador <alterar>: dbserver01 <Mais>
DNS primario: terati.com
O nome do computador ficará dbserver01.terati.com

O motivo é que temos dois nomes no Oracle, o primeiro (DBSRV.TERA.COM) é para nome de Domínio (DNS), e o
segundo (DBSRV) mais simples. Está é uma boa prática, pois facilita a instalação RAC.

RAC => Real Aplication Cluster é uma máquina (DBSERVER01) que pode estar conectada em vários
bancos (instâncias) 1 => (DBSRV); 2 => (DBSRV02); 3 => (DBSRV03).

Variáveis de Ambiente (do sistema) = environment variables:

set de variaveis no Windows (cmd): > set Oracle_BASE=c:\Oracle <enter>
Para ver as variáveis de ambiente > set <enter>

set da Oracle Home (instância) > set ORACLE_HOME=%ORACLE_BASE%\11g\R2 <enter>
Atenção: O % é para representar uma variável no WIndows.

Para executar de qualquer lugar no Windows (em outros diretórios):
O Path permite que o exe seja executado de todos os lugares (diretórios).
O objetivo é inserir a pasta bin do Oracle dentro do Path (acrescentar).

Como inserir um exe no Path sem retirar o existente:
> set PATH=%PATH%;%ORACLE_HOME%\bin

** Atenção: O camando set altera as variáveis de ambiente apenas enquanto o PC está ligado,
quando reiniciamos o PC, as variáveis de ambiente retornam ao seu estado anterior.

Como criar variáveis de ambiente definitivas:
- System Properties/ Environment Variables/ System Variables;
O Oracle cria as variáveis automaticamente.
Comando para criar manualmente:
> set ORACLE_BASE=c:\Oracle
> set ORACLE_HOME=%ORACLE_BASE%\11g\R2
> set PATH=%PATH%;%ORACLE_HOME%\BIN
> set (para viasualizar as alterações)
** Atenção: Se fizermos as alterações anteriormente pelo comando set, o Oracle irá reconhecer
durante a instalação da instância.

> sqlplus (loga no SQL em qualquer parte do sistema)
Usuário: / as sysdba (logando via usuário do systema operacional)
- Computer Management/ Local Users and Groups/ Groups/ ORA_DBA
(Este grupo ORA_DBA é criado pelo Oracle automaticamente na instalação)
Atenção: É necessário verificar, periodicamente quais os usuários autorizados para fins de segurança.

> netca (para configurar o listener) ** é um aplicativo dentro da pasta /bin

Criando as variáveis de ambiente que não foram criadas:
- System Properties/ Environment Variables/ System Variables <New>
Variable name: ORACLE_BASE
Variable Value: c:\Oracle
<OK>

Variable name: ORACLE_HOME
Variable Value: %ORACLE_BASE%\11g\R2
<OK>

** Atenção: O PATH já foi criado pelo sistema.

Para conectar no banco:

cmd
> sqlplus 
Usuário: system 
Password: 1234
SQL>

Outra Maneira de conectar no banco:

cmd
> sqlplus system/1234 (sqlplus login/senha)
SQL>

Comentários:

-- é aceito nos principais bancos de dados (SQL Server => T-SQL e Oracle => PL/SQL).
## é comentário no MySQL. O /* não é aceito no MySQL.

USUÁRIO DO BANCO DE DADOS:

show user;
(USER is "SYSTEM")

TABELA DUMMY (tabela DUAL):

SELECT 1 + 1; (Não funciona pois tudo no Oracle tem que vir de uma tabela.)

SELECT 1 + 1 FROM DUAL;
SELECT 1 + 1 AS SOMA FROM DUAL;

Atenção: Sempre que tiver que fazer um SELECT de uma tabela inexistente, usamos o DUAL.

VERIFICANDO O AMBIENTE (NO METADATA):

SELECT METADATA FROM SYS.KOPM$;

0000006001240F050B0C030C0C0504050D0609070805050505050F05050505050A05050505050405
0607080823472347081123081141(**B047**)0083036907D0030000000000000000000000000000000000
0000000000000000000000000000000000000000

Verificando parte do código, conseguimos verificar se o sistema é 32 ou 64 bits.
B023 => 32 bits
B047 => 64 bits

DICIONÁRIO DE DADOS (consulta ao dicionário de dados):

SELECT * FROM DICT;

UNICA / RAC:
Como saber se a instância está em RAC ou é única.

*** RAC => Real Aplication Cluster é uma máquina (DBSERVER01) que pode estar conectada em vários
bancos (instâncias) 1 => (DBSRV); 2 => (DBSRV02); 3 => (DBSRV03).

SELECT PARALLEL FROM V$INSTANCE; (NO => Única)

** Tudo que começar com V$ é uma view.

ESTRUTURA DE MEMÓRIA:

SELECT COMPONENT, CURRENT_SIZE, MIN_SIZE, MAX_SIZE
FROM V$SGA_DYNAMIC_COMPONENTS;

CONECTANDO A OUTRO BANCO DE DADOS:

SQLPLUS SYSTEM/SENHA@NOMEDOBANCO1
ORACLE_SID=BANCO01

SQLPLUS SYSTEM/SENHA@NOMEDOBANCO2
ORACLE_SID=BANCO02

SABER O NOME DOS BANCOS:

SELECT NAME FROM V$DATABASE;

VERSAO DO BANCO DE DADOS:

SELECT BANNER AS VERSAO FROM V$VERSION;
(Oracle Database 21c Express Edition Release 21.0.0.0.0 - Production)

VERIFICAR PRIVILÉGIOS DOS USUÁRIOS:

SELECT * FROM USER_SYS_PRIVS;

TABELAS DO USUÁRIO:

SELECT TABLE_NAME FROM USER_TABLES;

ARMAZENAMENTO:
                          ARMAZENAM               OCUPAM              ESTÃO CONTIDOS   
LÓGICO = TABLESPACES => SEGMENTOS(OBJETOS) => EXTENSÕES(ESPAÇO Mb) => EM BLOCOS (do SO)

FÍSICO => DATAFILES

*** Não podemos determinar em qual arquivo físico um objeto ficará.

CRIAÇÃO DE DUAS TABELAS:

CREATE TABLE cursos(
	ID_CURSO INT PRIMARY KEY,
	NOME VARCHAR2(30),
	CARGA INT
)TABLESPACE USERS;

CREATE TABLE teste(
	ID_TESTE INT,
	NOME VARCHAR2(30)
);

FAZENDO UMA QUERY DO DICIONÁRIO DE DADOS:

** Mostrando o nome da tabela e o tablespace em USER_TABLES.

SELECT TABLE_NAME, TABLESPACE_NAME
FROM USER_TABLES;

Aplicando filtro:

Na tabela cursos, foi especificado o tablespace, então ficou em USERS
SELECT TABLE_NAME, TABLESPACE_NAME
FROM USER_TABLES
WHERE TABLE_NAME = 'CURSOS';

Contudo, por não especificarmos a tablespace na tabela teste, ficou na tablespace: SYSTEM
SELECT TABLE_NAME, TABLESPACE_NAME
FROM USER_TABLES
WHERE TABLE_NAME = 'TESTE';

Atenção: Todo objeto, por padrão, é criado na tablespace USERS, exceto quando se está logado com o usuário system, então, será criado na tablespace SYSTEM.

C:\app\marenga\product\21c\oradata\XE
USERS01.DBF  => Tablespace usuários
SYSTEM01.DBF => Tablespace system

Os arquivos .DBF são FÍSICOS e as tablespaces são LÓGICAS. As tabelas (LÓGICAS) são criadas dentro do tablespace.

SELECT SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BYTES, BLOCKS, EXTENTS
FROM USER_SEGMENTS;

COM FILTRO:
SELECT SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BYTES, BLOCKS, EXTENTS
FROM USER_SEGMENTS
WHERE SEGMENT_NAME = 'CURSOS';

FORMATANDO COLUNAS:
1 Opção: Baixar e instalar o SQL Developer;
2 Opção: Formataçao de colunas.

CMD (DOS)
COLUMN TABLESPACE_NAME FORMAT A10;
COLUMN TABLESPACE_NAME FORMAT A10;
COLUMN TABLESPACE_NAME FORMAT A10;

COMO SABER O SID (No Windows):
Services/ OracleServiceXE (SID: XE)

BACKUP NO ORACLE:

No Oracle o BKP é feito atravez da ferramente RMAN (Bem detalhada).

CRIAÇÃO DE UMA TABLESPACE CUSTOMIZADA:

- Criar um diretório c:/Data (para fazer o BKP deste diretório futuramente);
- Criar o Tablespace do SQL Developer:

CREATE TABLESPACE RECURSOS_HUMANOS
DATAFILE 'C:/DATA/RH_01.DBF'
SIZE 100M AUTOEXTEND
ON NEXT 100M
MAXSIZE 4096M;

** O arquivo criado já ocupa 100Mb, quando criado, e só vai crescer após atingir a capacidade de 100Mb.

ALTERAR A TABLESPACE (LÓGICO), ASSOCIANDO OUTRO ARQUIVO FÍSICO (DBF) NELA:

ALTER TABLESPACE RECURSOS_HUMANOS
ADD DATAFILE 'C:/DATA/RH_02.DBF'
SIZE 100M AUTOEXTEND
ON NEXT 100M
MAXSIZE 4096M;

** Com dois ou mais arquivos associados a mesma Tablespace, as tabelas serão inseridas nos arquivos DBF seguindo um critério da Oracle.

VERIFICANDO A SITUAÇÃO DAS TABLESPACES DO DICIONÁRIO DE DADOS:

SELECT TABLESPACE_NAME, FILE_NAME
FROM DBA_DATA_FILES;

SEQUENCES: São colunas incrementadas por números.

MySQL     => AUTO_INCREMENT (Faz parte da tabela)
Oracle    => SEQUENCE (Faz parte do BD inteiro)
SQLServer => IDENTITY (Faz parte da tabela)

CREATE SEQUENCE SEQ_GERAL
START WITH 100
INCREMENT BY 10;

** Quando criamos várias tabelas com a mesma SEQUENCE, a PK das tabelas irá pegar os registros (números da SEQUENCE) disponíveis. Ou seja, a mesma SEQUENCE fornece os números disponíveis para as duas tabela sob demanda.

Ex. TABELA A      TABELA B
   PK 100          PK 110
   PK 130          PK 120
   
CRIANDO UMA TABELA NA TABLESPACE:

CREATE TABLE FUNCIONARIOS(
	ID_FUNCIONARIO INT PRIMARY KEY,
	NOME VARCHAR2(30)
)TABLESPACE RECURSOS_HUMANOS;

** O VARCHAR2 (padrão Oracle) irá distinguir entre strings NULL e vazia. Ambos, VARCHAR (padrão ANSI) E VARCHAR2 possuem a mesma funcionalidade, porém é melhor usar VARCHAR2. O comprimento máximo de caractérem em ambos é 4000 bytes (4000 caracteres).

INSERINDO OS REGISTROS NA TABELA FUNCIONARIOS:

** Atribuição do SEQUENCE é somente no momento da inserção dos dados na tabela.

INSERT INTO FUNCIONARIOS VALUES(SEQ_GERAL.NEXTVAL,'JOAO');
INSERT INTO FUNCIONARIOS VALUES(SEQ_GERAL.NEXTVAL,'CLARA');
INSERT INTO FUNCIONARIOS VALUES(SEQ_GERAL.NEXTVAL,'LILIAN');

SELECT * FROM FUNCIONARIOS;

** Atençao! Para salvar as alterações no banco, precisamos efetuar o COMMIT (F11).

BACKUP NO ORACLE:

Utilizando uma ferramenta mais eficiente do que o RMAN Oracle.

No Oracle podemos fazer a manutenção de apenas uma parte do banco sem indisponibilizar o acesso de outros usuários às demais partes do banco, que não estão tendo intervensões que impossibilitem o seu acesso.

CRIANDO UMA TABLESPACE MARKETING:

CREATE TABLESPACE MARKETING
DATAFILE 'C:/DATA/MKT_01.DBF'
SIZE 100M AUTOEXTEND
ON NEXT 100M
MAXSIZE 4096M;

CRIANDO UMA TABELA NA TABLESPACE MKT_01.DBF:

CREATE TABLE CAMPANHAS(
	ID_CAMPANHA INT PRIMARY KEY,
	NOME VARCHAR2(30)
)TABLESPACE MARKETING;

INSERINDO OS REGISTROS NA TABELA CAMPANHAS:

** Atribuição do SEQUENCE é somente no momento da inserção dos dados na tabela.

INSERT INTO CAMPANHAS VALUES(SEQ_GERAL.NEXTVAL,'PRIMAVERA');
INSERT INTO CAMPANHAS VALUES(SEQ_GERAL.NEXTVAL,'VERAO');
INSERT INTO CAMPANHAS VALUES(SEQ_GERAL.NEXTVAL,'INVERNO');

SELECT * FROM CAMPANHAS;

1) Criamos uma pasta para fazer o Backup no C:/BACKUP_ORACLE;
2) Antes temos que deixar a parte do banco, que terá manutenção OFFLINE:
	ALTER TABLESPACE RECURSOS_HUMANOS OFFLINE;
3) Atenção: Sempre copiar os arquivos (sem excluir os originais);
4) CTRL+C (C:/DATA/RH_01.DBF) e (C:/DATA/RH_02.DBF) para (C:/BACKUP_ORACLE);
5) Após copiar, temos que apontar para o dicionário de dados:
	ALTER TABLESPACE RECURSOS_HUMANOS
	RENAME DATAFILE 'C:/DATA/RH_01.DBF' TO 'C:/BACKUP_ORACLE/RH_01.DBF';
	
	ALTER TABLESPACE RECURSOS_HUMANOS
	RENAME DATAFILE 'C:/DATA/RH_02.DBF' TO 'C:/BACKUP_ORACLE/RH_02.DBF';
6) Tornando a TABLESPACE ONLINE:
	ALTER TABLESPACE RECURSOS_HUMANOS ONLINE;

SELECT * FROM FUNCIONARIOS;
SELECT * FROM CAMPANHAS;

PSEUDO COLUNAS:

Excluir a antes tabela, para ver seu já foi criada:
DROP TABLE ALUNO;

CREATE TABLE ALUNO(
	ID_ALUNO INT PRIMARY KEY,
	NOME VARCHAR2(30),
	EMAIL VARCHAR2(30),
	SALARIO NUMBER(10,2)
);

CRIANDO UMA SEQUENCE (é um outro objeto que não pertence a tabela):
** Para usar os números de uma SEQUENCE, precisamos demandar ela em um INSERT

CREATE SEQUENCE SEQ_EXEMPLO;

INSERINDO DADOS NA TABELA ALUNO:

INSERT INTO ALUNO2 VALUES(SEQ_EXEMPLO.NEXTVAL, 'JOAO', 'JOAO@GMAIL.COM', 1000.00);
INSERT INTO ALUNO2 VALUES(SEQ_EXEMPLO.NEXTVAL, 'CLARA', 'CLARA@GMAIL.COM', 2000.00);
INSERT INTO ALUNO2 VALUES(SEQ_EXEMPLO.NEXTVAL, 'CELIA', 'CELIA@GMAIL.COM', 4000.00);

SELECT * FROM ALUNO;

CREATE TABLE ALUNO2(
	ID_ALUNO INT PRIMARY KEY,
	NOME VARCHAR2(30),
	EMAIL VARCHAR2(30),
	SALARIO NUMBER(10,2)
);

SELECT * FROM ALUNO;
SELECT * FROM ALUNO2;

TEMOS 2 PSEUDO COLUNAS:
- ROWID (endereço físico do registro no BD, sempre único);
SELECT ROWID, ID_ALUNO, NOME, EMAIL FROM ALUNO;

** O acesso pelo endereço físico é sempre mais rápido.
SELECT ID_ALUNO, NOME, EMAIL FROM ALUNO
WHERE ROWID = 'AAAStNAABAAAbdRAAC';

- ROWNUM (é utilizado para paginar registros)
SELECT ROWID, ROWNUM, ID_ALUNO, NOME, EMAIL FROM ALUNO;

PAGINANDO OS REGISTROS:
SELECT NOME, EMAIL FROM ALUNO
WHERE ROWNUM <= 2;

VERIFICANDO AS COLUNAS NO ORACLE:

DESC nome_da_tabela;
DESCRIBE nome_da_tabela;

TRIGGERS(GATILHO):

Temos duas formas de programar uma TRIGGER:

1) Dentro da TRIGGER (a TRIGGER é disparada através de um evento, INSERT, DELETE, etc);
2) Fazendo uma PROCEDURE => Programação (a TRIGGER é disparada e chama a PROCEDURE).
Temos dois tipos de objetos de programação no Oracle:
- Nomerados (recebe um nome para ser executa no BD, fica salva no BD);
- Anônimos (usada para teste, NÃO fica salva no BD).

CRIAÇÃO DE UMA PROCEDURE:

** OR REPLACE => é opcional
* ALUNO,ID_ALUNO%TYPE => Usando assim a procedure fica com o tipo dinâmico. Se for alterado o tipo na tabela, a PROCEDURE irá seguir o tipo da tabela.

CREATE OR REPLACE PROCEDURE BONUS(P_ID_ALUNO ALUNO.ID_ALUNO%TYPE, P_PERCENT NUMBER)
AS
	BEGIN
		UPDATE ALUNO SET SALARIO = SALARIO + (SALARIO * (P_PERCENT/ 100))
		WHERE P_ID_ALUNO = P_ID_ALUNO;
	
	END;

SELECT * FROM ALUNO;

ATRIBUINDO UM AUMENTO PARA A CELIA:

CALL BONUS(3,10);

SELECT * FROM ALUNO;

** As TRIGGERS DEVEM TER O TAMANHO MÁXIMO DE 32Kb.
Não executam comandos de DTL => COMMIT, ROLLBACK E SAVEPOINTS.

CRIANDO UMA TRIGGER DE VALIDAÇÃO:

CREATE OR REPLACE TRIGGER CHECK_SALARIO
BEFORE INSERT OR UPDATE ON ALUNO
FOR EACH ROW
	BEGIN
		IF :NEW.SALARIO < 2000 THEN
			RAISE_APPLICATION_ERROR(-20000, 'VALOR INCORRETO');
		END IF;
END;
/

* Sempre termina com a barra.
* ERRO -20000 é um erro do usuário.

* Mostra a descrição do último erro.
SHOW ERRORS;

TESTANDO A TRIGGER:

INSERT INTO ALUNO VALUES(SEQ_EXEMPLO.NEXTVAL, 'MAFRA', 'MAFRA@GMAIL.COM', 100.00);

COMO OBTER INFORMAÇÕES SOBRE TRIGGERS?

SELECT TRIGGER_NAME, TRIGGER_BODY
FROM USER_TRIGGERS;

TRIGGER DE EVENTOS (PARA CAPTURAR EVENTOS):

CREATE TABLE AUDITORIA(
	DATA_LOGIN DATE,
	LOGIN VARCHAR2(30)
);

CREATE OR REPLACE PROCEDURE LOGPROC IS
BEGIN
	INSERT INTO AUDITORIA(DATA_LOGIN, LOGIN) VALUES(SYSDATE, USER);
END LOGPROC;

CREATE OR REPLACE TRIGGER LOGTRIGGER
AFTER LOGON ON DATABASE
CALL LOGPROC

DATA DO SISTEMA:
SELECT SYSDATE FROM DUAL;

USUÁRIO CONECTADO NO BANCO:
SELECT USER FROM DUAL;

CONECTANDO PELO CMD:

 (system usuário/senha)
>sqlplus system/1234

TRIGGER DE FALHA DE LOGON:

CREATE OR REPLACE TRIGGER FALHA_LOGON
AFTER SERVERERROR
ON DATABASE
BEGIN
	IF(IS_SERVERERROR(1017)) THEN
		INSERT INTO AUDITORIA(DATA_LOGIN, LOGIN)
		VALUES(SYSDATE,'ORA-1017');
	END IF;
END FALHA_LOGON;

TESTAR (SENHA ERRADA):

CMD
>sqlplus system/3445576

FAZER O SELECT:

SELECT * FROM AUDITORIA;

ALGUNS ERROS E CÓDIGOS (ver documentação Oracle):

1004 => default username feature not support
1005 => password nulo
1045 => privilegio insuficiente

TRIGGER DE DML (ENVIAR/SALVAR PARA UMA TABELA DE BACKUP):

CREATE TABLE USUARIO(
	ID INT,
	NOME VARCHAR2(30)
);

CREATE TABLE BKP_USER(
	ID INT,
	NOME VARCHAR2(30)
);

INSERT INTO USUARIO VALUES(1, 'JOAO');
INSERT INTO USUARIO VALUES(2, 'CLARA');

COMMIT;

SELECT * FROM USUARIO;

CRIAÇAO DA TRIGGER:

ATENÇÃO: Para evitar possíveis problemas, use sempre BEFORE na Trigger (antes enviar para BKP).

** Usamos :OLD pois queremos pegar os valores que já estão na tabela. Se quisermos pegar um valor que está entrando na tabela, usaríamos o :NEW.

CREATE OR REPLACE TRIGGER LOG_USUARIO
BEFORE DELETE ON USUARIO
FOR EACH ROW
BEGIN
	INSERT INTO BKP_USER VALUES(:OLD.ID, :OLD.NOME);
END;

DELETANDO UM USUÁRIO:

SELECT * FROM BKP_USER;

DELETE FROM USUARIO
WHERE ID = 1;

SELECT * FROM BKP_USER;
SELECT * FROM USUARIO;

OPERAÇÕES COM VIEWS:

CREATE TABLE CLIENTE(
	ID_CLIENTE INT PRIMARY KEY,
	NOME VARCHAR2(30),
	SEXO CHAR(1)
);

INSERT INTO CLIENTE VALUES(1007, 'MAFRA', 'M');

COMMIT;

SELECT * FROM CLIENTE;

CRIANDO UMA VIEW:

CREATE OR REPLACE VIEW V_CLIENTE
AS
	SELECT ID_CLIENTE, NOME, SEXO
	FROM CLIENTE;

ADICIONANDO REGISTROS EM UMA VIEW EM CLIENTE:

INSERT INTO V_CLIENTE VALUES(1008, 'CLARA', 'F');

SELECT * FROM CLIENTE;
SELECT * FROM V_CLIENTE;

** Não conseguimos inserir (com INSERT comum) quando a VIEW tem JOIN.

CRIANDO UMA VIEW SOMENTE LEITURA (RO) => MELHOR OPÇÃO, POIS NÃO PRECISA DAR PERMISSÃO:

CREATE OR REPLACE VIEW V_CLIENTE_RO
AS
	SELECT ID_CLIENTE, NOME, SEXO
	FROM CLIENTE
	WITH READ ONLY;
	
INSERT INTO V_CLIENTE_RO VALUES(1009,'LILIAN','F');

SQL Error: ORA-42399: cannot perform a DML operation on a read-only view
42399.0000 - "cannot perform a DML operation on a read-only view"

VIEW DE JOIN:

CREATE OR REPLACE VIEW RELATORIO
AS
	SELECT NOME, SEXO, NUMERO
	FROM CLIENTE
	INNER JOIN TELEFONE
	ON ID_CLIENTE = FK_ID_CLIENTE;
	
** Vamos fazer o VIEW com JOIN para uma tabela que ainda não existe (com FORCE).

CREATE OR REPLACE FORCE VIEW RELATORIO
AS
	SELECT NOME, SEXO, NUMERO
	FROM CLIENTE
	INNER JOIN TELEFONE
	ON ID_CLIENTE = FK_ID_CLIENTE;
	
Warning: View created with compilation errors.

SELECT * FROM RELATORIO;

##the view's defining query to a non-existent table.##

CRAINDO A TABELA TELEFONE:

CREATE TABLE TELEFONE(
	ID_TELEFONE INT PRIMARY KEY,
	NUMERO VARCHAR2(10),
	FK_ID_CLIENTE INT
);

CRIANDO A CONSTRAINT:

** O Oracle já identifica a coluna da chave primária automaticamente.
ALTER TABLE TELEFONE ADD CONSTRAINT FK_CLIENTE_TELEFONE
FOREIGN KEY(FK_ID_CLIENTE) REFERENCES CLIENTE;

** Podemos usar CLIENTE(ID_CLIENTE), mas não é necessário
ALTER TABLE TELEFONE ADD CONSTRAINT FK_CLIENTE_TELEFONE
FOREIGN KEY(FK_ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE);

INSERINDO REGISTROS:

INSERT INTO TELEFONE VALUES(1, '3244353645', 1007);

COMMIT;

SELECT * FROM RELATORIO;

DEFERRABLE CONSTRAINTS:

O comportamento padrão nos BD relacionais é verificar se existe a PK na tabela mãe pela tabela filha FK, logo após o INSERT INTO (DML) (uma a uma). Este procedimento causa maior lentidão (ou perda de performance) e possíveis inconsistência, pois a verificação pára logo que não é localiza a PK na tabela mãe. Isto poderá causar um ROLLBACK em todos os registros inseridos até o momento da localização da PK faltante (em inserções em massa).

CRIANDO O CENÁRIO:

CREATE TABLE FUNCIONARIO(
	-- Foi nomeda a CONSTRAINT para PK_FUNCIONARIO
	ID_FUNCIONARIO INT CONSTRAINT PK_FUNCIONARIO PRIMARY KEY,
	NOME VARCHAR2(100)
);

DROP TABLE TELEFONE;

CREATE TABLE TELEFONE(
	-- Na tabela TELEFONE a CONSTRAINT será nomeda automaticamente pelo Oracle
	ID_TELEFONE INT PRIMARY KEY,
	NUMERO VARCHAR2(10),
	FK_ID_FUNCIONARIO INT
);

ALTER TABLE TELEFONE ADD CONSTRAINT FK_TELEFONE
FOREIGN KEY(FK_ID_FUNCIONARIO) REFERENCES FUNCIONARIO;

INSERT INTO FUNCIONARIO VALUES(1,'MAURICIO');
INSERT INTO TELEFONE VALUES(10, '34568935', 1);

SELECT * FROM FUNCIONARIO;
SELECT * FROM TELEFONE;

A CONSTRAINT DE INTEGRIDADE REFERENCIAL (FK) CHECA A INTEGRIDADE LOGO APÓS O COMANDO DE DML (INSERT/ DELETE/ UPDATE) => NÃO POSSIBILITA ASSIM A INSERÇÃO DE REGISTROS SEM REFERÊNCIA NA TABELA MÃE (PK).

INSERT INTO TELEFONE VALUES(2, '48317036', 34);

** Não podemos inserir registros na tabela filha, onde não existe PK na tabela mãe.
Error report -
ORA-02291: integrity constraint (SYSTEM.FK_TELEFONE) violated - parent key not found

DELETE FROM FUNCIONARIO WHERE ID_FUNCIONARIO = 1;

** Não podemos excluir registros (PK) da tabela mãe que possui registro(s) (FK) na tabela filha. O registro ficaria com um registro sem ter a referência na tabela mãe.
Error report -
ORA-02292: integrity constraint (SYSTEM.FK_TELEFONE) violated - child record found

VERIFICANDO O ESTADO DAS CONSTRAINTS:

SELECT CONSTRAINT_NAME, DEFERRABLE, DEFERRED
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN('FUNCIONARIO','TELEFONE');

DEFERRED (IMMEDIATE)=> (DML ou DTL) Após a operação de DML a checágem será IMEDIATA.
DEFERRABLE (NOT DEFERRABLE) => Significa que as chaves não podem ter a verificação atrasada (após a operação de DML), sendo assim a verificação será logo após cada operação de DML (INSERT, DELETE, etc). YES DEFERRABLE, ela pode ser verificada na DML ou DTL. ## Padrão ##

PRIMEIRO AÇÃO PARA ALTERAR O COMPORTAMENTO PADRÃO (DML):

APAGAR A CONSTRAINT:

ALTER TABLE TELEFONE DROP CONSTRAINT FK_TELEFONE;

RE-CRIANDO A CONSTRAINT:

** Criando a CONSTRAINT e definindo que ela pode ser ATRASADA (DTL). Não significa que ela esteja verificando na DTL. Ela ainda está verificando na DML.
ALTER TABLE TELEFONE ADD CONSTRAINT FK_TELEFONE
FOREIGN KEY(FK_ID_FUNCIONARIO) REFERENCES FUNCIONARIO
DEFERRABLE;

SELECT CONSTRAINT_NAME, DEFERRABLE AS ATRASADA, DEFERRED AS VERIFICACAO
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN('FUNCIONARIO','TELEFONE');

TESTANDO SE ELA PODE SER ATRASADA:
* Ainda está apresentando ERRO, pois a verificação é imediata, mesmo podendo ser atrasada.
INSERT INTO TELEFONE VALUES(4, '4578903',10);

MUDANDO PARA A DTL:

SET CONSTRAINTS ALL DEFERRED;

* Ainda não está alterado o DEFERRED IMMEDIATE, pois este status é da criação da CONSTRAINT.
SELECT CONSTRAINT_NAME, DEFERRABLE AS ATRASADA, DEFERRED AS VERIFICACAO
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN('FUNCIONARIO','TELEFONE');

* Deixa inserir, mas fica sem integridade referencial com a tabela mãe.
INSERT INTO TELEFONE VALUES(4, '4578903',10);

* Após o COMMIT o Oracle encontra inconsistência e faz o ROLLBACK.
COMMIT;

SELECT * FROM FUNCIONARIO;
SELECT * FROM TELEFONE;

DDL => Data Definition Language (DDL) statements are used to define the database structure or schema. 

Some examples:

CREATE - to create objects in the database;
ALTER - alters the structure of the database;
DROP - delete objects from the database;
TRUNCATE - remove all records from a table, including all spaces allocated for the records are removed,rollback inot possible,faster than DELETE;
COMMENT - add comments to the data dictionary;
RENAME - rename an object.

DML => Data Manipulation Language (DML) statements are used for managing data within schema objects. 

Some examples:

SELECT - retrieve data from the a database;
INSERT - insert data into a table;
UPDATE - updates existing data within a table;
DELETE - deletes all records from a table, the space for the records remain,ROLLBACK is possible,slower than TRUNCATE;
MERGE - UPSERT operation (insert or update);
CALL - call a PL/SQL or Java subprogram;
EXPLAIN PLAN - explain access path to data;
LOCK TABLE - control concurrency.

DCL => Data Control Language (DCL) statements. 

Some examples:

GRANT - gives user's access privileges to database;
REVOKE - withdraw access privileges given with the GRANT command.

TCL => Transaction Control (TCL) statements are used to manage the changes made by DMLstatements. It allows statements to be grouped together into logical transactions.

COMMIT - save work done;
SAVEPOINT - identify a point in a transaction to which you can later roll back;
ROLLBACK - restore database to original since the last COMMIT;
SET TRANSACTION - Change transaction options like isolation level and what rollback segment to use?

INTRODUÇÃO A DATA SCIENCE (BIG DATA):

Dado       => pura sem contexto;
Informação => tem relevância e contexto.

Google Trendings => Verifica as palavras de tendência no mundo todo.

FERRAMENTAS DE ETL:

- POWER CENTER (PAGO);
- ORACLE ODI (PAGO);
- TALEND (FREE);
- PDI (SPOON) (FREE).
*/
