# Working from a fresh install of kali?
## Initialize
### metasploit
<!--todo: create a script for 1-step execution of initialization -->
    - [ ] `systemctl start postgresql`
    - [ ] `msfdb init`
    - [ ] `db_status`
    - [ ] `workspace -a SecDevOps`
### EtterCap
    type: MiTM via arp poisoning
### SSLStrip
    type: MiTM
    github: `https://github.com/moxie0/sslstrip`
### EvilGrade:
    type: MiTM
    github: `https://github.com/infobyte/evilgrade`
### SQLMap
    type: sql injection
    github `git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev`
### Aircrack-NG
### oclHashCat
    type: password from hashes
    download: `https://hashcat.net/hashcat/`
### ncrack:
    type: network auth cracking
    download: `https://nmap.org/ncrack/`
### binwalk:
    type: firmware analysis
### mimikatz:
    type:
    github: Mimikatz
### MassScan / Zmap
    type: Scanners
    


## Import Data
### nmap
    - [ ] import nmap xml data `db_import /root/path/to/file.xml'
    > Some blockquote formatting
### nessus

## Backup data
    - [ ] `db_export -f xml /root/path/to/file_output.xml`
## subsection




Set it up using the following steps:

download nse scripts
    - `https://github.com/vulnersCom/nmap-vulners`
    -
Get familar w/ key tools in the toolbox and know when to use em:
`ref :https://hackertarget.com/11-offensive-security-tools/`


# Overview
## subsection
### focal point 1
    - [ ]
    > Some blockquote formatting
## subsection
## subsection
