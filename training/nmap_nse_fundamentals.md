Notes from a udemy training... 

NSE is activated with the "-sC" option or "--script". If you wish to specify a custom set of script.

Script scanning is normally done in combination with a port scan because scripts may be run or not run depending

on the ports states found by the scan.

You can use "-sC" to perform a script scan using the default set of scripts.

It is equivalent to -­­‐script=default

Now wait a second what is this "default"?

Well it is one of the categories of Nmap scripts.

Let me show you.

Nmap scripting engine and NSE script define a list of categories that they belong to.

So currently defined categories are auth, broadcast, brute, default. discovery, dos, exploit, external, fuzzer,

intrusive, malware, safe, version, and vuln. Category names are not case sensitive.

So let's give you a little detail.

Default scripts are the default set and are run when using the "-sC" rather than listing scripts with

"--script". This category can also be specified explicitly like any other using "-­‐script=default"

auth scripts deal with authentication credentials or co-incidentally bypassing them on the target system.

Examples include oracle-­enum‐users. brute script use brute force attacks to guess authentication credentials

of a remote server. Nmap contains scripts for brute forcing dozens of protocols including http-­‐brute,

oracle-­‐brute, snmp-­‐brute, etc.

dos scripts may cause a denial of service.

Sometimes this is done to test vulnerability to a denial of service method but more commonly it's an

undesired by necessary side effect of testing for a traditional vulnerability.

These tests sometimes crash vulnerable services. exploit scripts aim to actively exploit some vulnerability.

Examples include http-­‐shellshock. Scripts which weren't designed to crash services use large amounts

of network bandwidth or other resources or exploit security holes that are usually categorized as safe.

intrusive scripts or those that cannot be classified in the safe category, because the risks are just

too high that they're going to crash the target system. Use up significant resources on a target host

such as bandwidth or CPU time or otherwise be perceived as malicious by the target system administrators.

malware script test whether the target platform is infected by malware or backdoors. version scripts are

an extension to the version detection feature and cannot be selected explicitly. They're selected to

run

only if version detection.

That's as (‐sV) was requested and vuln script check for specific known vulnerabilities and generally

only report results if they're found.

You can alternatively use --script parameter to run a script scan using the comma separated list of file

names, script categories and directories each element in the list may also be a boolean expression describing

a more complex set of script.

For example if you use script parameter using the "default and safe expression" the scripts which are

in both default and safe categories run

-­‐script-­updatedb option updates the script database found in scripts/script.db which is used

by Nmap to determine the available default scripts and categories. It is only necessary to update the database,

if you have added or removed NSE scripts from the default scripts directory or if you change the categories

of any script. This option is used by itself without argument.


=============================

#. Handyscripts & Categories

Here we have some scripts which are very helpful in penetration tests. The scripts that end with “‐brute”

perform brute-­force password guessing against the named services. Scripts ending with “­‐info” gets the

information about the named services. "dns­‐recursion" checks of a DNS server allows queries for third-party

names.

dns­‐zone­‐transfer request zone transfer A(AXFR) from a DNS server.

If the query is successful all domains and domain types are returned along with common type-specific

data (SOA, MX, NS, PTR or A). http­‐slowloris­‐check tests a web server for vulnerability to the Slowloris DoS

attack without actually launching a DoS attack.

ms-­sql-­info attempts to determine configuration and version information for Microsoft

SQL Server instances. ms­‐sql­‐dump­‐hashes dumps the password hashes from an MS-‐SQL server

in a format suitable for cracking by tools such as John-the-ripper. nbstat attempts to retrieve

the target's

NetBIOS names and MAC address.

By default the script displays the name of the computer and the logged-in user.

If the verbosity is turned up, it displays all the names the system thinks it owns.

smb-­enum-­users attempts to enumerate the users on a remote window system with as much information as

possible.

The goal of this script is to discover all user accounts that exist on a remote system.

