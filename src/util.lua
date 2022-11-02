_printT = function(tableToPrint)
  if type(tableToPrint) == 'table' then
    local stringOut = '{'
    for key,value in pairs(tableToPrint) do
      if stringOut ~= '{' then stringOut = stringOut .. "," end -- add , between pairs
      stringOut =  stringOut  .. key ..'=' .. _printT(value) -- print vlaue or nested loop
    end
    return stringOut .. '}'
 else
    if type(tableToPrint) == 'number' then
      return tostring(tableToPrint)
    else
      return '"' .. tostring(tableToPrint) .. '"'
    end
 end
end

return {
  _printT = _printT
}