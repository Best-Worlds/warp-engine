# How to install Magento with WARP

## Create new folder

```
mkdir magento_demo
```


## Download WARP

```
curl -u "bestworlds:Sail7Seas" -L -o warp http://packages.bestworlds.com/warp-engine/release/latest && chmod 755 warp
```

## Download Magento

```
warp magento --download 2.3.2
```

## Start project

```
warp start
```

## Install Magento 

```
warp magento --install
```

## Create access to website

```bash
echo "127.0.0.1   local.magento2.com" | sudo tee -a /etc/hosts > /dev/null
```

### Requeriments

```
Docker
docker-compose

docker-sync (mac only)
rsync ^3.1.1
```

### Access to website or admin/panel

| parameter | value |
| --------  | -----------------------  |
|**website:** | [https://local.magento2.com](https://local.magento2.com) |
|**Url:**   | [https://local.magento2.com/admin](https://local.magento2.com/admin) |
|**User:**  | admin                    |
|**Pass:**  | Password123              |