This can be helpful for administration by seeing who has an account on a server or for penetration testing

or network foot printing by determining which accounts exist on a system. smb‐enum‐shares

attempts to list shares finding open shares is useful to a penetration tester because there may be private

files shared or if it's writable it could be a good place to drop a Trojan or to infect a file that's

already there.

Knowing where the share is could make those kinds of tests more useful except that determining where

the share is requires administrative privileges already in a penetration test.

You should try the pass the hash method to compromise system.

And the last three scripts will be very helpful for your pass the hash attacks.

Here you see some useful brute force or dictionary attack scripts for FTP, Databases such as My SQL,

Oracle, or MS SQL,

============================

#. Correct Timing Tips

Correct timing in Nmap scans is important for the accuracy and effectiveness of the scan. In the

case of outside scans, it is usually preferable to use slow scans to avoid devices such as IPS / IDS,

whereas in a scan from an internal network, quick scan options will be preferred. Qhile a fine grained

timing controls are powerful and effective.

Fortunately Nmap offers a simple approach with six timing templates.

You can specify them with "-T" option and their number (0–5) or their name. The template

names are paranoid (0),

sneaky (1), polite (2) , normal (3), aggressive (4) and insane (5).

The first two are for IDS evasion. Polite mode,

slows down the scan to use less bandwidth and target machine resources. Normal mode is the default,

And so T3 does nothing.

Aggressive mode speed scans up by making the assumption that you are on a reasonably fast and reliable

network.

Finally insane mode assumes that you're on an extraordinarily fast network or you're willing to sacrifice

accuracy for speed.

--max-retries option is to specify the maximum number of port scan probe retransmissions.

When and Nmap receives no response to a port scan probe it could mean that the port is filltered or maybe

the probe or response was simply lost on the network.

It's also possible that the target host as rate limiting enable that temporarily block the response.

So Nmap tries again by retransmitting the initial probe. If Nmap detects poor network reliability,

it may try many more times before giving up on report.

Now while this benefits accuracy it also lengthens scan times. So, when performance is critical,

scans may be sped up by limiting the number of retransmissions allowed.

You can even specify --max-retries 0 to prevent any retransmissions. Though that's only recommended for

situations such as informal surveys where occasional missed ports and hosts are acceptable.

The default (with no -­‐T template) template is to allow ten retransmissions. -­‐host­‐timeout is used to give

up slow targets.

Some hosts simply take a long time to scan.

This may be due to poorly performing or unreliable networking hardware or software,

packet rate limiting or restricted firewall. The slowest few percent of the scanned hosts can eat up

a majority of the scan time.

Sometimes it's best to cut your losses and skip to those hosts initially.

Specify -­‐host­‐timeout with a maximum amount of time you are willing to wait.

For example specify 30 minutes to ensure that Nmap doesn't waste more than half an hour on a single host.

Note that Nmap may be scanning other hosts at the same time during that half an hour so it's not a complete

loss.

Nmap utilizes parallelism and many advanced algorithms to accelerate the scans. Especially in the

case of external scans,

it may be necessary to close the parallel scan. That is to send a single packet to a server at the same time.

Nmap utilizes different options for this purpose:

As we saw just a few minutes ago you can manage the timing using -T option.

If you use the templates (0) paranoid (1) sneaky or (2) polite parallelisation is closed. That means these

template serialises the scan. So only one port is scanned at a time. --scan-delay option causes Nmap

to wait at least the given amount of time between each probe it sends to a given host.

This is particularly useful in the case of rate limiting. Solaris machines (among many others) will usually

respond to UDP scan probe packets with only one ICMP message per second.

Any more than that sent by Nmap will be wasteful.

--scan-delay of 1 second will keep Nmap at that slow rate. Nmap tries to detect rate limiting and

adjust the scan delay accordingly.

But it doesn't hurt to specify it explicitly if you already know what rate works best.

OK so by default and map calculates an ever-changing ideal parallelism based on network performance

