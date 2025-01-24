#!/bin/bash

# Обновление системы
echo "Обновление системы..."
sudo apt-get update && sudo apt-get upgrade -y

# Установка необходимых пакетов
echo "Установка необходимых пакетов..."
sudo apt install -y ca-certificates curl gnupg lsb-release 

# Добавление ключа для Docker
echo "Добавление ключа Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Добавление репозитория Docker
echo "Добавление репозитория Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Установка Docker
echo "Установка Docker..."
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io

# Добавление пользователя в группу Docker
echo "Добавление текущего пользователя в группу Docker..."
sudo usermod -aG docker $USER
newgrp docker

# Установка и настройка Titan Edge
echo "Установка Titan Edge..."
docker pull nezha123/titan-edge
mkdir -p ~/.titanedge
docker run --network=host -d -v ~/.titanedge:/root/.titanedge nezha123/titan-edge

# Последняя команда: Запрос биндинга
echo "Создаём команду для биндинга. Измените ключ '--hash' в bind_command.sh, если это нужно."
cat <<EOL > bind_command.sh
#!/bin/bash
docker run --rm -it -v ~/.titanedge:/root/.titanedge nezha123/titan-edge bind --hash=ВАШ_КЛЮЧ https://api-test1.container1.titannet.io/api/v2/device/binding
EOL

# Делаем скрипт исполняемым
chmod +x bind_command.sh

echo "Скрипт завершён. Чтобы выполнить биндинг, запустите ./bind_command.sh после изменения ключа."
