#!/usr/bin/env bash

# цвета
COLOR_GREEN="#00FF00"
COLOR_RED="#FF0000"

# служебная функция редактирования блока
function update_holder {
  local instance="$1"
  local replacement="$2"
  echo "$json_array" | jq --argjson arg_j "$replacement" "(.[] | (select(.instance==\"$instance\"))) |= \$arg_j"
}

# служебная функция удаления блока
function remove_holder {
  local instance="$1"
  echo "$json_array" | jq "del(.[] | (select(.instance==\"$instance\")))"
}

# служебная функция формирования json блока
# возвращает json с переданным текстом и цветом
# по умолчанию без цвета
# example: forming_json_block "any text" "$COLOR_GREEN"
# output: { "full_text": "any text", "color": "#00FF00" }
function forming_json_block {
  local body=$1
  local color=$2

  local json=`echo null | jq "{full_text: \"$body\"}"`

  if [[ $color ]]; then
    json=`echo null | jq "$json + {color: \"$color\"}"`
  fi

  echo $json
}

# получение значения
# формирование JSON с полученным текстом
# примешивание нашего JSON к общему JSON
function keyboard_layout {
  # формируем body содержимым, которое собираемся вывести
  body=`xset -q|grep LED| awk '{ if (substr ($10,5,1) == 1) print "RU"; else print "EN"; }'`

  # сформируем json блока.
  # вторым параметром можно передать цвет
  # "$COLOR_GREEN" или "$COLOR_RED"
  local json=`forming_json_block "$body"`

  # примешивание нашего JSON к общему JSON
  # первым параметром передаем имя блока в конфиге
  json_array=$(update_holder keyboard_layout "$json")
}

# перехват JSON i3status, обогащение его своей выдачей
i3status | (read line; echo "$line"; read line ; echo "$line" ; read line ; echo "$line" ; while true
do
  read line
  json_array="$(echo $line | sed -e 's/^,//')"
  # тут вызов функции обновления uptime
  keyboard_layout
  echo ",$json_array"
done)