🚀 Effective Mobile DevOps

Описание:
Проект для автоматизации DevOps-процессов в мобильной разработке.

Функциональность:

Мониторинг процесса test в Linux

Отправка статуса на сервер мониторинга

Логирование перезапусков и ошибок соединения

Автоматический запуск при старте системы

Установка:

git clone https://gitlab.com/dushkin2020/effective-mobile-devops.git
cd effective-mobile-devops-test
chmod +x install_monitor.sh
sudo ./install_monitor.sh


Проверка:

systemctl status process-monitor.service
systemctl list-timers | grep process-monitor
tail -f /var/log/monitoring.log


Автор:
Тестовое задание для позиции DevOps Junior (Effective Mobile)
