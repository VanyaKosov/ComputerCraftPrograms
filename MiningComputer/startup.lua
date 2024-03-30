-- These varibales depend on where the monitor and modem are located
local monitorSide = "left"
local modemSide = "top"

local monitor = peripheral.wrap(monitorSide)

term.redirect(monitor)
term.clear()
term.setCursorPos(1, 1)
rednet.open(modemSide)
while true
do
    local id, message = rednet.receive()
    term.clear()
    term.setCursorPos(1, 1)
    print("Turtle #", id, ": ", message)
end
