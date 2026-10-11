# DevOps Test Task: Nginx Web Application, CI/CD & Monitoring Stack

Репозиторій містить реалізацію тестового завдання DevOps Engineer: контейнеризація веб-сервера на базі **Nginx**, автоматизація складання та розгортання, CI/CD пайплайн у **GitHub Actions**, а також повноцінний стек моніторингу на базі **Prometheus**, **cAdvisor** та **Grafana**.

---

## Стек технологій
* **Веб-сервер:** `nginxinc/nginx-unprivileged:alpine` (безпечний непривілейований образ, працює без root).
* **Контейнеризація:** Docker, Docker Compose.
* **Автоматизація:** Bash (`deploy.sh`).
* **Реєстр образів:** Docker Hub (`squezeeek/hello-panda`).
* **CI/CD:** GitHub Actions.
* **Моніторинг:** Prometheus, cAdvisor, Grafana.

---

## 📁 Структура репозиторію
```text
.
├── .github/workflows/
│   └── deploy.yml          # GitHub Actions CI/CD пайплайн
├── monitoring/
│   └── prometheus.yml      # Конфігурація збору метрик для Prometheus
├── Dockerfile              # Dockerfile веб-сервера з HEALTHCHECK
├── docker-compose.yml      # Стек додатка разом із моніторингом
├── deploy.sh               # Скрипт автоматичної збірки, пушу та деплою
├── index.html              # Статична веб-сторінка
└── README.md               # Документація проєкт
