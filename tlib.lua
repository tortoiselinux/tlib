-- ========================{HEADER}========================|
-- AUTHOR: wellyton 'welly' <welly.tohn@gmail.com> 
-- DESCRIPTION: stdlib for tortoise development
-- LIBNAME: Tlib 
-- LICENSE: MIT
-- ========================{ END }========================|
local tlib = {}

function tlib.parse_args(...)
   local args = {...}
   local cmd = table.concat(args, " ")
   return cmd
end

function tlib.exec(...)
   local cmd = tlib.parse_args(...)
   print("executando comando: " .. cmd)
   return os.execute(cmd)
end

function tlib.run(...)
   local cmd = tlib.parse_args(...)
   local out = io.popen(cmd .. " 2>&1")
   local result = out:read("*a")
   local success, exit_code = out:close()
   if success == nil then
      success = false
   end
   return result, success, exit_code
end

return tlib
