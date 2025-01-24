#!/bin/bash

download_container() {
  if [ -d "$HOME/container" ] || docker ps -q -f name=titan-edge-container; then
    echo 'Контейнер уже существует. Установка невозможна. Выберите удалить контейнер или выйти из скрипта.'
    return
  fi

  echo 'Начинаю установку контейнера...'

  read -p "Введите ваш ключ устройства: " DEVICE_KEY_LOCAL

  sudo apt update -y && sudo apt upgrade -y
  sudo apt-get install make screen build-essential software-properties-common curl git nano jq docker.io -y

  cd $HOME

  sudo docker run -d --name titan-edge-container \
    -e DEVICE_KEY="$DEVICE_KEY_LOCAL" \
    titan-edge:latest

  echo "Контейнер titan-edge запущен с ключом устройства $DEVICE_KEY_LOCAL."
}

check_logs() {
  if docker ps -q -f name=titan-edge-container; then
    docker logs titan-edge-container
  else
    echo "Контейнер titan-edge не найден."
  fi
}

change_key() {
  echo 'Начинаю изменение ключа устройства...'

  if ! docker ps -q -f name=titan-edge-container; then
    echo 'Контейнер не найден. Установите контейнер.'
    return
  fi

  read -p "Введите новый ключ устройства: " NEW_DEVICE_KEY

  docker stop titan-edge-container
  docker rm titan-edge-container

  sudo docker run -d --name titan-edge-container \
    -e DEVICE_KEY="$NEW_DEVICE_KEY" \
    titan-edge:latest

  echo "Контейнер перезапущен с новым ключом устройства $NEW_DEVICE_KEY."
}

stop_container() {
  echo 'Начинаю остановку контейнера...'

  if docker ps -q -f name=titan-edge-container; then
    docker stop titan-edge-container
    echo "Контейнер titan-edge остановлен."
  else
    echo "Контейнер titan-edge не найден."
  fi
}

delete_container() {
  echo 'Начинаю удаление контейнера...'

  if docker ps -q -f name=titan-edge-container; then
    docker stop titan-edge-container
    docker rm titan-edge-container
    echo "Контейнер titan-edge был удален."
  else
    echo "Контейнер titan-edge не найден."
  fi
}

update_container() {
  echo 'Начинаю обновление контейнера...'

  if ! docker ps -q -f name=titan-edge-container; then
    echo 'Контейнер не найден. Установите контейнер.'
    return
  fi

  docker pull titan-edge:latest

  docker stop titan-edge-container
  docker rm titan-edge-container

  docker run -d --name titan-edge-container titan-edge:latest

  echo "Контейнер titan-edge был обновлен и запущен."
}

exit_from_script() {
  exit 0
}

while true; do
  echo -e "\n\nМеню:"
  echo "1. 🚀 Установить контейнер"
  echo "2. 📋 Проверить логи контейнера"
  echo "3. 🔑 Изменить ключ устройства"
  echo "4. 🛑 Остановить контейнер"
  echo "5. 🗑️ Удалить контейнер"
  echo "6. ✅ Обновить контейнер"
  echo -e "7. 🚪 Выйти из скрипта\n"

  read -p "Выберите пункт меню: " choice
  echo "Вы выбрали: $choice"  # Отладочный вывод
  
  case $choice in
    1)
      download_container
      ;;
    2)
      check_logs
      ;;
    3)
      change_key
      ;;
    4)
      stop_container
      ;;
    5)
      delete_container
      ;;
    6)
      update_container
      ;;
    7)
      exit_from_script
      ;;
    *)
      echo "Неверный пункт. Пожалуйста, выберите правильную цифру в меню."
      ;;
  esac
done
