#---------------------------------------------------------------------#
# incith:kurs                                                    v3.0 #
#                                                                     #
# currency converions from http://ca.finance.yahoo.com/currency       #
# tested on Eggdrop & Windrop v1.6.19                                 #
#                                                                     #
# Usage:                                                              #
#   .chanset #channel +kurs                                           #
#   !kurs <amount> <from> <into>                                      #
#                                                                     #
# ChangeLog:                                                          #
#   3.0: script brought up to date.                                   #
#                                                                     #
# Contact:                                                            #
#   E-mail (incith@gmail.com) cleanups, ideas, bugs, etc., to me.     #
#                                                                     #
# TODO:                                                               #
#   - flood protection                                                #
#   - max length variable for output, to prevent HTML floods          #
#                                                                     #
# LICENSE:                                                            #
#   This code comes with ABSOLUTELY NO WARRANTY.                      #
#                                                                     #
#   This program is free software; you can redistribute it and/or     #
#   modify it under the terms of the GNU General Public License as    #
#   published by the Free Software Foundation; either version 2 of    #
#   the License, or (at your option) any later version.               #
#   later version.                                                    #
#                                                                     #
#   This program is distributed in the hope that it will be useful,   #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of    #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.              #
#                                                                     #
#   See the GNU General Public License for more details.              #
#   (http://www.gnu.org/copyleft/library.txt)                         #
#                                                                     #
# Copyleft (C) 2005-09, Jordan                                        #
# http://incith.com ~ incith@gmail.com ~ irc.freenode.net/#incith     #
#---------------------------------------------------------------------#
package require http
setudef flag kurs
package require tls
::http::register https 443 tls:socket 

proc tls:socket args { 
   set opts [lrange $args 0 end-2] 
   set host [lindex $args end-1] 
   set port [lindex $args end] 
   ::tls::socket -servername $host {*}$opts $host $port 
}

namespace eval incith::kurs {
  # the bind prefix/command char(s) {!} or {! .} etc, seperate with space)
  variable command_chars {! .}

  # binds {one two three}
  variable binds {kurs}

  # allow binds to be used in /msg's to the bot?
  variable private_messages 1

  # send public/channel output to the user instead?
  variable public_to_private 0

  # send replies as notices instead of private messages?
  variable notices 0

  # only send script 'errors' as notices? (invalid input etc)
  variable notice_errors_only 0

  # maximum length of a reply before breaking it up
  variable split_length 440

  # if you're using a proxy, enter it here {hostname.com:3128}
  variable proxy {}

  # how long (in seconds) before the http request times out?
  variable timeout 15

  # use the callback function for non-blocking http fetches?
  # note: your eggdrop must be patched or else this will slow
  # lookups down a lot and even break some things.
  variable callback 0
}

# script begings
namespace eval incith::kurs {
  variable version "incith:kurs-3.0"
  variable debug 0
  array set static {}
}

# bind the binds
foreach command_char [split ${incith::kurs::command_chars} " "] {
  foreach bind [split ${incith::kurs::binds} " "] {
    # public message binds
    bind pub -|- "${command_char}${bind}" incith::kurs::message_handler

    # private message binds
    if {${incith::kurs::private_messages} >= 1} {
      bind msg -|- "${command_char}${bind}" incith::kurs::message_handler
    }
  }
}

namespace eval incith::kurs {
  # [message_handler] : handles public & private messages
  #
  proc message_handler {nick uhand hand args} {
    set input(who) $nick
    if {[llength $args] >= 2} { # public message
      set input(where) [lindex $args 0]
      if {${incith::kurs::public_to_private} >= 1} {
        set input(chan) $input(who)
        } else {
        set input(chan) $input(where)
      }
      set input(query) [lindex $args 1]
      if {[channel get $input(where) kurs] != 1} {
        return
      }
      } else {                    # private message
      set input(where) "private"
      set input(chan) $input(who)
      set input(query) [lindex $args 0]
      if {${incith::kurs::private_messages} <= 0} {
        return
      }
    }

    # TODO: check flood protection here

    # log it
    ipl $input(who) $input(where) $input(query)

    # do some things:
    foreach {amount from into} $input(query) { break }
    if {[info exists amount] && $from != "" && $into != ""} {
      set input(amount) $amount
      set input(from) [string toupper $from]
      set input(into) [string toupper $into]
      # set input(query) "http://ca.finance.yahoo.com/currencies/converter?amt=$input(amount)&from=$input(from)&to=$input(into)&submit=Convert"
      # set input(query) "http://finance.google.com/finance/converter?a=$input(amount)&from=$input(from)&to=$input(into)"
      # set input(query) "http://www.calculator.net/currency-calculator.html?csShowAll=false&eamount=$input(amount)&efrom=$input(from)&eto=$input(into)&type=1&x=$input(amount)"
	  set input(query) "https://www.calculator.net/currency-calculator.html?eamount=$input(amount)&efrom=$input(from)&eto=$input(into)&type=1&x=68&y=22"
	  #set input(query) "https://www.calculatorsoup.com/calculators/financial/currency-converter.php?input_value=$input(amount)&input=$input(from)&output=$input(into)&input_last=$input(from)&output_last=$input(into)&action=solve"
      } else {
      send_output $input(chan) "Syntax: !kurs <amount> <from> <into>, see https://www.calculator.net/currency-calculator.html for symbols." $input(who)
      return
    }
    fetch_html [array get input]
  }


