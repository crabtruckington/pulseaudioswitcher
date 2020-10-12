require "shellwords"

def bash(command)
    escaped_command = Shellwords.escape(command)
    result = `bash -c #{escaped_command}`.chomp
    return result
end


@deviceList = Hash.new
@activeDevice = 0

cmd = "pactl list short sinks | awk '{print $1 \"=\" $2 \"=\" $7}'"
devices = bash(cmd)


devices.each_line do |line|
    deviceDetails = line.chomp.split("=")
    @deviceList[deviceDetails[0]] = deviceDetails[1]
    if (deviceDetails[2] == "RUNNING")
        @activeDevice = deviceDetails[0]
    end
end

puts @deviceList

if @activeDevice == "1"
    cmd = "pactl set-default-sink '#{@deviceList["2"]}'"
    bash(cmd)
    bash("aplay /pulseaudioswitcher/beep.wav")
else
    cmd = "pactl set-default-sink '#{@deviceList["1"]}'"
    bash(cmd)
    bash("aplay /pulseaudioswitcher/beep.wav")
end
