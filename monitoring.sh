#!/bin/bash
# monitoring.sh — мониторинг процесса test

LOG_FILE="/var/log/monitoring.log"
STATE_FILE="/var/run/test_monitor_prev_pid"
PROCESS_NAME="test"
MONITOR_URL="https://test.com/monitoring/test/api"

# Получаем PID процесса (если он есть)
PID=$(pgrep -x "$PROCESS_NAME")

# Если процесс не запущен — ничего не делаем и выходим
if [ -z "$PID" ]; then
    exit 0
fi

# Проверяем, был ли файл состояния и прошлый PID
if [ -f "$STATE_FILE" ]; then
    PREV_PID=$(cat "$STATE_FILE")
else
    PREV_PID=""
fi

# Если процесс перезапущен (PID изменился, но был предыдущий)
if [ -n "$PREV_PID" ] && [ "$PREV_PID" != "$PID" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Процесс $PROCESS_NAME перезапущен (новый PID: $PID)" >> "$LOG_FILE"
fi

# Сохраняем текущий PID
echo "$PID" > "$STATE_FILE"

# Проверяем доступность сервера мониторинга (только если процесс запущен)
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$MONITOR_URL")
if [[ "$HTTP_CODE" -lt 200 || "$HTTP_CODE" -ge 300 ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Сервер мониторинга недоступен ($MONITOR_URL, код: $HTTP_CODE)" >> "$LOG_FILE"
fi

exit 0
