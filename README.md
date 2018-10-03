<h1>Definição do Trabalho</h1>

Considerando os dados presentes no arquivo classificação_Q3.csv, pede-se:

• Implementar o classificador Naïve Bayes.

• Após 30 rodadas de treinamento e teste, calcular a taxa de acerto (i) média, (ii) mínima e (iii) máxima. Obs.: A cada rodada todo o dataset deve ser embaralhado e as bases de treinamento e teste devem ser refeitas.

• Calcular também as taxas de acerto médio por classe.

• Avaliar como as taxas de acerto variam em função da quantidade de dados usados para treinar (projetar) o classificador. Iniciar separando os dados na proporção 20/80 (20% para treinamento e 80% para teste) e então alterar a proporção de 1 em 1 até a proporção 80/20 (80% para treinamento e 20% para teste). Fazer um gráfico do erro de classificação em função da porcentagem de vetores de treinamento usados no projeto do classificador.


<h1> Instruções </h1>


                                        Disciplina: Inteligência Artificial
                                        Professor: Aragão Junior
                                        Equipe: 
                                        Reginaldo Maranhão
                                        Ruan Nícolas

Trabalho Naive Bayes

1.	Requisitos: 
- Instalar o R-Studio

- Instalar o pacote: dplyr


2.	O código é composto por 3 funções:

- Naive: Onde foi implementado o algoritmo para classificação

- Processa: Que retorna uma lista com as taxas min, max e média de acertos após 30 rodas com proporção 80/20 e também retorna as taxas médias de acerto por classe.

- Processa2: Onde treina da proporção 20/80 até a 80/20 e retorna um gráfico mostrando a taxa média para cada proporção.


3.	Passo a passo:

- Carrega o arquivo com as funções: source("C:\\Caminho até o arquivo\\naive.r")

- Carrega o arquivo de dados, que alteramos um pouco a estrutura: dataset = as.matrix(read.table("C:\\Caminho até o arquivo\\trabalho.dat", header=T))

- Chama a função processa e passa a variável onde carregou os dados por parâmetro: processa(dataset)
                                        <img src="http://i66.tinypic.com/24bnguv.png"/>
 
- Chama a função processa2 e passa a variável onde carregou os dados por parâmetro, OBS: Nos nossos computadores demorou um pouco até retornar o resultado para essa operação: processa2(dataset)
                                        <img src="http://i66.tinypic.com/2rdetef.jpg"/>

                                        #bayes #naivebayes #algoritmos #ia 

