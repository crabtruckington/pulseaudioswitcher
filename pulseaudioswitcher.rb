require "shellwords"

def bash(command)
    escaped_command = Shellwords.escape(command)
    result = `bash -c #{escaped_command}`.chomp
    return result
end


#@deviceList = Hash.new
@activeDevice = ""
@inactiveDevice = ""

cmd = "pactl list short sinks | awk '{print $1 \"=\" $2 \"=\" $7}'"
devices = bash(cmd)


devices.each_line do |line|
    deviceDetails = line.chomp.split("=")
#    @deviceList[deviceDetails[0]] = deviceDetails[1]
    if (deviceDetails[2] == "RUNNING")
        @activeDevice = deviceDetails[1]
    else
        @inactiveDevice = deviceDetails[1]
    end
end

puts "Active: " + @activeDevice.to_s + "; Inactive: " + @inactiveDevice.to_s

cmd = "pactl set-default-sink '#{@inactiveDevice}'"
bash(cmd)
bash("aplay /home/jeff/pulseaudioswitcher/beep.wav")


# if @activeDevice == "1"
#     cmd = "pactl set-default-sink '#{@deviceList["2"]}'"
#     bash(cmd)
#     bash("aplay /home/jeff/pulseaudioswitcher/beep.wav")
# else
#     cmd = "pactl set-default-sink '#{@deviceList["1"]}'"
#     bash(cmd)
#     bash("aplay /home/jeff/pulseaudioswitcher/beep.wav")
# end
