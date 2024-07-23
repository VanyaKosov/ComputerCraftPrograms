local function play(filePath)
    local dfpwm = require("cc.audio.dfpwm")
    local speaker = peripheral.find("speaker")

    local decoder = dfpwm.make_decoder()
    for chunk in io.lines(filePath, 16 * 1024) do -- "ShortRammsteinSonne.dfpwm" instead of filePath
        local buffer = decoder(chunk)

        while not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
        end
    end
end

return { play = play }
