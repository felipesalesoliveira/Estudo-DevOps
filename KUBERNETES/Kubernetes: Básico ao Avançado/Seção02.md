Obtendo YAML de objetos (+bônus krew)
Na aula, utilizamos o krew, usado para instalar extensões do kubectl.

Com o krew instalado, basta instalar o plugin neat para extrair as informações úteis do YAML.

$ kubectl krew install neat
$ kubectl get po <pod> -oyaml | kubectl neat