# Instruções do Copilot para CURSO-DEVOPS

Propósito
- Orientação curta e prática para agentes de IA que trabalham neste repositório de notas e laboratórios.

Visão geral
- Este repositório é uma coleção de anotações de estudo e artefatos de laboratório sobre vários tópicos de DevOps: AWS, Docker, Kubernetes, Terraform, Prometheus e Linux. A maior parte do conteúdo é composta por lições em Markdown; os artefatos executáveis estão concentrados na pasta `KUBERNETES` (manifests K8s).

Diretórios-chave e exemplos
- `KUBERNETES`: manifests de exercícios e exemplos YAML. Veja [KUBERNETES/aula2-deployment.yaml](KUBERNETES/aula2-deployment.yaml) e [KUBERNETES/aula6-persistentvolume.yaml](KUBERNETES/aula6-persistentvolume.yaml).
- `TERRAFORM`, `DOCKER`, `PROMETHEUS`, `LINUX`: principalmente lições em Markdown (notas), não projetos executáveis.
- `README.md` na raiz: visão geral do repositório e ponto de partida esperado.

O que um agente deve assumir
- Não existe uma configuração centralizada de build, testes ou CI. A maioria das tarefas é educativa: editar notas, melhorar exemplos ou adicionar pequenos demos executáveis.
- Para trabalhos com Kubernetes, assuma que o usuário aplicará manifests em um cluster local (kind, minikube) ou remoto. Não tente criar clusters a partir do repositório.

Fluxos de trabalho do desenvolvedor (como verificar alterações)
- Teste rápido de manifests K8s (requer cluster local):

```bash
# aplicar todos os manifests na pasta KUBERNETES
kubectl apply -f KUBERNETES/
# inspecionar recursos
kubectl get all
# remover os exemplos
kubectl delete -f KUBERNETES/
```

- Para editar por exemplo `KUBERNETES/aula2-deployment.yaml`, execute `kubectl apply -f KUBERNETES/aula2-deployment.yaml` e então `kubectl rollout status deployment/<nome-do-deployment>`.

Convenções específicas do projeto
- Os arquivos usam cabeçalhos em português e nomes com espaços (ex.: `SEÇÃO 01: Iniciando.md`). Preserve os nomes originais ao modificar o conteúdo.
- As lições em Markdown são fontes autoritativas: evite reformatar ou renomear arquivos a menos que solicitado.
- Manifests K8s seguem o padrão de nomenclatura `aulaX-*.yaml` — crie novos manifests usando o mesmo padrão ao adicionar exemplos.

Pontos de integração e padrões a observar
- Os manifests K8s modelam padrões comuns de sala de aula: `Deployment`, `StatefulSet`, `PersistentVolume`/`PersistentVolumeClaim`, `StorageClass`. Reutilize convenções e labels existentes ao adicionar exemplos.
- Não há definições óbvias de serviços externos (não existem Dockerfiles, planos Terraform ou charts Helm evidentes). Se adicionar exemplos executáveis Docker ou Terraform, inclua um README curto na pasta explicando pré-requisitos.

Como um agente de IA deve agir (faça e não faça)
- Faça: alterações mínimas e focadas; adicione notas esclarecedoras nas lições em Markdown; coloque pequenos exemplos executáveis dentro de `KUBERNETES/` seguindo a convenção de nomes.
- Faça: referencie arquivos existentes quando adicionar exemplos (link de volta à lição que motivou o exemplo).
- Não faça: renomeie ou reorganize arquivos de lições sem aprovação do mantenedor.
- Não faça: assuma a existência de CI, ferramentas de build ou manifests de pacotes — pergunte antes de introduzi-los.

Exemplos para referenciar em PRs
- Ao propor mudanças em exemplos Kubernetes, referencie o arquivo e linhas, por exemplo, atualize [KUBERNETES/aula6-persistentvolume.yaml](KUBERNETES/aula6-persistentvolume.yaml).

Perguntas para o mantenedor
- Quais pastas devemos manter estritamente como notas somente leitura versus pastas onde demos executáveis são bem-vindos?
- Prefere novos demos executáveis em uma pasta dedicada `examples/` ou ao lado dos arquivos de lição?

Se algo aqui não estiver claro, diga qual área você quer que eu expanda ou em qual pasta você deseja que eu adicione exemplos.
