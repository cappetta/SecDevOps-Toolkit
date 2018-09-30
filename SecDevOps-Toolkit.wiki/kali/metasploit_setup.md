

## DB
```
#!/bin/bash
service postgresql start
ss -ant
msfdb init
msfconsole < db_status
```

https://docs.kali.org/general-use/starting-metasploit-framework-in-kali

Resource Scripts:
    location: `/usr/share/metasploit-framework/scripts/resource`
    wiki: https://metasploit.help.rapid7.com/docs/resource-scripts
    cli example: `msfconsole -r autoexploit.rc username password msf windows/smb/ms08_067_netapi`
