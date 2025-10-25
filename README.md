⚙️ Effective Mobile DevOps
Тестовое задание для DevOps Junior

🧩 Функционал

Автозапуск при старте системы

Проверка процесса test каждую минуту

Отправка статуса на https://test.com/monitoring/test/api

Логирование в /var/log/monitoring.log:

перезапусков процесса

ошибок подключения к серверу мониторинга

🚀 Установка

git clone https://gitlab.com/dushkin2020/effective-mobile-devops.git

cd effective-mobile-devops-test

chmod +x install_monitor.sh

sudo ./install_monitor.sh

🔍 Проверка работы

systemctl status process-monitor.service

systemctl list-timers | grep process-monitor

tail -f /var/log/monitoring.log
