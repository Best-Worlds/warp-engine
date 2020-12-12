# How to config Varnish on Magento 2

## WARP command for config Varnish on Magento

this command configure varnish VCL on Magento

```bash
warp magento --config-varnish
```

!!! warning
    the **varnish** service must be previously added with the wizard in TL mode and setting enabled with the wizard in developer mode

## Enable / Disable service

you can enable or disable **varnish** when configuring the wizard in developer mode

1) Reset basic configuration

```bash
warp reset
```

2) Enable varnish

```bash
Configuring Varnish Service
Do you want to use varnish service? [y/N] y
```

## varnish --help

!!! important
    you can check **warp varnish help** with the following command


```bash
warp varnish --help
```


[Ref. Magento Docs:](https://devdocs.magento.com/guides/v2.4/config-guide/varnish/config-varnish-magento.html)
