--dataLink.lua

function send(data,int) --Checks L2 protocol being used by the interface before transmitting
	local protocol = Attrib[int].L2Protocol
	physical.Transmit({protocol.header,data,protocol.trailer})
end