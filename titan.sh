#!/bin/bash

# Установка необходимых пакетов и Docker
install_docker() {
  echo "Устанавливаю Docker..."
  sudo apt install -y ca-certificates curl gnupg lsb-release
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
  sudo usermod -aG docker $USER
  newgrp docker
  
  echo "Docker установлен и настроен."
}

# Запуск контейнера Titan Edge
start_titan_edge() {
  echo "Запускаю контейнер Titan Edge..."
  docker pull nezha123/titan-edge
  mkdir -p ~/.titanedge
  docker run --network=host -d -v ~/.titanedge:/root/.titanedge nezha123/titan-edge
  echo "Контейнер Titan Edge запущен."
}

# Привязка устройства
bind_device() {
  read -p "Введите ваш ключ для привязки устройства: " hash_key
  docker run --rm -it -v ~/.titanedge:/root/.titanedge nezha123/titan-edge bind --hash=$hash_key https://api-test1.container1.titannet.io/api/v2/device/binding
}

# Меню
while true; do
  echo -e "\nМеню:"
  echo "1. 🚀 Установить Docker"
  echo "2. 🔄 Запустить контейнер Titan Edge"
  echo "3. 🔑 Привязать устройство"
  echo "4. 🚪 Выйти"
  echo -e "\n"
  read -p "Выберите пункт меню: " choice

  case $choice in
    1)
      install_docker
      ;;
    2)
      start_titan_edge
      ;;
    3)
      bind_device
      ;;
    4)
      echo "Выход из скрипта."
      exit 0
      ;;
    *)
      echo "Неверный пункт. Пожалуйста, выберите правильный номер."
      ;;
  esac
done
