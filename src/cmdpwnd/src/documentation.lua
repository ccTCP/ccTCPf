--[[DOCUMENTATION BY: CMDPWND]]
--[[READ FROM BOTTOM TO TOP]]

--[[utils.lua
	[[Funtions
	
		[[autoLog()
			Checks and logs information and errors based on the state of a variable which determines things like wether an interface is up or down
		]]
	
	
	]]

	[[Error Codes
		
	]]

--]]

--[[network.lua  L3
	[[Funtions
	
	]]

	[[Error Codes
		
	]]

--]]

--[[dataLink.lua L2
	[[Funtions
	
	]]

--]]

--[[physical.lua L1
	Controls physical network Interface Cards [NICs]
	
	NICs connect to the physical network
		NICs are split into two types
			Wired:    Requires a network cable to transmit on
			Wireless: Requires radio wave conducting environment
			
	networks are split into two main types
		Local Area network: LANs are used to transmit over small to medium distances and are typically deployed to connect many devices in close proximity to one another or between buildings.
		Wide  Area network: WANs are used to transmit over large distances and are typically deployed to connect to the Internet,between cities or between Internet Service Providers [ISPs]
	
	[[Functions
	
		[[detectInt()
			
		]]
		[[typeInt(t,int)
			
		]]
		[[speedInt(speed,int)
			
		]]
		[[protocolInt(proto,int)
			
		]]
		[[noShut(int)
			
		]]
		[[shut(int)
			
		]]
		[[send(data,int)
			
		]]
	]]

			
--]]

--[[Error Codes
		Format: 0x000000
				  ||||||
				  |||||- error number
				  ||||- error number
				  |||- error function
				  ||- error type +/ function
				  |- src file error orginated from
				  - src file error originated from
				  
		Error Codes are split into three types
			[[API: 
				Format: 0x0000cc
				Defines an error from the API which is non-specific to any src file or function
			]]
			[[File:
				Format: 0xaa00cc where aa > 00
				Defines an error from a specific src file where two or more functions in that file have a common error. The error returning function will be logged.
			]]
			[[Function:
				Format: 0xaabbcc where bb > 00
				Defines an error from a specific function
			]]
--]]

--[[Contribuor List
	Chad Dunn: cmdpwnd
--]]