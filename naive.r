naive <- function(dataset, query, minimal.prob = 1e-7) {
  #Identificando as classes existentes no dataset
  classId = ncol(dataset)
  classes = unique(dataset[,classId])
  
  #Seta todas as probabilidades em 0
  probabilidades = rep(0, length(classes))
  
  #Laço que percorre todas as classes existentes
  for (i in 1:length(classes)) {
    #Calcula a probabilidade da classe
    P_classe = sum(dataset[,classId] == classes[i]) / nrow(dataset)
    
    #Para evitar multiplicação pro zero calculamos o log da probabilidade e somamos ao invez de multiplica
    #No final convertemos de volta com exponencial
    probabilidades[i] = probabilidades[i] + log(P_classe)
    
    #Laço para calcular as probabilidades de cada atributo da evidência
    for(j in 1:length(query)) {
      Attr_j = query[j]
      if (Attr_j != "?") {
        P_Atrr_j_classe = sum(dataset[,j] == Attr_j & dataset[,classId] == classes[i]) / sum(dataset[,classId] == classes[i])
        if (P_Atrr_j_classe == 0) {
          P_Atrr_j_classe = minimal.prob
        }
        probabilidades[i] = probabilidades[i] + log(P_Atrr_j_classe)
      }
    }
  }
  #Calculando a exponencial pois utilizamos log das probabilidades
  probabilidades = exp(probabilidades)
  
  #Retornando uma lista com as probabilidades
  ret = list()
  ids = sort.list(classes)
  ret$classes = classes[ids]
  ret$prob = probabilidades[ids] / sum(probabilidades[ids])
  
  return (ret)
}

processa <- function(dataset) {
  txAcertos<-c()
  txAcertosZero<-c()
  txAcertosUm<-c()
  
  #Laço para rodar 30vezes a base de teste
  for (j in 1:30) {
    #Embaralhando a base original
    dataset <- dataset[sample(1:nrow(dataset)), ]

    #Quebrando o dataset em treino e teste (80/20) OBS: Buscando as linhas de forma aleotória
    library(dplyr)
    dataTreino<-as.matrix(sample_frac(as.data.frame(dataset), 0.80))
    sid<-as.numeric(rownames(dataTreino))
    dataTeste<-as.matrix(as.data.frame(dataset)[-sid,])
    
    #Variáveis para controlar os acertos do algoritmo
    qntZero = 0
    qntUm = 0
    qntAcertosZero = 0
    qntAcertosUm = 0
    
    #Laço para percorrer todas as linha do dataframe de teste
    for (i in 1: (nrow(dataTeste))) {
      #Recebe a linha atual do conjunto de teste
      linha = dataTeste[i,]
      
      #Montando a proxima linha que será classificada
      q <- c(linha[1], linha[2], linha[3], linha[4], "?")
      
      #Chamando a função que classifica a query atual
      cfd = naive(dataTreino, q)
      
      #Verificando quantas chamadas teve de cada classe
      if (linha[5] == "0") {
        qntZero = qntZero + 1
      }
      else {
        qntUm = qntUm + 1
      }
      
      #Verificando se o algoritmo acertou na classificação
      if (cfd$prob[1] > cfd$prob[2]) {
        if(linha[5] == "0") {
          qntAcertosZero = qntAcertosZero + 1
        }
      }
      else {
        if(linha[5] == "1") {
          qntAcertosUm = qntAcertosUm + 1
        }
      }
    }
    
    #Calculando a taxa de acertos (Numero de acertos total / Quantidade de elementos testados)
    txAcerto = (qntAcertosZero + qntAcertosUm) / (qntZero + qntUm)
    
    #Calculando a taxa de acertos para classe zero (Numero de acertos zero / Quantidade de elementos testados para zero)
    txAcertoZero = qntAcertosZero / qntZero
    
    #Calculando a taxa de acertos (Numero de acertos um / Quantidade de elementos testados para um)
    txAcertoUm = qntAcertosUm / qntUm
    
    txAcertos[j]<-txAcerto
    txAcertosZero[j]<-txAcertoZero
    txAcertosUm[j]<-txAcertoUm
  }
  
  resultado = list()
  
  resultado$txAcertosMin = min(txAcertos)  
  resultado$txAcertosMax = max(txAcertos)
  resultado$txAcertosMed = median(txAcertos)
  resultado$txAcertosZeroMed = median(txAcertosZero)
  resultado$txAcertosUmMed = median(txAcertosUm)
  
  return (resultado)
}

processa2 <- function(dataset) {
  txMedAcertos<-c()
  testes<-c()
  
  #Laço para alterar as proporções de 1 em 1 de 20 até 80
  for (k in 1:61) {
    txAcertos<-c()
    
    #Laço para rodar 30vezes a base de teste
    for (j in 1:30) {
      #Embaralhando a base original
      dataset <- dataset[sample(1:nrow(dataset)), ]
      
      #Quebrando o dataset em treino e teste (80/20) OBS: Buscando as linhas de forma aleotória
      library(dplyr)
      dataTreino<-as.matrix(sample_frac(as.data.frame(dataset), (0.19 + (k/100))))
      sid<-as.numeric(rownames(dataTreino))
      dataTeste<-as.matrix(as.data.frame(dataset)[-sid,])
      
      #Variável para controlar os acertos do algoritmo
      qntAcertosTotal = 0
      
      #Laço para percorrer todas as linha do dataframe de teste
      for (i in 1: (nrow(dataTeste))) {
        #Recebe a linha atual do conjunto de teste
        linha = dataTeste[i,]
        
        #Montando a proxima linha que será classificada
        q <- c(linha[1], linha[2], linha[3], linha[4], "?")
        
        #Chamando a função que classifica a query atual
        cfd = naive(dataTreino, q)
        
        #Verificando se o algoritmo acertou na classificação
        if (cfd$prob[1] > cfd$prob[2]) {
          if(linha[5] == "0") {
            qntAcertosTotal = qntAcertosTotal + 1
          }
        }
        else {
          if(linha[5] == "1") {
            qntAcertosTotal = qntAcertosTotal + 1
          }
        }
      }
      
      #Calculando a taxa de acertos (Numero de acertos total / Quantidade de elementos testados)
      txAcerto = qntAcertosTotal / nrow(dataTeste)
      
      txAcertos[j]<-txAcerto
    }
    
    txMedAcertos[k]<-median(txAcertos)
    testes[k]<-(0.19 + (k/100))
  }
  
  resultado = list()
  
  resultado$txMedAcertos = txMedAcertos 
  resultado$testes = testes
  
  return (plot(resultado$txMedAcertos~resultado$testes))
}