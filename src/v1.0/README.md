# ccTCPf


## Purpose:

Implement TCP/IPv4 over Ethernet in as close to reality as possible

## Devices:

Pretty much a table of ideas right now!

__Router__:

* Routing Protocol: RIPv2
* Router Redundancy: VRRP
* Support: NAT, ACLs
* Have logical interfaces & physical interfaces

__Switch__:

* Multiple VLANs
* Load Balancing
* 802.1q Vlan Encapsulation
* Support: ACLs
* Have logical interfaces such as vlan interfaces & physical interfaces

__End User__:

* Extensible API
* Configureable Cisco iOS inspired OS.

__All Devices__:

* Ability to be configured via command line.
* Telnet + SSH
* FTP/TFTP
* ICMPv4
* TCP/IPv4


## Maintainers

* Chad Dunn: CmdPwnd[CCNAX]:       &lt;cctcpmail@gmail.com&gt; (Active)
