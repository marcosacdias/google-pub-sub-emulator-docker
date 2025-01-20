# 🚀 Emulador Google Pub/Sub com Docker

Este projeto facilita o uso do **Google Pub/Sub Emulator** em um ambiente local com Docker, permitindo o desenvolvimento e teste de sistemas que utilizam Pub/Sub sem depender do ambiente na nuvem.

---

## 🧰 Requisitos
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/) *(opcional)*

---

## ✨ Funcionalidades
- Criação de tópicos e assinaturas no emulador.
- Monitoramento de prontidão com healthcheck.
- Automação por **Makefile**.

---

## 📖 Como Usar

### 1️⃣ Comandos do **Makefile**

| Comando           | Descrição                                   |
|--------------------|--------------------------------------------|
| **`make build`**   | 🛠️ Cria a imagem Docker.                   |
| **`make run`**     | ▶️ Constrói e inicia o emulador.           |
| **`make logs`**    | 📜 Monitora os logs do container.          |
| **`make clean`**   | 🧹 Para e remove o container.              |
| **`make restart`** | 🔄 Limpa e reinicia todo o ambiente.       |
| **`make status`**  | 🔍 Verifica o status e o estado de saúde. |

### 2️⃣ Exemplos de Uso

- Construir e iniciar o container:
  ```bash
  make run
  ```

- Verificar os logs do container:
  ```bash
  make logs
  ```

- Limpar o ambiente:
  ```bash
  make clean
  ```

---

## ⚙️ Configuração Personalizada

Você pode personalizar os tópicos e assinaturas do Pub/Sub via variáveis de ambiente:

- **PUBSUB_PROJECT_ID**: ID do projeto local (padrão: `my-gcp-project`).
- **PUBSUB_CONFIG**: Configuração em JSON com tópicos e assinaturas.

### 📝 Exemplo:
```bash
make run PUBSUB_PROJECT_ID=meu-projeto \
         PUBSUB_CONFIG='[{"name": "meu-topico", "subscriptions": ["minha-assinatura"]}]'
```

---

## 🔥 Dicas Úteis

- **Monitorar logs diretamente:**
  ```bash
  docker logs -f pubsub-emulator
  ```

- **Forçar reconstrução completa:**
  ```bash
  docker system prune -af
  make restart
  ```

---

## 🤝 Contribua
Encontre problemas? Abra um `issue` ou envie um `pull request`. 😊

---

Com o **Makefile**, você terá um emulador local do Pub/Sub totalmente funcional, pronto para testes e desenvolvimento em minutos! 🛠️