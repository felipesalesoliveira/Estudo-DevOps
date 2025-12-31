# **CONTAINER**
- Isolamento de recursos
    - Container ENGINE (Quem eu uso no dia a dia)
    - Container RUNTIME (Quem roda o container)
&nbsp;
# **CONTAINER ENGINE**
- Faz build de imagens
- Faz pull/push em registries
- Cria redes e volumes
- Chama o runtime por baixo dos panos
- Ex.: Docker Engine, Docker Desktop, Podman
&nbsp;
# **CONTAINER RUNTIME**
- Cria o container
- Usa recursos do Linux (namespaces, cgroups) 
- Inicia e finaliza processos dentro do container
- Ele não cria imagem, não faz build, não gerencia rede complexa.
- Ex.: CRI-O, Runc, Containerd.
&nbsp;
# **ANALOGIA SIMPLES (obra)**
Engine → Engenheiro + ferramentas (planeja, organiza)
Runtime → Pedreiro (executa o trabalho pesado)
Kernel → Terreno e leis físicas
&nbsp;
# **OCI (Open Container Initiative)**
- A OCI é um conjunto de especificações (regras).
&nbsp;
# **KUBERNETES**
- Orquestrador de Containers. (Controlar, Gerenciar, Organizar)
&nbsp;
# **ARQUITETURA KUBERNETES**
- Control Plane 
    - Responsável por decidir, controlar e orquestrar
    - (API Server, Etcd, Scheduler, Controller Manager)
- Workers 
    - Onde os containers rodam
    - (Kubelet, Container Runtime, Kube-proxy)
&nbsp;
# **POD**
- Menor unidade do Kubernetes
&nbsp;
# **ARQUIVO .YAML MULTI NODE**
- kind: Cluster
- apiVersion: kind.x-k8s.io/v1alpha4
- nodes:
  - role: control-plane
  - role: worker
  - role: worker
