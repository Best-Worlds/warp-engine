# How to config Redis on Magento 2

You can configure Redis on Magento automatically by WARP Command, or manual by Magento CLI

## WARP Command for config Redis on Magento

```bash
warp magento --config-redis
```

## Manual configuration

1) Enable redis for cache.

```bash
warp magento setup:config:set --no-interaction --cache-backend=redis --cache-backend-redis-server=redis-cache --cache-backend-redis-db=0
```

2) Enable redis for full page cache.

```bash
warp magento setup:config:set --no-interaction --page-cache=redis --page-cache-redis-server=redis-fpc --page-cache-redis-db=1
```

2) Enable Redis for session.

```bash
warp magento setup:config:set --no-interaction --session-save=redis --session-save-redis-host=redis-session --session-save-redis-log-level=4 --session-save-redis-db=1
```

[Ref. Magento Docs:](https://devdocs.magento.com/guides/v2.4/config-guide/redis/redis-pg-cache.html)
