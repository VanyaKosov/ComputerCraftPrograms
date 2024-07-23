local redstoneSide = "right"
local musicAddress = "ShortRammsteinSonne.dfpwm"

local function run()
    local playAudio = require("playAudio")
    local originalSignal = redstone.getInput(redstoneSide)
    local playedOnce = false;

    while true do
        sleep(0.05)

        local currentSignal = redstone.getInput(redstoneSide)

        if currentSignal == originalSignal then
            playedOnce = false;
        end

        if playedOnce == true then
            goto continue
        end

        if currentSignal ~= originalSignal then
            playAudio.play(musicAddress);
            playedOnce = true
        end

        ::continue::
    end
end

return { run = run }
