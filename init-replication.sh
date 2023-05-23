#!/bin/bash

echo "Waiting for MySQL to start..."
until mysqladmin ping -hbdm1 -uroot -psenha1; do
  sleep 1
done

echo "Configuring replication..."

# Get the current binary log file and position from db1
# (Obtenha o arquivo de log binário atual e a posição do db1)
LOG_FILE=$(mysql -hbdm1 -uroot -psenha1 -e "SHOW MASTER STATUS \G" | awk '/File:/ {print $2}')
LOG_POS=$(mysql -hbdm1 -uroot -psenha1 -e "SHOW MASTER STATUS \G" | awk '/Position:/ {print $2}')

# Configure db2 as a replica of db1
mysql -hbdm2 -uroot -psenha1 -e "CHANGE MASTER TO MASTER_HOST='bdm1', MASTER_USER='repl', MASTER_PASSWORD='password', MASTER_LOG_FILE='$LOG_FILE', MASTER_LOG_POS=$LOG_POS; START SLAVE;"
mysqldump -hbdm1 -uroot -psenha1 --all-databases | mysql -hlocalhost -uroot -psenha1

echo "Replication configured successfully!"



O comando LOG_FILE=$(mysql -hbdm1 -uroot -psenha1 -e "SHOW MASTER STATUS \G" | awk '/File:/ {print $2}') é usado para obter o nome do arquivo de log binário do servidor MySQL. Vamos analisar o comando por partes:

mysql -hbdm1 -uroot -psenha1 -e "SHOW MASTER STATUS \G": Este trecho executa o comando mysql para se conectar ao servidor MySQL no host bdm1 usando o nome de usuário root e a senha senha1. O parâmetro -e permite especificar uma consulta SQL a ser executada. Neste caso, a consulta é SHOW MASTER STATUS \G, que retorna informações sobre o estado atual da replicação no formato de lista.

| awk '/File:/ {print $2}': O operador | é usado para redirecionar a saída do comando anterior para o comando awk. O comando awk é uma ferramenta poderosa de processamento de texto em linha de comando. Neste caso, estamos usando o awk para filtrar a saída do mysql e extrair o valor do campo "File". O padrão /File:/ especifica que estamos procurando pela linha que contém a palavra "File:". Em seguida, {print $2} é usado para imprimir o valor do segundo campo na linha, que é o nome do arquivo de log binário.

LOG_FILE=$(...): O trecho LOG_FILE= é usado para atribuir o resultado do comando inteiro à variável LOG_FILE. O valor retornado pelo comando $(...) é capturado e atribuído à variável LOG_FILE.

Em resumo, esse comando é usado para obter o nome do arquivo de log binário do servidor MySQL e atribuí-lo à variável LOG_FILE para uso posterior no script ou na linha de comando.
