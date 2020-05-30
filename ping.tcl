# ping.tcl by udin
# requires Tcl 8.4 or later

##### CONFIGURATION #########

set vPingTrigger "."

##### CODE ##################

proc pPingTrigger {} {
  global vPingTrigger
  return $vPingTrigger
}

set vPingVersion 1.1

setudef flag ping

bind CTCR - PING pPingCtcrReceive
bind PUB - [pPingTrigger]ping pPingPubCommand
bind RAW - 401 pPingRawOffline

proc pPingTimeout {} {
  global vPingOperation
  set schan [lindex $vPingOperation 0]
  set snick [lindex $vPingOperation 1]
  set tnick [lindex $vPingOperation 2]
  putserv "PRIVMSG $schan :\00304Error\003 (\00314$snick\003) timed out \00307$tnick\003"
  unset vPingOperation
  return 0
}

proc pPingCtcrReceive {nick uhost hand dest keyword txt} {
  global vPingOperation
  if {[info exists vPingOperation]} {
    set schan [lindex $vPingOperation 0]
    set snick [lindex $vPingOperation 1]
    set tnick [lindex $vPingOperation 2]
    set time1 [lindex $vPingOperation 3]
    if {([string equal -nocase $nick $tnick]) && ([regexp -- {^[0-9]+$} $txt])} {
      set time2 [expr {[clock clicks -milliseconds] % 16777216}]
      set elapsed [expr {(($time2 - $time1) % 16777216) / 1000.0}]
      set char [encoding convertto utf-8 \u258C]
      if {[expr {round($elapsed / 0.5)}] > 10} {set red 10} else {set red [expr {round($elapsed / 0.5)}]}
      set green [expr {10 - $red}]
      set output \00303[string repeat $char $green]\003\00304[string repeat $char $red]\003
      putserv "PRIVMSG $schan :\00310$tnick pong\003 $output $elapsed detik"
# - oleh \00307$snick\003"
      unset vPingOperation
      pPingKillutimer
    }
  }
  return 0
}

proc pPingKillutimer {} {
  foreach item [utimers] {
    if {[string equal pPingTimeout [lindex $item 1]]} {
      killutimer [lindex $item 2]
    }
  }
  return 0
}

proc pPingPubCommand {nick uhost hand channel txt} {
  global vPingOperation
  if {[channel get $channel ping]} {
    switch -- [llength [split [string trim $txt]]] {
      0 {set tnick $nick}
      1 {set tnick [string trim $txt]}
      default {
        putserv "PRIVMSG $channel :\00304Error\003 (\00314$nick\003) syntax yang benar adalah \00307.ping ?target?\003"
        return 0
      }
    }
    if {![info exists vPingOperation]} {
      if {[regexp -- {^[\x41-\x7D][-\d\x41-\x7D]*$} $tnick]} {
        set time1 [expr {[clock clicks -milliseconds] % 16777216}]
        putquick "PRIVMSG $tnick :\001PING [unixtime]\001"
        utimer 20 pPingTimeout
        set vPingOperation [list $channel $nick $tnick $time1]
      } else {putserv "PRIVMSG $channel :\00304Error\003 (\00314$nick\003) \00307$tnick\003 tidak ada nicknya"}
    } else {putserv "PRIVMSG $channel :\00304Error\003 (\00314$nick\003) ping masih pending, mohon ditunggut"}
  }
  return 0
}

proc pPingRawOffline {from keyword txt} {
  global vPingOperation
  if {[info exists vPingOperation]} {
    set schan [lindex $vPingOperation 0]
    set snick [lindex $vPingOperation 1]
    set tnick [lindex $vPingOperation 2]
    if {[string equal -nocase $tnick [lindex [split $txt] 1]]} {
	set disabledn "me"
	if {$tnick == $disabledn} { putserv "PRIVMSG $schan :\00304eh blay..\003 pake (\00314.ping\003) atau (\00307.ping nick\003) aja" } else {
      putserv "PRIVMSG $schan :\00304Error\003 (\00314$snick\003) \00307$tnick\003 tidak online" }
      unset vPingOperation
      pPingKillutimer
    }
  }
  return 0
}

putlog "ping.tcl disusun oleh udin version $vPingVersion is loaded" 


putlog "Loading: uptime.tcl"

lappend useless_cmds ".up"

bind pub -|- ".up" useless:uptime

proc useless:uptime {nick idx hand chan args} {
#        if {[kernow:user $nick $idx]==""} { return 0 }
        putquick "PRIVMSG $chan :[exec hostname -f] uptime: [exec uptime]"
}
