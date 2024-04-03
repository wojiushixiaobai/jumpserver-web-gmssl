# JumpServer Web 容器国密证书支持

本镜像功能与 [jumpserver/web](https://hub.docker.com/r/jumpserver/web) 一致，只是在原有基础上增加了国密证书支持。

目前适配了三种国密供应商的证书，分别是：

- WoTrus (沃通)
- GDCA (数安时代)
- GMSSL (国密 SSL 实验室)

## 使用方法

- 先确定你采购的证书是哪家供应商的，然后下载 JumpServer 对应版本的镜像
- 每次升级后都需要重新下载对应版本的镜像，然后重新打 tag

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

- 然后按照 JumpServer 官方文档进行启动即可

```sh
jmsctl start
```