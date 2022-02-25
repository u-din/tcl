bind pub - .w pub:whoisnick
proc pub:whoisnick { nickname hostname handle channel arguments } {
 global whois
 set target [lindex $arguments 0]
 if {$target == ""} {
 putquick "PRIVMSG $channel :Aturan Pakai : .w <nick>"
 return 0
 }
 if {$target == "*"} {
 putquick "KICK $channel $nickname :5»»10 Gak uSah aneH² BoS.. 5««"
 return 0
 }
 if {[string length $target] >= "31"} {
 putquick "PRIVMSG $channel :Panjang amat nick nya"; return
 }
 putquick "WHOIS $target $target"
 set ::whoischannel $channel
 bind RAW - 402 whois:nosuch
 bind RAW - 311 whois:info
 bind RAW - 319 whois:channels
 bind RAW - 301 whois:away
 bind RAW - 313 whois:ircop
 bind RAW - 330 whois:auth
 bind RAW - 317 whois:idle
 bind RAW - 275 whois:ssl
 bind RAW - 338 whois:actual
 bind RAW - 312 whois:server
 bind RAW - 716 whois:gmode
 bind RAW - 318 end:of:whois
}

proc whois:putmsg { channel arguments } { putquick "PRIVMSG $channel :$arguments" }

proc whois:info { from keyword arguments } {
set channel $::whoischannel
set ::nickname [lindex [split $arguments] 1]
set ident [lindex [split $arguments] 2]
set host [lindex [split $arguments] 3]
set realname [string range [join [lrange $arguments 5 end]] 1 end]
whois:putmsg $channel "7 $::nickname 14is10 $ident@$host 11*9 $realname "
}

proc whois:ircop { from keyword arguments } {
set channel $::whoischannel
set target $::nickname
whois:putmsg $channel "7 $target 14is an 9IRC Operator"
}

proc whois:away { from keyword arguments } {
set channel $::whoischannel
set target $::nickname
set awaymessage [string range [join [lrange $arguments 2 end]] 1 end]
whois:putmsg $channel "7 $target 14is away:9 $awaymessage "
}

proc whois:channels { from keyword arguments } {
set channel $::whoischannel
set channels [string range [join [lrange $arguments 2 end]] 1 end]
set target $::nickname
whois:putmsg $channel "7 $target 14on10 $channels "
}

proc whois:auth { from keyword arguments } {
set channel $::whoischannel
set target $::nickname
set authname [lindex [split $arguments] 2]
whois:putmsg $channel "7 $target 14is authed as10 $authname "
}

proc whois:idle { from keyword arguments } {
set channel $::whoischannel
set target $::nickname
set idletime [lindex [split $arguments] 2]
set signon [lindex [split $arguments] 3]
whois:putmsg $channel "7 $target 14has been idle for10 [duration $idletime].  14signon time 10 [ctime $signon] "
}

proc whois:ssl { from keyword arguments } {
set channel $::whoischannel
set target $::nickname
whois:putmsg $channel "7$target 14is connected via 10Secure Connection 9(SSL)"
}

proc whois:gmode { from keyword arguments } {
set channel $::whoischannel
set target $::nickname
whois:putmsg $channel "7 $target 14is in 10+g14 mode 9(server side ignore)"
}

proc whois:actual { from keyword arguments } {
set channel $::whoischannel
set target $::nickname
set actualhost [lindex [split $arguments] 2]
whois:putmsg $channel "7$target 14actually using host10 $actualhost "
}

proc whois:server { from keyword arguments } {
set channel $::whoischannel
set target $::nickname
set servers [lindex [split $arguments] 2]
set serverdesc [string range [join [lrange $arguments 3 end]] 1 end]
whois:putmsg $channel "7 $target 14using10 $servers $serverdesc "
}

proc whois:nosuch { from keyword arguments } {
set channel $::whoischannel
whois:putmsg $channel "4ngga ada orangnya."
close:whois:bind 4ngga ada orangnya.
}

proc end:of:whois { from keyword arguments } {
 set channel $::whoischannel
 set target $::nickname
 whois:putmsg $channel "7 $target 14End of 10/WHOIS 14list."
 close:whois:bind 4ngga ada orangnya.
}
proc close:whois:bind { from key args } {
 unbind RAW - 402 whois:nosuch
 unbind RAW - 311 whois:info
 unbind RAW - 319 whois:channels
 unbind RAW - 301 whois:away
 unbind RAW - 313 whois:ircop
 unbind RAW - 330 whois:auth
 unbind RAW - 317 whois:idle
 unbind RAW - 275 whois:ssl
 unbind RAW - 338 whois:actual
 unbind RAW - 312 whois:server
 unbind RAW - 716 whois:gmode
 unbind RAW - 318 end:of:whois
}
putlog "Whois TCL Loaded..."
