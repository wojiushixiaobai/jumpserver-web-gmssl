# JumpServer Web 容器国密证书支持

本镜像功能与 [jumpserver/web](https://hub.docker.com/r/jumpserver/web) 一致，只是在原有基础上增加了国密证书支持。

目前适配了三种国密供应商的证书，分别是：

- WoTrus (沃通)
- GDCA (数安时代)
- GMSSL (国密 SSL 实验室)

## 使用方法

- 先确定你采购的证书是哪家供应商的，然后下载 JumpServer 对应版本的镜像
- 每次升级后都需要重新下载对应版本的镜像，然后重新打 tag

### 下载对应版本的镜像
```sh
# WoTrus
docker pull ghcr.io/wojiushixiaobai/web-wotrus:v3.10.7
docker tag ghcr.io/wojiushixiaobai/web-wotrus:v3.10.7 jumpserver/web:v3.10.7

# GDCA
docker pull ghcr.io/wojiushixiaobai/web-gdca:v3.10.7
docker tag ghcr.io/wojiushixiaobai/web-gdca:v3.10.7 jumpserver/web:v3.10.7

# GMSSL
docker pull ghcr.io/wojiushixiaobai/web-gmssl:v3.10.7
docker tag ghcr.io/wojiushixiaobai/web-gmssl:v3.10.7 jumpserver/web:v3.10.7
```

### 然后按照 JumpServer 官方文档进行配置 ssl 证书

```sh
vim /opt/jumpserver/config/config.txt
```

```sh
## HTTPS 配置
HTTP_PORT=80                 # 对外 http 端口, 默认 80
HTTPS_PORT=443               # 对外 https 端口, 默认 443
SERVER_NAME=www.domain.com   # 你的 https 域名

## 注释掉证书相关的设置， 因为国密一般支持双证书，需要修改模板文件
# SSL_CERTIFICATE=xxx.pem      # /opt/jumpserver/config/nginx/cert 目录下你的证书文件
# SSL_CERTIFICATE_KEY=xxx.key  # /opt/jumpserver/config/nginx/cert 目录下你的 key 文件
```

### 手动将证书文件拷贝到 /opt/jumpserver/config/nginx/cert 目录下
```sh

cp -f your_sm2_sign_bundle.crt /opt/jumpserver/config/nginx/cert
cp -f your_domain_SM2.key /opt/jumpserver/config/nginx/cert
cp -f your_domain_sm2_encrypt_bundle.crt /opt/jumpserver/config/nginx/cert
```

### 修改模板文件，可以参考 [证书使用说明](https://github.com/wojiushixiaobai/gmssl_nginx/blob/main/README.md) 的模板文件

```sh
vim /opt/jumpserver/config/nginx/lb_http_server.conf
```

```nginx
server {

# ... 省略

# 注意: 只需要修改 ssl_ 开头的相关配置, 其他配置不要动

    ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers ECC-SM4-SM3:ECDH:AESGCM:HIGH:MEDIUM:!RC4:!DH:!MD5:!aNULL:!eNULL;
    ssl_verify_client off;
    ssl_session_timeout 5m;
    ssl_prefer_server_ciphers on;

    ssl_certificate cert/your_sm2_sign_bundle.crt;      # 配置国密签名证书/私钥
    ssl_certificate_key cert/your_domain_SM2.key;

    ssl_certificate cert/your_domain_sm2_encrypt_bundle.crt;   # 配置国密加密证书/私钥
    ssl_certificate_key cert/your_domain_SM2.key;

# ... 省略

### 重启容器
```sh
jmsctl start
```