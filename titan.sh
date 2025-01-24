#!/bin/bash

# Обновление и апгрейд системы
echo "Updating and upgrading system packages..."
sudo apt-get update && sudo apt-get upgrade -y || { echo "Failed to update and upgrade system."; exit 1; }

# Установка зависимостей
echo "Installing required dependencies..."
sudo apt install -y ca-certificates curl gnupg lsb-release || { echo "Failed to install dependencies."; exit 1; }

# Добавление GPG ключа Docker
echo "Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg || { echo "Failed to add Docker GPG key."; exit 1; }

# Добавление репозитория Docker
echo "Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || { echo "Failed to add Docker repository."; exit 1; }

# Установка Docker
echo "Installing Docker..."
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io || { echo "Failed to install Docker."; exit 1; }

# Проверка статуса Docker
echo "Checking Docker status..."
sudo systemctl is-active --quiet docker || { echo "Docker is not running. Attempting to start Docker..."; sudo systemctl start docker; }
sudo systemctl enable docker

# Добавление текущего пользователя в группу Docker
echo "Adding current user to the Docker group..."
sudo usermod -aG docker $USER || { echo "Failed to add user to Docker group."; exit 1; }

# Пожалуйста, перезапустите систему или выйдите из текущей сессии и войдите снова, чтобы применить изменения в группе Docker.
echo "Please log out and log back in, or reboot your system to apply Docker group changes."

# Скачивание Docker-образа
echo "Pulling Docker image nezha123/titan-edge..."
docker pull nezha123/titan-edge || { echo "Failed to pull Docker image."; exit 1; }

# Создание директории для конфигурации
echo "Creating configuration directory..."
mkdir -p ~/.titanedge || { echo "Failed to create configuration directory."; exit 1; }

# Запрос на ввод собственного ключа
read -p "Enter your device hash key: " DEVICE_HASH_KEY

# Запуск Docker-контейнера
echo "Running Docker container..."
docker run --network=host -d -v ~/.titanedge:/root/.titanedge nezha123/titan-edge || { echo "Failed to run Docker container."; exit 1; }

# Привязка устройства
echo "Binding device to API endpoint..."
docker run --rm -it -v ~/.titanedge:/root/.titanedge nezha123/titan-edge bind --hash=$DEVICE_HASH_KEY https://api-test1.container1.titannet.io/api/v2/device/binding || { echo "Failed to bind device to API."; exit 1; }

echo "Setup completed successfully."
