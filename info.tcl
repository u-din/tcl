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

set _chans "#chating"
set _time 45
set isplaying 1

proc help {nick uhost hand chan text} {
  putserv "PRIVMSG $chan :`start, `stop, `chan \"#channel1 #channel2\", `timer <menit>"
}
proc start {nick uhost hand chan text} {
  global isplaying _time
  if {$isplaying} {
    putserv "PRIVMSG $chan :already running"
  } else {
    set isplaying 1
    putserv "PRIVMSG $chan :is started"
  }
  if {$_time < 1} {set _time 15}
  timer $_time _speaks
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
       if [string match *_speaks* [lindex $t 1]] {
         killtimer [lindex $t end]
       }
    }    
}
proc chan {nick uhost hand chan text} {
  global _chans
  if {$text == ""} {
    putserv "PRIVMSG $chan :usage : `chans \"#channel1 #channel2\" , current channel is $_chans"
  } else {
    set _chans $text
    putserv "PRIVMSG $chan :chan set to : $_chans"
  }
}
proc timer {nick uhost hand chan text} {
  global _time
  if {$text == ""} {
    putserv "PRIVMSG $chan :usage : `timer <menit> , current timer is $_time"
  } else {
    if {$text < 1} {set text 5}
    set _time $text
    putserv "PRIVMSG $chan :timer set to : $_time"
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
set _msg {
{"\00314 Bagi teman2 yg minat \037\002ZNC gratis\002\037\00314 dari Chating.ID, bisa \00304!request <ident>\003\00314 di room \002#znc\002"}

}

if {![string match "*_speaks*" [timers]]} {
 timer $_time _speaks
}
proc _speaks {} {
 global _msg _chans _time
 if {$_chans == ""} {
  set _temp [channels]
 } else {
  set _temp $_chans
 }
 foreach chan $_temp {
  set _rmsg [lindex $_msg [rand [llength $_msg]]]
  foreach msgline $_rmsg {
   puthelp "PRIVMSG $chan :[subst $msgline]"
  }
 }
 if {![string match "*_speaks*" [timers]]} {
  timer $_time _speaks
 }
}
putlog "-=-=   info.tcl loaded =-=-=-=-=-"
bind pub -|- `info rand

proc rand {nick uhost hand chan text} {
 global _msg notc
  set _rmsg [lindex $_msg [rand [llength $_msg]]]
  foreach msgline $_rmsg {
   puthelp "PRIVMSG $chan :$notc $nick, 14[subst $msgline]"
  }
}

