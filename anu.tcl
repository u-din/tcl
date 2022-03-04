# How to active:
# 1- Change "#i" to channel will echo the actions.
# 2- Access your bot via dcc and active the channel that you want to spy by:
# .chanset #channel +spy

# Notes:
# - Just a reporting channel
# - You can are spying multiple channels

setudef flag spy
set spyechochannel "#i"

bind join - * spyjoinecho
proc spyjoinecho {n u h c} {
if {[lsearch -exact [channel info $c] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\00310 $c |\003\00303 $n ($u) joined channel\003"
putserv "privmsg $spyechochannel :.ip $n"
}
}
bind part - * spypartecho
proc spypartecho {n u h c t} {
if {[lsearch -exact [channel info $c] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\00310 $c |\003\00305 $n left channel ($t)\003"
}
}
bind sign - * spyquitecho
proc spyquitecho {n u h c t} {
if {[lsearch -exact [channel info $c] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\00310 $c |\003\00302 $n quit channel ($t)\003"
}
}
bind kick - * spykickecho
proc spykickecho {n u h c w e} {
if {[lsearch -exact [channel info $c] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\00310 $c |\003\00304 $w has been kicked by $n ($e)"
}
}
bind pubm - * spymsgecho
proc spymsgecho { n u h c t } {
if {[lsearch -exact [channel info $c] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\00310 $c |\003\00306 $n :\003\00314 $t\003"
}
}
bind mode - * spymodeecho
proc spymodeecho { n u h c m t } {
if {[lsearch -exact [channel info $c] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\00310 $c | $n sets mode: $m $t\003"
}
}
bind nick - * spynickecho
proc spynickecho {n u h c nn} {
if {[lsearch -exact [channel info $c] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\00310 $c |\003\00306 $n is now known as: $nn\003"
}
}
bind ctcp - action spyactionecho
proc spyactionecho {n u h d k t} {
global botnick
if {$d == $botnick} {
return 0
} elseif {[lsearch -exact [channel info $d] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel : $d |\00307 * $n $t\003"
}
}


# Commands:
# ---------
# Public:  !ignore add *!*host@mask.etc timehere your-reasons-for-ignore
#          !ignore del *!*host@mask.etc
#          !ignores

# The trigger
set ignorepubtrig "."

# Set Flags here to trigger script (Note: default flag is 'o' (global op), it's not wise to use lower flags as someone could 
# add owners to ignore. Only add a flag for Respected Bot User's who don't abuse their access.
set ignoreflags o

# ---- EDIT END ----
proc getIgnoreTrig {} {
  global ignorepubtrig
  return $ignorepubtrig
}

bind pub - ${ignorepubtrig}ignore ignore:pub
bind pub - ${ignorepubtrig}ignores ignore:list

proc ignore:pub {nick uhost hand chan text} {
  global ignoreflags
  if {[matchattr [nick2hand $nick] $ignoreflags]} {
    if {[lindex [split $text] 0] == ""} {putquick "PRIVMSG $chan :\037ERROR\037: Incorrect Parameters. \037SYNTAX\037: [getIgnoreTrig]ignore add <*!*@host.mask.whatever> <duration:in:minutes> <your reasons whatever> - [getIgnoreTrig]ignore del <*!*@host.mask.whatever>"; return}

    if {[lindex [split $text] 0] == "add"} {
      set addmask [lindex [split $text] 1]
      if {$addmask == ""} {putquick "PRIVMSG $chan :\037ERROR\037: Incorrect Parameters. \037SYNTAX\037: [getIgnoreTrig]ignore add <*!*@host.mask.whatever> <duration:in:minutes> <your reasons whatever> - [getIgnoreTrig]ignore del <*!*@host.mask.whatever>"; return}
      if {[isignore $addmask]} {putquick "PRIVMSG $chan :\037ERROR\037: This is already a Valid Ignore."; return}
      set duration [lindex [split $text] 2]
      if {$duration == ""} {putquick "PRIVMSG $chan :\037ERROR\037: Incorrect Parameters. \037SYNTAX\037: [getIgnoreTrig]ignore add <*!*@host.mask.whatever> <duration:in:minutes> <your reasons whatever> - [getIgnoreTrig]ignore del <*!*@host.mask.whatever>"; return}
      set reason [join [lrange [split $text] 3 end]]
      if {$reason == ""} {putquick "PRIVMSG $chan :\037ERROR\037: Incorrect Parameters. \037SYNTAX\037: [getIgnoreTrig]ignore add <*!*@host.mask.whatever> <duration:in:minutes> <your reasons whatever> - [getIgnoreTrig]ignore del <*!*@host.mask.whatever>"; return}
      newignore $addmask $hand "$reason" $duration
      putquick "PRIVMSG $chan :\002New Ignore\002: $addmask - \002Duration\002: $duration minutes - \002Reason\002: $reason"
      return 0
    }

    if {[lindex [split $text] 0] == "del"} {
      set delmask [lindex [split $text] 1]
      if {$delmask == ""} {putquick "PRIVMSG $chan :\037ERROR\037: Incorrect Parameters. \037SYNTAX\037: [getIgnoreTrig]ignore add <*!*@host.mask.whatever> <duration:in:minutes> <your reasons whatever> - [getIgnoreTrig]ignore del <*!*@host.mask.whatever>"; return}
      if {![isignore $delmask]} {putquick "PRIVMSG $chan :\037ERROR\037: This is NOT a Valid Ignore."; return}
      killignore $delmask
      putquick "PRIVMSG $chan :\002Removed Ignore\002: $delmask"
      return 0
    }
  }
}

proc ignore:list {nick uhost hand chan text} {
  if {[matchattr [nick2hand $nick] o]} {
    if {[ignorelist] == ""} {
      putquick "NOTICE $nick :\002There are Currently no Ignores\002"
      } else {
      putquick "NOTICE $nick :\002Current Ignore List\002"
      foreach ignore [ignorelist] {
        set ignoremask [lindex $ignore 0]
        set ignorecomment [lindex $ignore 1]
        set ignoreexpire [lindex $ignore 2]
        set ignoreadded [lindex $ignore 3]
        set ignorecreator [lindex $ignore 4]
        set ignoreexpire_ctime [ctime $ignoreexpire]
        set ignoreadded_ctime [ctime $ignoreadded]
        if {$ignoreexpire == 0} {
          set ignoreexpire_ctime "perm"
        }
        putserv "NOTICE $nick : "
        putserv "NOTICE $nick :\002Mask\002: $ignoremask - \002Set by\002: $ignorecreator."
        putserv "NOTICE $nick :\002Reason\002: $ignorecomment"
        putserv "NOTICE $nick :\002Created\002: $ignoreadded_ctime. - \002Expiration\002: $ignoreexpire_ctime."
      }
    }
  }
}

putlog ".:Loaded:. ignore.tcl - istok @ IRCSpeed"
