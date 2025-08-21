#!/bin/bash
# Script de instalação automatizada do Zabbix 6 no Ubuntu Server 22.04

# Atualizar pacotes
sudo apt update && sudo apt upgrade -y

# Instalar repositório do Zabbix
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
sudo apt update

# Instalar Zabbix Server, frontend e agente
sudo apt install -y zabbix-server-pgsql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

# Instalar PostgreSQL
sudo apt install -y postgresql

# Criar banco e usuário para o Zabbix
sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix

# Importar schema inicial
zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix

# Habilitar serviços
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2

echo "Instalação concluída! Acesse a interface web em http://<IP_DO_SERVIDOR>/zabbix"
