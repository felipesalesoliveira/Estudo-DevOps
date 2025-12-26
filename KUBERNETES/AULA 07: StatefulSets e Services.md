# **STETAFULSET**
- StatefulSet é um controlador para Pods com identidade fixa e armazenamento persistente.
&nbsp;
# **SERVICE**
- Service é um objeto do Kubernetes que fornece um endereço estável para acessar Pods.
    - CLUSTER IP (Expõe o Service em um IP interno no cluster. Este tipo torna o Service acessível apenas dentro do cluster.)
    - NODEPORT (Expõe o Service na mesma porta de cada Node selecionado no cluster usando NAT. Torna o Service acessível de fora do cluster usando)
    - LOADBALANCER (Cria um balanceador de carga externo no ambiente de nuvem atual (se suportado) e atribui um IP fixo, externo ao cluster, ao Service)
    - EXTERNAL NAME (Mapeia o Service para o conteúdo do campo externalName (por exemplo, foo.bar.example.com), retornando um registro CNAME com seu valor)