the --max-parallelism option is sometimes set to 1 to prevent Nmap from sending more than one probe

at a time to hosts. Nmap has the ability to port scan or version scan multiple hosts in parallel.

Nmap does this by dividing the target IP space into groups and then scanning one group at a time.

When a maximum group size is specified with --max-hostgroup Nmap will never exceed that size.

So if you specify maximum number of hosts in a group as 1 using -­‐max-‐hostgroup option, there will be

only 1 host in the group and only 1 host will be scanned at a time.

So what do you reckon the difference is between the --max-parallelism and the --max-hostgroup.

Do you see it when you set --max-parallelism to 1 Nmap sends only 1 packet to a host a time. When

you set --max-hostgroup to 1 Nmap scans only one host at a time.


===============================

NULL, FIN, XMAS and ACK scans

Up to now we have seen the most important scanning types to discover network.

There are some other scanning techniques in Nmap which are not used as much as the others. But in some

cases you may need to find some other ways to be able to discover the sensitive hosts in a network.

In this slide we'll see 3 more scan types.

NULL, FIN and XMAS scans. The common ground of these three scanning methods.

NULL

FIN and XMAS scans.

is that they send packets to the target systems in which SYN, ACK and RST flags are not set.

Null scan (-­sN) does not set any bits, i.e. TCP flag header is 0. FIN scan (‐sF) sets

just the TCP FIN bit. Xmas scan (‐sX) sets the FIN, PSH, and URG flags, lighting the

packet up like a Christmas tree.

There are two rules defined in RFC standards about such packets:

The first rule is, if the destination port state is CLOSED, an incoming segment not containing a RST

causes a RST to be sent in response.

The second rule is, packets sent to OPEN ports without the SYN, RST, or ACK bits set are dropped. These three scan

types are exactly the same in behaviour except for the TCP flags set in probe packets..

If a RST packet is received, the port is considered closed. While no response means it is open or filtered.

If an ICMP unreachable error (type 3, code 0, 1, 2, 3, 9, 10, or 13) is received,

The port is marked as filtered. So as a result with these types of scans, you can find out if a port

is closed or not.

It's not possible to understand if it's open or filtered if there's no response.

This scan is different than the others discussed so far in that it never determines open (or even open|filtered)

ports.

It's used to map out firewall rulesets determining whether they're stateful or not and which ports are

The ACK scan probe packet has only the ACK flag set. When scanning unfiltered systems open and

closed port will both return a RST packet Nmap then labels them as unfiltered meaning that they

are reachable by the ACK packet. But whether they are open or closed is undetermined. Ports that don't

respond or send certain ICMP error messages back.

(type 3, code 0, 1, 2, 3, 9, 10, or 13), are labeled filtered.

===============================
IDLE SCAN

Idle scan as an advance scan method that allows for a truly blind TCP port scan of the target. Truly blind

TCP port scan means no packets are sent to the target from your real IP address.

Instead, a unique side channel attack exploits predictable IP fragmentation ID sequence generation on

the zombie host to gather information about the open ports on the target. IDS systems will display the

scan as coming from the zombie machine

you specify. The idle scan is based on the following three facts. As you already know.

One way to determine whether TCP port is open is to send a SYN packet to the port. The target machine

will respond with a SYN/ACK.

If the port is open and RST if the port is closed. A machine that receives an unexpected SYN/ACK packet

will respond with a RST and unexpected RST will be ignored.

Every IP packet on the Internet has a fragment identification number IP ID. Since many operating systems

simply increment this number for each packet they send. Probing for the IP ID can tell an attacker how

many packets have been sent since the last probe.

So first let's see what happens in an idle scan if the target board is open.

The first step is to probe the IP ID of the zombie system. The attacker sends a SYN/ACK to the zombie.

Since the zombie does not expect the packet, it sends back a RST with an IP ID.

The second step is to forge a SYN packet from the zombie to the target system.

