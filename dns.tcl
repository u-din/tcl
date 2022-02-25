# $Id: dns.tcl,v 1.3 29/06/2016 5:18:52pm NZST (GMT+12) IRCSpeed Exp $

## SYNTAX:
## --------------------------
# PUBLIC:
# !setdns on|off *default flags for globalmaster|chanmaster to set*
# !dns nickname *default flags for globalop,globalvoice,globalfriend|chanop,chanvoice,chanfriend to trigger*
# !dns ip.or.hostname.or.IPv6
# ---------------------------
# PRIVMSG:
# /msg yourbot setdns #channel on|off

## Settings (please configure as needed)
# Set your dns trigger here (default: !)
set dnsTrigger "."

# Set access flags to use DNS (default: ovf|ovf - set to -|- for all)
set dnsFlags ovf|ovf

# Set access flags for user's who can set enable/disable on channel's (default: m|m)
set dnsSetFlags m|m

## CODE BLOCK ## (don't touch this, unless you know how).
bind pub - ${dnsTrigger}dns lookup:dns
bind pub - ${dnsTrigger}setdns setdns:pub
bind msg - setdns setdns:msg

proc dnsTrig {} {
  global dnsTrigger
  return $dnsTrigger
}

setudef flag dodns

proc setdns:pub {nick uhost hand chan arg} {
  global dnsSetFlags
  if {![matchattr [nick2hand $nick] $dnsSetFlags $chan]} {return}
  if {[lindex [split $arg] 0] == ""} {putquick "PRIVMSG $chan :ERROR: Incorrect Parameters. SYNTAX: [dnsTrig]setdns on|off"; return}
 
  if {[lindex [split $arg] 0] == "on"} {
    if {[channel get $chan dodns]} {putquick "PRIVMSG $chan :ERROR: This setting is already enabled."; return}
    channel set $chan +dodns
    puthelp "PRIVMSG $chan :Enabled DNS functionality for $chan"
  }
 
  if {[lindex [split $arg] 0] == "off"} {
    if {![channel get $chan dodns]} {putquick "PRIVMSG $chan :ERROR: This setting is already disabled."; return}
    channel set $chan -dodns
    puthelp "PRIVMSG $chan :Disabled DNS functionality for $chan"
  }
}
 
proc setdns:msg {nick uhost hand arg} {
  global botnick dnsSetFlags
  set chan [strlwr [lindex $arg 0]]
  if {![matchattr [nick2hand $nick] $dnsSetFlags $chan]} {return}
  if {[lindex [split $arg] 0] == ""} {putquick "NOTICE $nick :\037ERROR\037: Incorrect Parameters. \037SYNTAX\037: /msg $botnick setdns #channel on|off"; return}
  if {[lindex [split $arg] 1] == ""} {putquick "NOTICE $nick :\037ERROR\037: Incorrect Parameters. \037SYNTAX\037: /msg $botnick setdns $chan on|off"; return}
 
  if {[lindex [split $arg] 1] == "on"} {
    if {[channel get $chan dodns]} {putquick "NOTICE $nick :\037ERROR\037: This setting is already enabled."; return}
    channel set $chan +dodns
    putquick "NOTICE $nick :Enabled DNS functionality for $chan"
  }
 
  if {[lindex [split $arg] 1] == "off"} {
    if {![channel get $chan dodns]} {putquick "NOTICE $nick :\037ERROR\037: This setting is already disabled."; return}
    channel set $chan -dodns
    putquick "NOTICE $nick :Disabled DNS functionality for $chan"
  }
}

proc lookup:dns {nick uhost hand chan arg} {
  global dnsFlags
  if {![matchattr [nick2hand $nick] $dnsFlags $chan]} {return}
  if {![channel get $chan dodns]} {putquick "PRIVMSG $chan :ERROR: DNS functionality is not enabled for $chan - Please use [dnsTrig]setdns on"; return}
  if {[lindex $arg 0] == ""} {putquick "PRIVMSG $chan :ERROR: Incorrect Parameters. SYNTAX: [dnsTrig]dns <nick|ip.or.host.name>"; return}
  if {[onchan $arg $chan]} {
    set hostip [eval exec host [lindex [split [getchanhost $arg $chan] @] 1]]
  } else {
  set hostip [eval exec host $arg]
  }
  foreach line [split $hostip \n] {
   puthelp "PRIVMSG $chan :\002DNS Result\002: $line"
  }
 return 0
}

putlog ".:DNS Lookup:. Loaded - istok @ IRCSpeed"
