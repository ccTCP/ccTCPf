**Date Published: 5/19/2015**

# ccTCPf v0.1



*This documentation currently is unofficial and is WIP*

### What is ccTCPf?

ccTCPf is an API that introduces TCP/IPv4 into ComputerCraft to be used either in conjunction with an Operating System or as a standalone API and is built based on the [OSI Model]("http://en.wikipedia.org/wiki/OSI_model"). The goal of this project is to bring real world technologies to a game where anything is possible. This allows people that wouldn't normally have exposure to real equipment to be able to use the same protocols in place today for networking in the real world.

----
### Layer 1

    int.open(int)
  opens a wired or wireless modem on the side given.

  ex.

>int.open("back")

---
    int.close(int)

  closes a wired or wireless modem on the side given.

  ex.

>int.close("back")

---

    int.send(int,data)

  sends data out of the side given with the data specified.

  *Does not follow tcp/ip structure and is considered "raw"*

  ex.

>int.send("back","hello")

---

    int.receive()

  receives all modem messages

---

###Layer 2

    enet.macBind(int,addr)

  binds a mac address to an interface. This can be used in one of three ways.
  
  ex.
  
  >enet.macBind() --Generates a mac for all interfaces
  
  >enet.macBind("back") --Generates a mac for the back side
  
  >enet.macBind("back","aaaa.aaaa.aaaa") --Makes a static binding for the back interface to have the mac aaaa.aaaa.aaaa
  
---

    enet.getMac(int)
  
  returns mac address for the interface given.
  
  ex.
  
  >enet.getMac("back") --> aaaa.aaaa.aaaa
  
---

    enet.send(dstAddr,data,option)
  
  sends a frame to the *dstAddr* given with the *data* given and with any optional modifiers specified (*option*).
  
  options.
  
  >srcAddr - Mac Address to use in the srcAddr field
---

    enet.receive()
  
  recieves frames and processes fcs. If fcs is valid then that frame is returned, otherwise that frame is dropped.
  
---

###Layer 3

    ip.setAddr(addr)

---

    ip.getAddr(addrType)

---

    ip.send(dstIP,data,option)

---

    ip.receive()

---

