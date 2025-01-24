#!/bin/bash

# Обновление и апгрейд пакетов
echo "Updating and upgrading system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Установка необходимых зависимостей
echo "Installing required dependencies..."
sudo apt install -y ca-certificates curl gnupg lsb-release

# Добавление GPG ключа Docker
echo "Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Добавление репозитория Docker
echo "Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Обновление пакетов и установка Docker
echo "Installing Docker..."
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io

# Добавление пользователя в группу Docker
echo "Adding current user to the Docker group..."
sudo usermod -aG docker $USER

# Переключение группы для активации Docker без выхода из системы
echo "Switching to Docker group..."
newgrp docker

# Загрузка Docker-образа nezha123/titan-edge
echo "Pulling the Docker image nezha123/titan-edge..."
docker pull nezha123/titan-edge

# Создание директории для конфигурации
echo "Creating configuration directory..."
mkdir -p ~/.titanedge

# Запуск Docker-контейнера nezha123/titan-edge
echo "Running the Docker container nezha123/titan-edge..."
docker run --network=host -d -v ~/.titanedge:/root/.titanedge nezha123/titan-edge

# Привязка устройства
echo "Binding device to the specified API endpoint..."
docker run --rm -it -v ~/.titanedge:/root/.titanedge nezha123/titan-edge bind --hash=68FA03DF-0D1F-48E0-8E63-798918441317 https://api-test1.container1.titannet.io/api/v2/device/binding

echo "Setup completed successfully."
