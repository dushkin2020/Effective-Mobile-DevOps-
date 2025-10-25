#!/bin/bash

# Скрипт мониторинга процесса test для Effective Mobile
# Расположение: /usr/local/bin/test_process_monitor.sh

# Настройки скрипта
LOG_FILE="/var/log/test_process_monitor.log"  # Файл для логов
PROCESS_NAME="test"                           # Имя процесса для мониторинга
MONITORING_URL="https://test.com/monitoring/test/api"  # URL для проверки

# Функция логирования с timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Проверка, запущен ли процесс
is_process_running() {
    # Используем pgrep для поиска процесса по имени
    # -f ищет по полной командной строке, а не только по имени бинарника
    pgrep -f "$PROCESS_NAME" > /dev/null 2>&1
    return $?  # Возвращаем код выполнения pgrep (0 - найден, 1 - не найден)
}

# Отправка HTTP-запроса на мониторинг
send_monitoring_request() {
    local response_code  # Локальная переменная для кода ответа
    
    # Используем curl для отправки HTTPS-запроса
    # -s - тихий режим (без прогресс-бара)
    # -o /dev/null - не выводить тело ответа
    # -w "%{http_code}" - вывести только HTTP-код ответа
    # --connect-timeout 10 - таймаут на подключение 10 секунд
    # --max-time 15 - максимальное время выполнения 15 секунд
    response_code=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "User-Agent: TestProcessMonitor/1.0" \
        --connect-timeout 10 \
        --max-time 15 \
        "$MONITORING_URL")
    
    # Проверяем код ответа (200 = OK)
    if [ "$response_code" -eq 200 ]; then
        log_message "УСПЕХ: Процесс '$PROCESS_NAME' запущен. Мониторинг запрос отправлен (HTTP $response_code)"
        return 0
    else
        log_message "ПРЕДУПРЕЖДЕНИЕ: Процесс '$PROCESS_NAME' запущен, но запрос мониторинга failed (HTTP $response_code)"
        return 1
    fi
}

# Основная функция мониторинга
main() {
    log_message "ИНФО: Запуск проверки мониторинга процесса"
    
    if is_process_running; then
        log_message "ИНФО: Процесс '$PROCESS_NAME' запущен. Отправка запроса мониторинга..."
        send_monitoring_request
    else
        log_message "ИНФО: Процесс '$PROCESS_NAME' не запущен. Действия не требуются."
    fi
}

# Обработка различных режимов запуска
case "${1:-}" in
    --oneshot)
        # Ручной запуск для тестирования
        main
        ;;
    *)
        # Обычный запуск (из systemd timer)
        main
        ;;
esac
