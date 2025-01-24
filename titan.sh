#!/bin/bash

# Логотип
channel_logo() {
  echo -e '\033[0;32m' # Салатовый цвет
  echo -e '██▒   █▓ ██▓    ▄▄▄       ▄████▄   ██ ▄█▀ ██ ▄█▀ ▄▄▄▄    ▓█████ ▒█   █▒ ██▓▓█████▄'
  echo -e '▓██░   █▒▓██▒   ▒████▄    ▒██▀ ▀█   ██▄█▒   ██▄█▒ ▓█████▄  ▓█   ▀ ▒█ █▒░▓██▒▒██▀ ██▌'
  echo -e ' ▓██  █▒░▒██░   ▒██  ▀█▄  ▒▓█    ▄ ▓███▄░  ▓███▄░ ▒██▒ ▄██ ▒███   ▒█▒░ ░▒██▒░██   █▌'
  echo -e '  ▒██ █░░▒██░   ░██▄▄▄▄██ ▒▓▓▄ ▄██▒▓██ █▄  ▓██ █▄ ▒██░█▀   ▒▓█  ▄ ▒█░   ░██░░▓█▄   ▌'
  echo -e '   ▒▀█░  ░██████▒▓█   ▓██▒▒ ▓███▀ ░▒██▒ █▄ ▒██▒ █▄░▓█  ▀█▓ ░▒████▒░██████▒██▒░▒████▓ '
  echo -e '   ░ ▐░  ░ ▒░▓  ░▒▒   ▓▒█░░ ░▒ ▒  ░▒ ▒▒ ▓▒▒ ▒▒ ▓▒░▒▓███▀▒ ░░ ▒░ ░░ ▒░▓  ░▓ ░ ▒▒▓  ▒ '
  echo -e '   ░ ░░  ░ ░ ▒  ░ ▒   ▒▒ ░  ░  ▒   ░ ░▒ ▒░░ ░▒ ▒░▒░▒   ░   ░ ░  ░░ ░ ▒  ░▒ ░ ░ ▒  ▒ '
  echo -e '     ░░    ░ ░    ░   ▒   ░        ░ ░░ ░ ░ ░░ ░  ░    ░     ░     ░ ░   ▒ ░ ░ ░  ░ '
  echo -e '      ░      ░  ░     ░  ░░ ░      ░  ░   ░  ░    ░          ░  ░    ░  ░░     ░    '
  echo -e '     ░                       ░                     ░                          ░      '
  echo -e '\033[0m'
  echo -e "\nДобро пожаловать в автоматический скрипт для установки ноды Titan Edge!"
}

# Установка ноды Titan Edge
setup_node() {
  echo "Устанавливаю ноду Titan Edge..."
  
  # Установка Docker
  sudo apt install -y ca-certificates curl gnupg lsb-release && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
  sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io && \
  sudo usermod -aG docker $USER && \
  newgrp docker

  # Запуск контейнера Titan Edge
  docker pull nezha123/titan-edge
  mkdir -p ~/.titanedge
  docker run --network=host -d -v ~/.titanedge:/root/.titanedge nezha123/titan-edge

  echo "Нода установлена и запущена."
}

# Привязка устройства
bind_device() {
  read -p "Введите ваш ключ для привязки устройства: " hash_key
  docker run --rm -it -v ~/.titanedge:/root/.titanedge nezha123/titan-edge bind --hash=$hash_key https://api-test1.container1.titannet.io/api/v2/device/binding
}

# Основное меню
while true; do
  clear
  channel_logo
  sleep 1
  echo -e "\nМеню:"
  echo "1. 🚀 Установить НОДУ"
  echo "2. 🔑 Привязать устройство"
  echo "3. 🚪 Выйти"
  echo -e "\n"
  read -p "Выберите пункт меню: " choice

  case $choice in
    1)
      setup_node
      ;;
    2)
      bind_device
      ;;
    3)
      echo "Выход из скрипта."
      exit 0
      ;;
    *)
      echo "Неверный пункт. Пожалуйста, выберите правильный номер."
      ;;
  esac
done
