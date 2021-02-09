server {

server_name colebach.com www.colebach.com;


location /c {
      try_files $uri $uri/ =404;
}

location / {
#root /var/www/cbtapr/html;
#index index.html index.htm index.nginx-debian.html;
proxy_pass http://localhost:3000;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection 'upgrade';
proxy_set_header Host $host;
proxy_cache_bypass $http_upgrade;
}


location /core {

    proxy_set_header 'Acces-Control-Allow-Origin' 'https://colebach.com';
   proxy_set_header 'Acces-Control-Allow-Methods' 'GET, POST, OPTIONS, PUT, DELETE';
   proxy_set_header 'Acces-Control-Allow-Headers' 'X-Requested-With, Accept, Content-Type, Origin';

    proxy_pass http://localhost:4000;
    proxy_redirect off;
    proxy_buffering on;

    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host  $host;
    proxy_cache_bypass $http_upgrade;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header  origin   'https://colebach.com';
   
}


    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/colebach.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/colebach.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}
server {
    if ($host = www.colebach.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = colebach.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot



listen 80;
listen 443 ssl;
#listen [::]:80;

server_name colebach.com www.colebach.com;
    return 404; # managed by Certbot




}