  # [fetch_html] : fetch html of a given url
  #
  proc fetch_html {tmpInput} {
    upvar #0 incith::kurs::static static
    array set input $tmpInput

    # setup the timeout, for use below
    set timeout [expr round(1000 * ${incith::kurs::timeout})]
    # setup proxy information, if any
    if {[string match {*:*} ${incith::kurs::proxy}] == 1} {
      set proxy_info [split ${incith::kurs::proxy} ":"]
    }
    # the "browser" we are using
    # NT 5.1 - XP, NT 6.0 - Vista
    set ua "Opera/9.63 (Windows NT 6.0; U; en)"
    if {[info exists proxy_info] == 1} {
      ::http::config -useragent $ua -proxyhost [lindex $proxy_info 0] -proxyport [lindex $proxy_info 1]
      } else {
      ::http::config -useragent $ua
    }
    # retrieve the html
    if {$incith::kurs::callback >= 1} {
      catch {set token [::http::geturl "$input(query)" -command incith::kurs::httpCommand -timeout $timeout]} output(token_status)
      } else {
      catch {set token [::http::geturl "$input(query)" -timeout $timeout]} output(token_status)
    }
    # need to check for some errors here:
    if {[string match "couldn't open socket: host is unreachable" $output(token_status)]} {
      send_output $input(chan) "Unknown host." $input(who)
      return
    }
    set static($token,input) [array get input]
    # manually call our callback procedure if we're not using callbacks
    if {$incith::kurs::callback <= 0} {
      httpCommand $token
    }
  }


  # [httpCommand] : makes sure the http request succeeded
  #
  proc httpCommand {token} {
    upvar #0 $token state
    upvar #0 incith::kurs::static static
    # build the output array
    array set output $static($token,input)

    switch -exact [::http::status $token] {
      "timeout" {
        if {$incith::kurs::debug >= 1} {
          ipl $output(who) $output(where) "status = timeout (url = $state(url))"
        }
        set output(error) "Operation timed out after ${incith::kurs::timeout} seconds."
      }
      "error" {
        if {$incith::kurs::debug >= 1} {
          ipl $output(who) $output(where) "status = error([::http::error $token]) (url = $state(url))"
        }
        set output(error) "An unknown error occurred. (Error #01)"
      }
      "ok" {
        switch -glob [::http::ncode $token] {
          3* {
            array set meta $state(meta)
            if {$incith::kurs::debug >= 1} {
              ipl $output(who) $output(where) "redirecting to $meta(Location)"
            }
            set output(query) $meta(Location)
            # fetch_html $output(where) $output(who) $output(where) $meta(Location)
            fetch_html [array get output]
            return
          }
          200 {
            if {$incith::kurs::debug >= 1} {
              ipl $output(who) $output(where) "parsing $state(url)"
            }
          }
          default {
            if {$incith::kurs::debug >= 1} {
              ipl $output(who) $output(where) "status = default, error"
            }
            set output(error) "An unknown error occurred. (Error #02)"
          }
        }
      }
      default {
        if {$incith::kurs::debug >= 1} {
          ipl $output(who) $output(where) "status = unknown, default, error"
        }
        set output(error) "An unknown error occurred. (Error #03)"
      }
    }
    set static($token,output) [array get output]
    process_html $token
  }


