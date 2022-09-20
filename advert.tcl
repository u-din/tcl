
    #                       
    #       +------------------------------------------------------+
    #       | © Christian 'chris' Hopf <mail@dev.christianhopf.de> |
    #       +------------------------------------------------------+
    #                                                                     
    #          
    #           developer:  Christian 'chris' Hopf
    #           system:     eggdrop v1.6.18 - tcl/tk v.8.5a2
    #           product:    advert script
    #           version:    1.4
    #                         
    #           contact:    mail@dev.christianhopf.de
    #           irc:        #chris at QuakeNet
    #           web:        www.christianhopf.de
    #


    # advert script v1.4
    # copyright (c) 2006 Christian 'chris' Hopf

    # This program is free software; you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation; either version 2 of the License, or
    # (at your option) any later version.

    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.

    # You should have received a copy of the GNU General Public License
    # along with this program; if not, write to the Free Software
    # Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
    #
    #
    # changelog
    #
    #   02.12.2005 - v1.0 - release
    #   03.12.2005 - v1.1/v1.2 - fix:
    #                 - kills the timer, without disabling status
    #                 - small nosense bugs fixed
    #                 - bot reset modes correctly
    #   11.04.2006 - v1.3 - fix:
    #                 - added /msg commands
    #                 - script didn't automatically started after bot restart
    #                 - fixed some problems with chanmodes etc..
    #                add:
    #                 - new triggers (like NULL (no trigger, only command))
    #   27.04.2006 - v1.4 - fix:
    #                 - help doens't work because of stupid mistake ;)
    #
    # short readme
    #   after setting up your eggdrop, you can get a list of all commands with 
    #   <botnick> help 
    #   or
    #   !help (only if u havn't change anything)
    #
    
    # --- namespace ::advert
    namespace eval ::advert {
           
  
      # --- namespace variable   
      namespace eval variable {
        
        # string variable default trigger [ no change need ]
        variable trigger "!"
        
        # string variable keyword [ need for /msg ]
        variable keyword "advert"
        
        # integer variable timer (must be greater than 15)              
        variable timer 30
        
        # string variable flag
        variable flag "n|n"
        
        # string variable database
        variable database ".advert.db"       
        
        # {{{ NOW don't change anything, if you aren't 100% sure what you are doing }}}
        # {{{ NOW don't change anything, if you aren't 100% sure what you are doing }}}
        # {{{ NOW don't change anything, if you aren't 100% sure what you are doing }}}
        # {{{ NOW don't change anything, if you aren't 100% sure what you are doing }}} 
        
        # initializes user defined string
        setudef flag advert-status
        setudef int advert-timer
        setudef int advert-id
        
        # string variable author
        variable author "2006 Christian 'chris' Hopf \002(\002#chris - www.christianhopf.de\002)\002"
        
        # string variable version
        variable version "v1.4"
      
      }      
      
      if { $::advert::variable::timer < 15 } { 
        set ::advert::variable::timer 15
      }
      
      if {![file exists $::advert::variable::database]} {
        if { [catch { set database [open $::advert::variable::database "w"] } error] } {
          die "can't create file <:( \[$::advert::variable::database\]"
        }
        
        puts -nonewline $database ""
        close $database
      }        
              
      
      # binds
      bind PUBM -|- {*} ::advert::pubm
      bind MSGM -|- {*} ::advert::msgm
      
      # - void proc pubm {bind PUBM}
      proc pubm { nickname hostname handle channel arguments } {
          ::advert::irc::parse $nickname $hostname $handle $arguments $channel "pubm"
      }
      
      # - void proc msgm {bind MSGM}
      proc msgm { nickname hostname handle arguments } {
          ::advert::irc::parse $nickname $hostname $handle $arguments [lindex [split $arguments] 2] "msgm"
      }      
      
      
      # namespace eval irc
      namespace eval irc {   
        
        # - void proc parse
        proc parse { nickname hostname handle arguments channel mode} {
            global botnick lastcommand channelcommand lastnickname lasthandle lastchannel lasttrigger lastucommand
            
            set utrigger [getuser $handle XTRA advert-trigger]
            set temp $channel
    
            if { $mode == "pubm" } {
              if {[llength $utrigger] < 1} {
                set utrigger [join [string trim $::advert::variable::trigger]]
              }
    
              if { [string equal -nocase $botnick [lindex [split $arguments] 0]]} {
                set command [string tolower [lindex [split $arguments] 1]]
                set arguments [join [lrange [split $arguments] 2 end]]
                set trigger "$botnick $command"
  
              } elseif { $utrigger == "NULL" }  {
                set command [string tolower [lindex [split $arguments] 0]]
                set arguments [join [lrange [split $arguments] 1 end]]
                
                set trigger "$command"
              
              } elseif { [string equal -nocase [string index [lindex [split $arguments] 0] 0] $utrigger] } {
                set command [string range [string tolower [lindex [split $arguments] 0]] 1 end]
                set arguments [join [lrange [split $arguments] 1 end]]
  
                set trigger "${utrigger}$command"
              } else {
                return
              }
              
              if {[string index [lindex [split $arguments] 0] 0] == "#" && [validchan [lindex [split $arguments] 0]]} {
                set channel [lindex [split $arguments] 0]
                set arguments [join [lrange [split $arguments] 1 end]]
              }
            
            } elseif { $mode == "msgm" } {
              if { [string equal -nocase [lindex [split $arguments] 0] ${::advert::variable::keyword}] } {
                set command [lindex [split $arguments] 1]
                set channel [lindex [split $arguments] 2]              
                set arguments [join [lrange [split $arguments] 3 end]]
                set trigger "$::advert::variable::keyword $command"          
              } else {
                return
              }
              
            } else {
              return
            }
            
            if { ![matchattr $handle $::advert::variable::flag $temp] } {
              return
            } elseif {![info exists trigger] || [llength $trigger] < 1} {
              return
            } elseif {(![info exists command] || [llength $command] < 1)} {
              return
            } elseif { [info proc ::advert::irc::command:$command] == ""  } {
              return
            } elseif { ![regexp -- {^#(.+)$} $channel] || ![validchan $channel] } {
              putquick "PRIVMSG $nickname :\002(\002advert\002)\002 you forgot the channel parameter"
              
              return
            }
            
            set channelcommand "$temp"
            set lastcommand  "$trigger"
            set lastucommand "$command"
            set lastnickname "$nickname"
            set lasthandle "$handle"
            set lastchannel "$channel"
            set lasttrigger [join [lrange $trigger 0 end-1]]
            
            ::advert::irc::command:$command $nickname $hostname $handle $channel $arguments
        }
        
        
        
        # - void proc add
        proc command:add { nickname hostname handle channel arguments } {
            global lastcommand
            
            set trigger [::advert::utilities::trigger $handle]
            
            if { [llength $arguments] < 1 } {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 synta\037x\037\002:\002 $lastcommand \037?#channel?\037 <message>"  
              return
            }
  
            if {[::advert::utilities::exists $channel $arguments]} {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 message does already appear in the database."
            } elseif {[::advert::utilities::add $channel $arguments]} {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 message successfully added to the database."
              
              if {[llength [::advert::utilities::create:list $channel]] == 1} {
                putquick "NOTICE $nickname :\002(\002advert\002)\002 to start the script timer please use ${trigger}status \037enable\037"
                
                channel set $channel advert-id 1
              }
                           
            } else {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 error while adding channel message to the database."
            }
        }
        
        # - void proc remove
        proc command:remove { nickname hostname handle channel arguments } {
            global lastcommand
            
            set trigger [::advert::utilities::trigger $handle] 
            
            if { [llength $arguments] < 1 } {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 synta\037x\037\002:\002 $lastcommand \037?#channel?\037 <message>"  
              return
            }
                         
            if {![::advert::utilities::exists $channel $arguments]} {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 message doesn't appear in the database."
            } elseif {[::advert::utilities::remove $channel $arguments]} {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 message successfully removed from the database."
              
              if {[expr [llength [::advert::utilities::create:list $channel]] + 1] == [set max [channel get $channel advert-id]]} { 
                channel set $channel advert-id 1
              }
              
              if {[llength [::advert::utilities::create:list $channel]] == 0 && [timerexists [list ::advert::utilities::display $channel]] != ""} {
                  killtimer [timerexists [list ::advert::utilities::display $channel]]
                  channel set $channel -advert-status
                  
                  putquick "NOTICE $nickname :\002(\002advert\002)\002 advert script turned \0034off\003, because no messages are in the database"
              }
                          
            } else {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 error while removing channel message from the database."
            }
        }
        
        # - void proc status
        proc command:status { nickname hostname handle channel arguments } {        
            global lastcommand
            set trigger [::advert::utilities::trigger $handle]
            
            if { [llength $arguments] < 1 } {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 synta\037x\037\002:\002 $lastcommand \037?#channel?\037 \037enable\037|\037disable\037"  
              putquick "NOTICE $nickname :\002(\002advert\002)\002 currently advert script is [expr {([channel get $channel "advert-status"]) ? "\0033enabled\003" : "\0034disabled\003"}] "
              
              return
            } 
                     
            if { [llength [::advert::utilities::create:list $channel]] == 0 && [string tolower $arguments] == "enable" } {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 warnin\037g\037\002:\002 can't start script, because no messages are in the database"
              
              return
            }
            
            if {[string tolower $arguments] == "enable" || [string tolower $arguments] == "disable"} {
              channel set $channel [expr {([string equal -nocase enable $arguments]) ? "+" : "-"}]advert-status                   
              putquick "NOTICE $nickname :\002(\002advert\002)\002 advert script is now [expr {([channel get $channel "advert-status"]) ? "\0033enabled\003" : "\0034disabled\003"}] "
            }
            
            ::advert::utilities::create:timer $channel         
        }          
        
        # - void proc help
        proc command:help { nickname hostname handle channel arguments } { 
            ::advert::irc::command:userhelp $nickname $hostname $handle $channel $arguments
        }
        
        # - void proc showcommands
        proc command:showcommands { nickname hostname handle channel arguments } { 
            ::advert::irc::command:userhelp $nickname $hostname $handle $channel $arguments
        }
        
        
        # - void proc userhelp
        proc command:userhelp { nickname hostname handle channel arguments } {            
            set trigger [::advert::utilities::trigger $handle]          
            putquick "NOTICE $nickname :\002(\002advert\002)\002 \037help overview\002\037:\002"               
            putquick "NOTICE $nickname :\002(\002advert\002)\002 ${trigger}status \037?channel?\037 <enable/disable>"
            putquick "NOTICE $nickname :\002(\002advert\002)\002 ${trigger}add \037?channel?\037 <message>"
            putquick "NOTICE $nickname :\002(\002advert\002)\002 ${trigger}remove \037?channel?\037 <#id/message>"
            putquick "NOTICE $nickname :\002(\002advert\002)\002 ${trigger}timer \037?channel?\037 <minutes>"
            putquick "NOTICE $nickname :\002(\002advert\002)\002 ${trigger}list \037?channel?\037"
            putquick "NOTICE $nickname :\002(\002advert\002)\002 ${trigger}trigger \037?#id?\037 \002(\002personal trigger, not global trigger\002)\002"
            putquick "NOTICE $nickname :\002(\002advert\002)\002 ${trigger}version \037?channel?\037"           
        }
        
        # - void proc trigger
        proc command:trigger { nickname hostname handle channel arguments } { 
            global botnick botname lastcommand
            set trigger [::advert::utilities::trigger $handle]
  
            array set triggers {
              "1" {$} "2" {!} "3" {?} "4" {.} "5" {-}
              "6" {²} "7" {%} "8" {&} "9" {*} "10" {:}
              "11" {§} "12" {°} "13" {^} "14" {NULL}
            }
                 
            if { [llength $arguments] < 1 } {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 synta\037x\037\002:\002 $lastcommand \037?#id?\037" 
              putquick "NOTICE $nickname :\002(\002advert\002)\002 curren\037t\037\002:\002 $trigger"
              set list ""
              set id   0
              
              while {$id < 10} {
                incr id 1
                lappend list "#$id ($triggers($id))"
              }
              
              putquick "NOTICE $nickname :\002(\002advert\002)\002 available triggers are:"
              putquick "NOTICE $nickname :[join $list ", "]"
              
              return
            }               
            
          if { [string range $arguments 1 2] < 15 && [string range $arguments 1 2] > 0 } {
            setuser $handle XTRA advert-trigger $triggers([string range $arguments 1 2])
            putquick "NOTICE $nickname :\002(\002advert\002)\002 your personal trigger is now: [getuser $handle XTRA advert-trigger]"
          } else {
            putquick "NOTICE $nickname :\002(\002advert\002)\002 synta\037x\037\002:\002 $lastcommand \037?\002#\002id?\037"
          }
        }        
        
        # - void proc timer
        proc command:timer { nickname hostname handle channel arguments } {    
            global lastcommand
            set trigger [::advert::utilities::trigger $handle]
  
            if { [llength $arguments] < 1 } {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 synta\037x\037\002:\002 $lastcommand \037?channel?\037 <minutes>"  
              putquick "NOTICE $nickname :\002(\002advert\002)\002 curren\037t\037\002:\002 [channel get $channel advert-timer]"  
  
              return
            }
            
            if {![isnumber $arguments]} {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 erro\037r\037\002:\002 please enter a valid timer number"   
            } elseif { $arguments < 15 } {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 erro\037r\037\002:\002 timer number must be greater than 14 minutes."   
            } elseif {[channel set $channel advert-timer $arguments] == ""} {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 inf\037o\037\002:\002 timer successfully set to \"[channel get $channel advert-timer]\""   
            } else {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 error while setting timer."
            }
        }   
        
        # - void proc list
        proc command:list { nickname hostname handle channel arguments } {          
            set list ""
            set count [llength [::advert::utilities::create:list $channel]]
            
            if { $count == "1" } {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 $count message is added on my database\002:\002"
            } else {
              putquick "NOTICE $nickname :\002(\002advert\002)\002 $count messages are added on my database\002:\002"
            }
            
            set number 1
            
            foreach messages [::advert::utilities::create:list $channel] {                
              putquick "NOTICE $nickname :\002(\002advert\002)\002 \002\[\002#${number}\002\]\002 [join $messages]"
              
              incr number
            }
            
            unset number
          }          
        
        # - void proc version
        proc command:version { nickname hostname handle channel arguments } {            
            if {[info exists ::advert(protection_v)] && [expr [unixtime] - $::advert(protection_v)] < 30} { 
              return
            }
          
            putquick "PRIVMSG $channel :\001ACTION is running the advert script $::advert::variable::version \002(\002c\002)\002 $::advert::variable::author\001"
            set ::advert(protection_v) [unixtime]        
        }
      }            


      # namespace eval utilities
      namespace eval utilities {
        
        # - void proc exists
        proc exists { channel message } {
          if {[catch { set database [open $::advert::variable::database "r"] } error]} { 
            return 0
          }
          
          set number 1
          
          while {![eof $database]} {
            if {[set line [gets $database]] != ""} {
              if { [lindex [split $line] 0] != $channel } { 
                continue
              }
              
              if {![isnumber [string range [join $message] 1 end]]} {
                if {[lindex [split $line] 0] == "$channel" && [lindex [split $line] 1] == "[decrypt www.christianhopf.de $message]"} {
                  close $database
                  
                  return 1
                }
              } else {
                if {[lindex [split $line] 0] == "$channel" && $number == [string range [join $message] 1 end]} {
                  close $database
                  
                  return 1
                }
              }
            }
            incr number
          }
              
          close $database
          return 0
        }
        
        # - void proc add
        proc add { channel message } {
          if {[catch { set database [open $::advert::variable::database "a"] } error]} { 
            return 0
          }
          
          puts $database "$channel [encrypt www.christianhopf.de $message]"
          close $database
          return 1
        }        
        
        # - void proc remove
        proc remove { channel message } {
          if {[catch { set database [open $::advert::variable::database "r"] } error]} { 
            return 0
          }
          
          set refill ""
          set number 1
          
          while {![eof $database]} {
            if {[set line [gets $database]] != ""} {
              if {[lindex [split $line] 0] == "$channel"} {
                if {[lindex [split $line] 1] == "[decrypt www.christianhopf.de $message]" || ([isnumber [string range [join $message] 1 end]] && $number == [string range [join $message] 1 end])} { 
                  incr number
                  
                  continue
                }
                
                incr number;
              }
              
              lappend refill $line
            }
          }
          
          close $database
          set database [open $::advert::variable::database "w"]
          
          foreach data_refill $refill {
            puts $database $data_refill
          }
          
          close $database
          return 1
        }          
        
        # - void proc create:list
        proc create:list { channel } {
          set data ""
          set database [open $::advert::variable::database "r"]
          
          while {![eof $database]} {
            if {[set line [gets $database]] != ""} {
              if { [lindex [split $line] 0] == "$channel" } {
                lappend data "[decrypt www.christianhopf.de [join [lrange [split $line] 1 end]]]"
              }
            }
          }
          
          close $database
          return $data
        }
        
        # - void proc create:timer  
        proc create:timer { channel } {
          if {[channel get $channel advert-status]} {
            if {[set timer [channel get $channel advert-timer]] > 14} {
              timer $timer [list ::advert::utilities::display $channel]
            } else {
              channel set $channel advert-timer $::advert::variable::timer                      
              timer $::advert::variable::timer [list ::advert::utilities::display $channel]
            }           
          } else {
            if {[timerexists [list ::advert::utilities::display $channel]] != ""} { 
              killtimer [timerexists [list ::advert::utilities::display $channel]]
            }
          }   
        }
        
        # - void proc trigger {required string handle}
        proc trigger { handle } {
          set utrigger [getuser $handle XTRA advert-trigger]
          
          if {[llength $utrigger] < 1 || ![validuser $handle]} {
            set utrigger [join [string trim $::advert::variable::trigger]]
          }
                     
          return $utrigger        
        }
                   
        # - void proc display
        proc display { channel } {
          set data [::advert::utilities::create:list $channel]
          set maxmessageid [llength $data]
          set messageid [channel get $channel advert-id]
          set number 1

          foreach message [::advert::utilities::create:list $channel] {                
            if { $number == $messageid } {              
              set modes ""
              set remodes ""
              
              if { [string match *c* [lindex [split [getchanmode $channel]] 0]] } {
                append modes "-c"
                append remodes "+c"
              }
              
              if { ![string match *m* [lindex [split [getchanmode $channel]] 0]] } { 
                append modes "+m"
                append remodes "-m" 
              }
              
              if { [string match "*\003*" $message] || [string match "*\002*" $message] } {
                set iscolored 1
              }
             
              if { $modes != "" && [botisop $channel] } {
                putquick "MODE $channel $modes"
                utimer 2 [list putquick "MODE $channel $remodes"]
              } elseif { [info exists iscolored] && ![botisop $channel] && [string match "*c*" $modes]} {
                set message [stripcodes rcub $message]
              }
              
              putquick "PRIVMSG $channel :[join $message]"
              
              if { [timerexists [list ::advert::utilities::display $channel]] == "" } {
                timer [channel get $channel advert-timer] [list ::advert::utilities::display $channel]
              }
              
              if { $number == $maxmessageid } { 
                channel set $channel advert-id 1
              } else {
                channel set $channel advert-id [expr $messageid + 1]
              }
            }
            
            incr number
          }
        }
      }
      
     utimer 10 {
        foreach start_channel [channels] {
          if {![channel get $start_channel advert-status] || [timerexists [list ::advert::utilities::display $start_channel]] != ""} { 
            continue
          }
        
          if {[llength [::advert::utilities::create:list $start_channel]] == 0} { 
            channel set $start_channel -advert-status
            
            continue
          }
        
          ::advert::utilities::create:timer $start_channel       
        }
      }    
      
      # log
      putlog "advert version <${::advert::variable::version}> (c) $::advert::variable::author successfully successfully loaded ..."  
      
    }