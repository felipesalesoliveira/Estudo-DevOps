# Skills

As habilidades abaixo são necessárias para completar as etapas de deployment:

- Gerenciamento de Usuários Linux  
- Permissões  
- Estrutura de Diretórios  
- Sistemas de Arquivos  
- Gerenciamento de Arquivos  

---

# Pré-requisitos

Fazer login na AWS Cloud e criar uma instância EC2 (t2.micro) baseada em Linux para completar o exercício abaixo.

---

# Deployment

## Login como superuser (root) e executar as etapas abaixo

- Criar usuários e definir senhas – `user1`, `user2`, `user3`
- Criar grupos – `devops`, `aws`
- Alterar o grupo primário dos usuários `user2` e `user3` para o grupo `devops`
- Adicionar o grupo `aws` como grupo secundário do usuário `user1`
- Criar a estrutura de arquivos e diretórios conforme mostrado no diagrama (diagrama Project-03)
- Alterar o grupo de `/dir1`, `/dir7/dir10`, `/f2` para o grupo `devops`
- Alterar o proprietário de `/dir1`, `/dir7/dir10`, `/f2` para o usuário `user1`

---

## Login como `user1` e executar as etapas abaixo

- Criar usuários e definir senhas – `user4`, `user5`
- Criar grupos – `app`, `database`

---

## Login como `user4` e execute as etapas abaixo

- Criar o diretório – `/dir6/dir4`
- Criar o arquivo – `/f3`
- Mover o arquivo de `/dir1/f1` para `/dir2/dir1/dir2`
- Renomear o arquivo `/f2` para `/f4`

---

## Login como `user1` e executar as etapas abaixo

- Criar o diretório – `/home/user2/dir1`
- Acessar o diretório `/dir2/dir1/dir2/dir10` e criar o arquivo `/opt/dir14/dir10/f1` utilizando caminho relativo
- Mover o arquivo `/opt/dir14/dir10/f1` para o diretório home do `user1`
- Excluir o diretório `/dir4` de forma recursiva
- Excluir todos os arquivos e diretórios filhos dentro de `/opt/dir14` usando um único comando
- Escrever o texto abaixo no arquivo `/f3` e salvar:

  > Linux assessment for an DevOps Engineer!! Learn with Fun!!

---

## Login como `user2` e executar as etapas abaixo

- Criar o arquivo `/dir1/f2`
- Excluir `/dir6`
- Excluir `/dir8`
- Substituir o texto `DevOps` por `devops` no arquivo `/f3` sem utilizar editor
- Utilizando o editor **Vi**, copiar a linha 1 e colar 10 vezes no arquivo `/f3`
- Procurar o padrão `Engineer` e substituir por `engineer` no arquivo `/f3` usando um único comando
- Excluir o arquivo `/f3`

---

## Login como `root` e executar as etapas abaixo

- Procurar pelo arquivo com nome `f3` no servidor e listar todos os caminhos absolutos onde ele for encontrado
- Mostrar a contagem do número de arquivos no diretório `/`
- Imprimir a última linha do arquivo `/etc/passwd`
- Fazer login na AWS e criar um volume EBS de 5GB na mesma AZ da instância EC2 e anexar o volume à instância

---

## Login como `root` e executar as etapas abaixo

- Criar um sistema de arquivos no novo volume EBS anexado na etapa anterior
- Montar o sistema de arquivos no diretório `/data`
- Verificar a utilização do sistema de arquivos usando o comando `df -h`  
  - O comando deve mostrar o sistema de arquivos montado em `/data`
- Criar o arquivo `f1` no sistema de arquivos `/data`

---

## Login como `user5` e executar as etapas abaixo

- Excluir `/dir1`
- Excluir `/dir2`
- Excluir `/dir3`
- Excluir `/dir5`
- Excluir `/dir7`
- Excluir `/f1` e `/f4`
- Excluir `/opt/dir14`

---

## Login como `root` e executar as etapas abaixo

- Excluir os usuários – `user1`, `user2`, `user3`, `user4`, `user5`
- Excluir os grupos – `app`, `aws`, `database`, `devops`
- Excluir os diretórios home de todos os usuários (`user1`, `user2`, `user3`, `user4`, `user5`), caso ainda existam
- Desmontar o sistema de arquivos `/data`
- Excluir o diretório `/data`
- Fazer login na AWS, desanexar o volume EBS da instância EC2, excluir o volume e finalizar a instância EC2

---

## Finalização

Tudo pronto?  
👉 Repetir todos os passos!

**🚀**
