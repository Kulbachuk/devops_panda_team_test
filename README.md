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

Варіанти запуску
1. Швидкий запуск веб-додатка з Docker Hub (Рекомендовано для швидкої перевірки)
Для перевірки роботи самого контейнера без необхідності клонувати репозиторій або щось збирати локально:
docker run -d -p 8080:8080 --name test-app squezeeek/hello-panda:latest
```bash
$ docker run -d -p 8080:8080 --name test-app squezeeek/hello-panda:latest
```
Додаток буде доступний у браузері за адресою: http://localhost:8080.

2. Запуск повного стеку з моніторингом (Docker Compose)
Підняття веб-додатка разом із cAdvisor, Prometheus та Grafana однією командою
```bash
$ docker compose up -d
```
Точки доступу:
Веб-додаток: http://localhost:8080

Prometheus: http://localhost:9090 (таргет cadvisor у статусі UP у меню Status -> Targets)

cAdvisor: http://localhost:8081

Grafana: http://localhost:3000 (Login: admin / Password: admin)

Налаштування дашборду в Grafana:
Перейдіть до Connections -> Data sources, додайте Prometheus та вкажіть URL: http://prometheus:9090. Натисніть Save & test.

Перейдіть до Dashboards -> New -> Import, введіть ID дашборду: 14282 (або 893), оберіть джерело Prometheus і натисніть Import.

3. Автоматичний запуск через скрипт (deploy.sh)
Скрипт демонструє повний локальний цикл: збірку образу, пуш у Docker Hub та безшовний перезапуск локального контейнера:
```bash
$ chmod +x deploy.sh
./deploy.sh
```

Примітка для рев'юера: оскільки крок docker push потребує прав запису до реєстру squezeeek/hello-panda, скрипт розрахований на запуск автором проєкту. Для тестування стороннім користувачем рекомендується використовувати Варіант 1 або Варіант 2 (через Docker Compose).

🔄 CI/CD Пайплайн (GitHub Actions)
Пайплайн налаштований у файлі .github/workflows/deploy.yml і спрацьовує автоматично при кожному коміті/пуші в гілку main:

Checkout: клонує актуальний вихідний код проєкту.

Docker Login: проводить безпечну автентифікацію через зашифровані GitHub Secrets (DOCKERHUB_USERNAME, DOCKERHUB_TOKEN).

Build & Push: збирає оптимізований Docker-образ та відправляє його в Docker Hub з тегом latest.

Verification Step: запускає контейнер у runner-середовищі, пінгує ендпоінт через curl -I http://localhost:8080 (очікується код 200 OK) та коректно зупиняє контейнер.

🔒 Безпека та Best Practices
Unprivileged (Rootless): сервіс працює на базі nginxinc/nginx-unprivileged:alpine, що запобігає виконанню процесів із привілеями суперкористувача всередині контейнера.

Вбудований Healthcheck: інструкція HEALTHCHECK у Dockerfile дозволяє моніторити фактичний стан працездатності HTTP-сервера.

Безпека секретів: авторизаційні дані реєстру не зберігаються у відкритому вигляді у скриптах чи конфігах, а передаються виключно через механізм секретів середовища.
