# Server config

Section `rewrites` can be used as place to resolve custom domain names in a format:
```yaml
  rewrites:
    - domain: example.com
      answer: 192.168.53.100
    - domain: test.com
      answer: 192.168.100.100
```

Unless updated, credentials to the linked config file are:
* ID: admin
* PW: admin000