The target sends a SYN/ACK in response to SYN and that appears to come from the zombie. Since the zombie

does not expect the packet, it sends back a RST.

And so it increments its IP ID and the process. Third step is to probe the zombie's IP ID again. The attacker

sends a SYN/ACK

to zombie again the RST packet of the Zombie has an IP ID which is increased by two since the first

step.

So the port is open.

Now lets see what happens in an idle scan if the target board is closed.

The first step is to probe the IP ID of the zombie system.

The attacker sends a SYN/ACK to the zombie. Since the zombie does not expect the packet it sends back

a RST with an IP ID.

The second step is to forge a SYN packet from the zombie to the target system. The target sends a

RST because the port is closed in response to SYN and that appears to come from the Zombie. The zombie

ignores the unexpected risks.

So its IP ID does not change.

Third step is to probe the zombie's IP ID again.

The attacker sends a SYN/ACK to the zombie again.

The RST packet of the Zombie has an IP ID which is increased by only 1 since the first step.

So the board is not open, you follow.

So then, here's the last one.

Let's see what happens in an idle scan if the target port is filtered.

The first step is to probe IP ID of the zombie system. The attacker sends a SYN/ACK to the zombie. Since

the zombie does not expect the packet it sends back a RST with an IP ID.

The second step is to forge a SYN packet from the zombie to the target system.

The target filtering its port, ignores this SYN that appears to come from the zombie.

The zombie is unaware that anything happened so its IP ID remains the same. Third step is to probe the

zombies IP ID again.

The attacker sends a SYN/ACK to the zombie again.

The RST packet of the zombie has an IP ID which has increased by only 1 since the first step.

So the port is not open.

So from the attackers point of view the filtered port is indistinguishable from a closed port.

You see why, in both cases the IP ID is increased by only one.

So lets have an idle scan. To be able to perform an idle scan,

we first need to have a zombie computer on the network which has incremental IP ID sequencing. Hopefully,

we have an unmap script to help us find the computer appropriate to become a zombie.

I know the name of the script starts with “ipid”, and put a star now.

Here is the script, ipidseq.nse

To use the script, type “nmap -­‐script ipidseq” and now our IP block, 172.16.99.0/24

To keep it simple, let’s scan just the top 2 ports

and here are the results.

So let's analyze them

99.1

is my host system.

It’s a Mac

and as you see, IP ID is randomised

99.2 is the gateway of my virtual LAN

and yes, it has incremental ID sequencing!

It can be used as the zombie system.

99.139 is a Linux system,

its IP ID sequence is all zero. 99.206 is our target, Metasploitable. 99.222 is our Kali machine.

It's IP IDs sequence is incremental.

So it's actually another zombie candidate but it's already the attacker itself. So it doesn’t make sense

to use it as zombie :)

But I understand yes it might be fun.

Right Now, we’re going to use 99.2 as the zombie

So here's the unmap idle scan query. -sI do idle scan. Now put the IP address of the zombie.

I want to use my host machine first which has a randomized IP ID sequence.

Not necessarily but I think it's a good habit. -Pn and n target systems IP.

So as you see Nmap says the zombie's IP ID sequence class is randomized.

So we should find another system.

So we think about using a zombie system with an all zeros IP ID sequence class.

As you see again it's just not suitable to be a zombie.

Now is it time to use this system which has an incremental IP ID sequence class.

So again to keep it simple I'll just scan the top three and yes scan is completed successfully. To compare

the results

I'd like to have a SYN scan in another terminal screen with the same conditions. Ports 23 and 80 are open

on both scans. According to SYN scan

Port 443 is closed.

Now we know that the Idle scan cannot distinguish the closed port from the filtered port.

It flagged port 443 as closed or filtered.

So let's run the last query with -reason option again

as you see ports 23 and 80 are flagged as open because ip ID has changed.

Each time since the IP ID has not changed report 443 its flag disclosed or filtered.