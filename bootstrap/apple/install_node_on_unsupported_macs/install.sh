# What:
# Mojave bottle for node error with Illegal Instruction: 4
# When:
# This occurs when unsupported machines use dosdude1's Mojave installer hack to run Mojave
# Why:
# I assume Mojave bottle dropped support for my MacBook Air 2010 Core2Duo
# Solution:
# Use High Sierra bottle on older macs (last supported macOS version)
# Build from source takes hours, and actually fails on my machine, so that option is unattractive
# Longterm solution would be to add a bottle select option in brew as a pull request
# How:
# Comment out the Mojave bottle line in node.rb
# Note:
# I am not sure how brew handles this when node updates
# Probably should pin node version until manuall updating


brew unpin node
export EDITOR=nano
brew edit node
brew install node
brew pin node
