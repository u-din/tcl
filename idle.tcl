# Editor : udin
# Server : irc.chating.id
##################################################

bind pub - ".i" do:whois


proc do:whois {nick uhost handle chan text} {
global workingchan

   if {"$text" == ""} {
      putserv "privmsg $chan :Syntax: .i <nick> "
      return
      }

   bind raw - 317 watch:317
   bind raw - 402 watch:402

   putserv "whois [split $text 0] [split $text 0]"
   set workingchan $chan
}


proc watch:317 {from keyword text} {
global workingchan

   putserv "privmsg $workingchan :[lindex [split $text] 1] has been idle [duration [lindex [split $text] 2]] \[signon [ctime [lindex [split $text] 3]]\]"

   unbind raw - 317 watch:317
   unbind raw - 402 watch:402
}


proc watch:402 {from keyword text} {
global workingchan

   putserv "privmsg $workingchan :\"[string trimleft [lindex $text 2] :] [lrange [split $text] 3 end]\""

   unbind raw - 317 watch:317
   unbind raw - 402 watch:402
}


putlog "Loaded Idle"
