# ParkDrive
Linux Bash Script to unmount all partitions in a drive and put the drive into standby - parking the heads - for hotswaping.

ParkDrive unmounts and puts a drive into standby, which should park the heads, and prepare the drive for removal.
Ideal for a Hot Swappable drive setup. Uses umount and hdparm. When run without options it is an interactive text UI.
This Script was designed for my personal use. It is being provided for free, and with no garauntees whatsoever.
Use at your own risk.

Syntax: ParkDrive [-o] [-d] [Drive]
options:
h     Display this help
d     preselect drive (ie sda sdb sde etc)
f     Fast Skips Countdown
Y     Skips Confirmation Dialogue. Use at your own risk
