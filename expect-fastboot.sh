#!/usr/bin/expect -f
set MINICOM_SERIAL [lindex $argv 0]
puts "MINICOM_SERIAL=$MINICOM_SERIAL"
spawn minicom -D $MINICOM_SERIAL
expect "special keys"
send "\r"
expect "=>"
send "reset\r"
expect "Hit any key to stop autoboot: " {
	send "\r"
	send "\rfastboot\r"
}
sleep 1
send "\x01"
sleep 1
send "x"
expect "Leave Minicom?"
send "\r"
