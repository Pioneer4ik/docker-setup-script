#!/bin/bash

# Устанавливаем необходимые пакеты
sudo apt install -y ca-certificates curl gnupg lsb-release 

# Добавляем ключ Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Добавляем репозиторий Docker
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Обновляем пакеты и устанавливаем Docker
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io

# Добавляем пользователя в группу Docker
sudo usermod -aG docker $USER
newgrp docker

# Загружаем образ Docker
docker pull nezha123/titan-edge

# Создаем директорию для Titan Edge
mkdir ~/.titanedge

# Запускаем контейнер Docker
docker run --network=host -d -v ~/.titanedge:/root/.titanedge nezha123/titan-edge

# Последняя команда с возможностью изменения ключа
echo "Введите свой ключ для последней команды:"
read custom_key
docker run --rm -it -v ~/.titanedge:/root/.titanedge nezha123/titan-edge bind --hash=$custom_key https://api-test1.container1.titannet.io/api/v2/device/binding
