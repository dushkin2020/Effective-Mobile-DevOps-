# ⚙️ Effective Mobile DevOps  
### Тестовое задание для DevOps Junior

---

## 🌿 Функционал

- 🔁 Автозапуск при старте системы  
- ⏱ Проверка процесса `test` каждую минуту  
- 🌐 Отправка статуса на сервер:  
  `https://test.com/monitoring/test/api`  
- 🪵 Логирование событий в `/var/log/monitoring.log`:  
  - Перезапуск процесса  
  - Ошибки подключения к серверу мониторинга  

---

## 🚀 Установка

```bash
git clone https://gitlab.com/dushkin2020/effective-mobile-devops.git
cd effective-mobile-devops-test
chmod +x install_monitor.sh
sudo ./install_monitor.sh

---

## Проверка работы

bash
systemctl status process-monitor.service
systemctl list-timers | grep process-monitor
tail -f /var/log/monitoring.log
