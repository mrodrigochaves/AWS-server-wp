# ATUALIZAR REPO
sudo apt update -y 
# INSTALAR NGINX
sudo apt install -y nginx
# INSTALAR ~PHP
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php8.0 libapache2-mod-php8.0
sudo systemctl restart apache2
sudo apt update
sudo apt install php8.0-fpm libapache2-mod-fcgid
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php8.0-fpm
systemctl restart apache2
sudo apt install -y php8.0-curl php8.0-gd php8.0-mbstring php8.0-zip php8.0-imagick php8.0-dom
sudo apt install php8.0-mysql php8.0-gd
# ADICIONAR REPO ~LETSENCRYPT E ATUALIZAR
sudo apt-get install software-properties-common 
sudo apt update -y 
# INSTALAR CERTBOT
sudo apt install -y certbot 
# INSTALAR PYTHON CERTBOT
sudo apt install certbot python3-certbot-nginx 
# BAIXAR CONFIGURACAO BASE DO WORDPRESS PARA NGINX
wget https://raw.githubusercontent.com/aldeiacloud/wordpress_nginx_rds_certauto/main/default.conf
# COPIAR ARQUIVO DE CONFIGURACAO PARA "SITES AVAILABLE"
sudo cp default.conf /etc/nginx/sites-available/wordpress
# CRIANDO LINK DA CONFIGURACAO PARA "SITES ENABLED"
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
# UNLINK DEFAULT
sudo unlink /etc/nginx/sites-enabled/default
# ABRIR PASTA TEMPORARIA
cd /tmp
# BAIXAR ULTIMA VERSAO DO WORDPRESS
curl -LO https://wordpress.org/latest.tar.gz
# DESCOMPACTAR PASTA DO WORDPRESS
tar xzvf latest.tar.gz
# COPIAR ARQUIVOS DO WORDPRESS PARA PASTA PADRÃO DO NGINX
sudo cp -a /tmp/wordpress/. /var/www/html
# TROCANDO DONO E GRUPO DA PASTA, PARA WWW-DATA (WORDRPRESS)
sudo chown -R www-data:www-data /var/www/html
# REINICIANDO O PHP
sudo /etc/init.d/apache2 stop
sudo systemctl restart nginx
# REINICIANDO CONFIGURACOES DO NGINX
sudo systemctl reload nginx
# HABILITANDO NGINX PARA INICIAR COM SISTEMA OPERACIONAL
sudo systemctl enable nginx
# CONFIGURAR HORARIO (BUENOS AIRES = BRASILIA SEM HORARIO DE VERAO)
sudo timedatectl set-timezone America/Argentina/Buenos_Aires
# CRIAR SWAP (MEMORIA DE ESCAPE)
sudo fallocate -l 2G /swapfile
# CONFIGURANDO PERMISSAO DE LEITURA E ESCRITA PARA O DONO E NENHUMA PERMISSAO PARA GRUPO E OUTROS NO "/SWAPFILE"
sudo chmod 600 /swapfile
# CONFIGURANDO SWAP NO ARQUIVO CRIADO
sudo mkswap /swapfile
# SUBINDO SWAP
sudo swapon /swapfile
# ADICIONANDO PONTO DE MONTAGEM DO SWAP NO FSTAB (PARA INICIAR COM SISTEMA OPERACIONAL)
sudo su
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
# ADICIONAR RENOVACAO AUTOMATICA DO CERTIFICADO
echo "SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 */12 * * * root certbot -q renew --nginx" >> /etc/cron.d/certbot