  # [process_html] :
  #
  proc process_html {token} {
    upvar #0 $token state
    upvar #0 incith::kurs::static static
    array set output $static($token,output)

    # get the html
    set html $state(body)

    # store the HTML to a file
    if {$incith::kurs::debug >= 1} {
      set fopen [open incith-kurs.html w]
      puts $fopen $html
      close $fopen
    }

    # html cleanups
    regsub -all {\n} $html {} html
    regsub -all {\t} $html {} html
    regsub -all {&nbsp;} $html { } html
    regsub -all {&gt;} $html {>} html
    regsub -all {&lt;} $html {<} html

    # html parsing
    #
    # regexp {<div id=currency_converter_result>(.+?) (.+?) = <span class=bld>(.+?) (.+?)</span>} $html - $output(amount) output(curfrom) output(curamount) output(curinto)
     regexp {<h2 class=\"h2result\">Result</h2><p class=\"verybigtext\">(.+?) (.+?) = <font color=green><b>(.+?)</b></font> (.+?)<br>} $html - $output(amount) output(curfrom) output(curamount) output(curinto)
	#regexp {<h2 class=\"h2result\">Result</h2><p class=\"verybigtext\">(.+?) (.+?) = <font color=green><b>(.+?)</b></font> (.+?)<br>.*? = <font color=green><b>(.+?)</b></font>} $html - $output(amount) output(curfrom) output(curamount) output(curinto) output(curlain)
	
    # check for errors, don't overwrite any previous error
#    if {![info exists output(error)]} {
#      if {(![info exists output(curfrom)] || ![info exists output(curinto)] || ![info exists output(curamount)])} {
#        set output(error) "Either '$output(from)' or '$output(into)' are invalid symbols, or something failed while attempting to parse the results."
#		}
#	}

    if {($output(curamount) == "inf") || ($output(curamount) == "nan") || ($output(curamount) == "0") } {
	set output(error) "Either '$output(curfrom)' or '$output(curinto)' are invalid symbols, or something failed while attempting to parse the results."
	}

    # process the output array
    set static($token,output) [array get output]
    process_output $token
    return 1
  }


  # [process_output] : create the output and send it
  #
  proc process_output {token} {
    upvar 0 $token state
    upvar 0 incith::kurs::static static
    array set output $static($token,output)

    # check for errors
    if {[info exists output(error)]} {
      send_output $output(chan) $output(error) $output(who)
      return
    }

    # send the result
     send_output $output(chan) "3Konversi Mata Uang 712 $output(amount)1 $output(curfrom) 4=12 $output(curamount)1 $output(curinto)."
#    if {($output(curamount) != "inf"} {
#		if {($output(curamount) != "nan"} {
#      send_output $output(chan) "\00304$output(amount)\003\002 $output(curfrom) \002makes\00303 $output(curamount)\003\002 $output(curinto)\002."
#    } else { send_output $output(chan) "\00304\002NOT FOUND\!\00312\002 Maybe an error in your writing.\00306 Xie Xie.\003" }
#}
    # clean the static array for this http session
    foreach value [array get static] {
      if {[info exists static($value)]} {
        if {[string match *${token}* $value]} {
          unset static($value)
        }
      }
    }
  }


  # [ipl] : a neat/handy putlog procedure
  proc ipl {who {where {}} {what {}}} {
    if {$where == "" && $what == ""} {
      putlog "${incith::kurs::version}: ${who}"
      } elseif {$where != "" && $what == ""} {
      putlog "${incith::kurs::version}: <${who}/${where}>"
      } else {
      putlog "${incith::kurs::version}: <${who}/${where}> ${what}"
    }
  }


  # [send_output] : sends $data appropriately out to $where
  #
  proc send_output {where data {isErrorNick {}}} {
    if {${incith::kurs::notices} >= 1} {
      foreach line [incith::kurs::line_wrap $data] {
        putquick "NOTICE $where :${line}"
      }
      } elseif {${incith::kurs::notice_errors_only} >= 1 && $isErrorNick != ""} {
      foreach line [incith::kurs::line_wrap $data] {
        putquick "NOTICE $isErrorNick :${line}"
      }
      } else {
      foreach line [incith::kurs::line_wrap $data] {
        putquick "PRIVMSG $where :${line}"
      }
    }
  }


  # [line_wrap] : takes a long line in, and chops it before the specified length
  # http://forum.egghelp.org/viewtopic.php?t=6690
  #
  proc line_wrap {str {splitChr {}}} {
    set out [set cur {}]
    set i 0
    set len $incith::kurs::split_length
    foreach word [split [set str][set str ""] $splitChr] {
      if {[incr i [string len $word]] > $len} {
        lappend out [join $cur $splitChr]
        set cur [list $word]
        set i [string len $word]
        } else {
        lappend cur $word
      }
      incr i
    }
    lappend out [join $cur $splitChr]
  }
}

# the script has loaded.
incith::kurs::ipl "loaded."

# EOF
