#!/bin/bash

# Установка Docker-образа и конфигурация
download_node() {
  if docker ps -a --filter "name=titan-edge-container" | grep -q "titan-edge-container"; then
    echo "Контейнер titan-edge уже существует. Установка невозможна. Удалите контейнер или выйдите из скрипта."
    return
  fi

  echo "Начинаю установку контейнера..."

  read -p "Введите ваш ключ устройства: " DEVICE_HASH_KEY

  sudo apt update -y && sudo apt upgrade -y
  sudo apt-get install -y curl make screen build-essential

  echo "Скачиваю Docker-образ..."
  docker pull nezha123/titan-edge || { echo "Ошибка при скачивании Docker-образа."; exit 1; }

  # Создание директории для конфигурации
  mkdir -p ~/.titanedge || { echo "Ошибка при создании директории."; exit 1; }

  # Запуск контейнера
  docker run --network=host -d -v ~/.titanedge:/root/.titanedge --name titan-edge-container nezha123/titan-edge || { echo "Ошибка при запуске контейнера."; exit 1; }

  echo "Контейнер titan-edge запущен..."
}

# Обновление контейнера
update_node() {
  if ! docker ps -a --filter "name=titan-edge-container" | grep -q "titan-edge-container"; then
    echo "Контейнер titan-edge не найден. Установите контейнер перед обновлением."
    return
  fi

  echo "Начинаю обновление контейнера..."

  read -p "Введите ваш ключ устройства: " DEVICE_HASH_KEY

  docker stop titan-edge-container
  docker rm titan-edge-container

  docker pull nezha123/titan-edge || { echo "Ошибка при скачивании Docker-образа."; exit 1; }

  docker run --network=host -d -v ~/.titanedge:/root/.titanedge --name titan-edge-container nezha123/titan-edge || { echo "Ошибка при запуске контейнера."; exit 1; }

  echo "Контейнер titan-edge обновлен."
}

# Проверка логов
check_logs() {
  if ! docker ps -a --filter "name=titan-edge-container" | grep -q "titan-edge-container"; then
    echo "Контейнер titan-edge не найден."
    return
  fi

  echo "Получаю логи контейнера..."
  docker logs titan-edge-container --tail 100
}

# Изменение конфигурации (например, изменение ключа устройства)
change_key() {
  echo "Начинаю изменение ключа устройства..."

  read -p "Введите новый ключ устройства: " NEW_DEVICE_HASH_KEY

  # Здесь можно добавить логику изменения конфигурации внутри контейнера.
  # Для примера, просто выводим новый ключ:
  docker exec -it titan-edge-container bash -c "echo 'Новый ключ устройства: $NEW_DEVICE_HASH_KEY' > /root/.titanedge/key.txt"

  echo "Ключ устройства был изменен."
}

# Остановка контейнера
stop_node() {
  echo "Начинаю остановку контейнера..."

  if docker ps -a --filter "name=titan-edge-container" | grep -q "titan-edge-container"; then
    docker stop titan-edge-container
    echo "Контейнер titan-edge остановлен."
  else
    echo "Контейнер titan-edge не найден."
  fi
}

# Удаление контейнера
delete_node() {
  echo "Начинаю удаление контейнера..."

  if docker ps -a --filter "name=titan-edge-container" | grep -q "titan-edge-container"; then
    docker rm -f titan-edge-container
    echo "Контейнер titan-edge был удален."
  else
    echo "Контейнер titan-edge не найден."
  fi
}

# Главное меню
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

  case $choice in
    1)
      download_node
      ;;
    2)
      check_logs
      ;;
    3)
      change_key
      ;;
    4)
      stop_node
      ;;
    5)
      delete_node
      ;;
    6)
      update_node
      ;;
    7)
      exit_from_script
      ;;
    *)
      echo "Неверный пункт. Пожалуйста, выберите правильную цифру в меню."
      ;;
  esac
done
