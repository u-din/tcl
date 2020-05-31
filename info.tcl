# Editor : udin
# Server : irc.chating.id
####################################################

bind pub o|o `help help
bind pub o|o `start start
bind pub o|o `stop stop
bind pub o|o `chan chan
bind pub o|o `timer timer
#-----------------
bind pub o|o `listtimer xlisttimer
bind pub o|o `killtimer xkilltimer
bind pub o|o `procrun xprocrun

set chans "#chating"
set time 45
set isplaying 1

proc help {nick uhost hand chan text} {
  putserv "PRIVMSG $chan :`start, `stop, `chan \"#channel1 #channel2\", `timer <menit>"
}
proc start {nick uhost hand chan text} {
  global isplaying time
  if {$isplaying} {
    putserv "PRIVMSG $chan :already running"
  } else {
    set isplaying 1
    putserv "PRIVMSG $chan :is started"
  }
  if {$time < 1} {set time 15}
  timer $time speaks
}
proc stop {nick uhost hand chan text} {
  global isplaying
  if {$isplaying} {
    set isplaying 0
    putserv "PRIVMSG $chan :is stoped"
  } else {
    putserv "PRIVMSG $chan :already stoped"
  }
    foreach t [timers] {
       if [string match *speaks* [lindex $t 1]] {
         killtimer [lindex $t end]
       }
    }    
}
proc chan {nick uhost hand chan text} {
  global chans
  if {$text == ""} {
    putserv "PRIVMSG $chan :usage : `chans \"#channel1 #channel2\" , current channel is $_chans"
  } else {
    set chans $text
    putserv "PRIVMSG $chan :chan set to : $chans"
  }
}
proc timer {nick uhost hand chan text} {
  global time
  if {$text == ""} {
    putserv "PRIVMSG $chan :usage : `timer <menit> , current timer is $_time"
  } else {
    if {$text < 1} {set text 5}
    set time $text
    putserv "PRIVMSG $chan :timer set to : $time"
  }
}
proc xkilltimer {nick uhost hand chan text} {
  if { $text == "" } {
    putserv "PRIVMSG $chan :$nick, usage : `killtimer <timerid>"
  } else {
    killtimer $text
    putserv "PRIVMSG $chan :timer $text is killed."
  }
}
proc xlisttimer {nick uhost hand chan text} {
  putserv "PRIVMSG $chan :[timers]"
}
proc xprocrun {nick uhost hand chan text} {
  [$text]
  putserv "[$text]"
}
set msg {
{"\00314 Bagi teman2 yg minat \037\002ZNC gratis\002\037\00314 dari Chating.ID, bisa \00304!request <ident>\003\00314 di room \002#znc\002"}

}

if {![string match "*speaks*" [timers]]} {
 timer $time speaks
}
proc speaks {} {
 global msg chans time
 if {$chans == ""} {
  set temp [channels]
 } else {
  set temp $chans
 }
 foreach chan $temp {
  set rmsg [lindex $msg [rand [llength $msg]]]
  foreach msgline $rmsg {
   puthelp "PRIVMSG $chan :[subst $msgline]"
  }
 }
 if {![string match "*speaks*" [timers]]} {
  timer $time speaks
 }
}
putlog "-=-=   info.tcl loaded =-=-=-=-=-"
bind pub -|- `info rand

proc rand {nick uhost hand chan text} {
 global msg notc
  set rmsg [lindex $msg [rand [llength $msg]]]
  foreach msgline $rmsg {
   puthelp "PRIVMSG $chan :$notc $nick, 14[subst $msgline]"
  }
}

