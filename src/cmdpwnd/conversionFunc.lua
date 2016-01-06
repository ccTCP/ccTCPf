function BasetoDec(hex,base,eval,ret)
  local num=1
  split = {}
  for i,a in hex:gmatch('[^%'..eval..']+') do
    split[num] = tonumber(tostring(i),base)..ret
    num=num+1
  end
  if string.len(split[#split]) < 2 then return split else
    split[#split] = split[#split]:sub(1,-2)
    return split
  end
  
end

dec = {}
dec[1] = BasetoDec("c0:a8:89:01",16,":",".")
dec[2] = BasetoDec("1011.1010.0010.1001",2,".",".")
local b = #dec
local i=1
while i <= b do print(table.concat(dec[i])) ; i=i+1 end