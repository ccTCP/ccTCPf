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

    raw.send(int,data)

sends data out of the side given with the data specified.

*Does not follow tcp/ip structure hence "raw"*

ex.

>raw.send("back","hello")

---

    raw.receive()



---

###Layer 2

    enet.macBind(int,addr)

---

    enet.getMac(int)

---

    enet.send(dstAddr,data,option)

---

    enet.receive()

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

