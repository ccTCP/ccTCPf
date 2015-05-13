#ccTCPf

##Purpose:
	
Implement TCP/IPv4 over Ethernet Stack in ComputerCraft

###Code Layout:

Project Coding Format: OOP
	
Each OSI Layer will have its own OOP object as follows:

	1. int -- interface, deals with the physical transmission of data and handling
	2. mac -- MAC, L2 identifiers and frame layout with full encapsulation
	3. ip  -- IP, L3 identifiers and packet layout with full encapsulation
	
Examples:

	tcp.send("left","data")
	mac.macBind("left",aaaa.aaaa.aaaa)
	ip.setAddr("left",192.168.1.10,255.255.255.0)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
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