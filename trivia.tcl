######################################################################
#PLEASE customise the settings before rehashing your bot!            #
######################################################################

#  The full path to the file containing the questions and answers.
#  The account the bot runs on must have read access to this file.
set tgqdb "gamebot/scripts/trivia.questions"
set tgqdbsep "|"

#  What you set here defines how the bot expects the question/answer
#  pairs to be arranged.
#  If set to 1, bot expects lines in the format:
#    question<seperator>answer
#  If set to 0, bot expects lines in the format:
#    answer<seperator>question
set tgqdbquestionfirst 1
set tgerrmethod 0
set tgerremail "irc.withyou.id@gmail.com"
set tgerrmailtmp "/tmp"
set tghtmlrefresh 0
set tghtmlfont "verdana,helvetica,arial"
set tgchan "#event"

#  How many points to give a person for a correctly answered
#  question.
set tgpointsperanswer 30

#  The maximum number of hints to give before the question 'expires'
#  and the bot goes on to another one. This EXCLUDES the first hint
#  given as the question is asked (i.e. the hint which shows no letters,
#  only placeholders).
set tgmaxhint 3

#  Should the bot show the question on each hint (1) or only on the first (0)?
set tgalwaysshowq 0

#  Show questions in all CAPS (1) or not (0)?
set tgcapsquestion 0

#  Show answers in all CAPS (1) or not (0)?
set tgcapsanswer 0

#  Show hints in all CAPS (1) or not (0)?
set tgcapshint 0

#  The minimum number of correct answers in a row by one person which
#  puts them on a winning streak. Setting this to 0 will disable the
#  winning streak feature.
set tgstreakmin 0

#  The number of missed (i.e. unanswered, not skipped) questions to allow
#  before automatically nostopping the game. Setting this to 0 will cause the
#  game to run until somebody uses the nostop command, or the bot dies, gets
#  killed, pings out, or whatever.
set tgmaxmissed 0

#  The character to use as a placeholder in hints.
set tghintchar "*"

#  The time in seconds between hints.
set tgtimehint 20

#  The time in seconds between a correct answer, 'expired' or skipped question
#  and the next question being asked.
set tgtimenext 5

#  Phrases to use at random when someone answers a question correctly. This must
#  be a TCL list. If you don't know what that means, stick to the defaults.
set tgcongrats [list "Congratulations" "Well done" "Nice going" "Way to go" "You got it" "That's the way" "Show 'em how it's done" "Check out the big brain on"]

#  Phrases to use when the question has 'expired'. Must also be a TCL list.
set tgnobodygotit [list "Nobody got it right." "Hello? Anybody home?" "You're going to have to try harder!" "Are these too tough for you?" "Am I alone here or what?" "You're not going to score any points this way!"]

#  Phrases to use when the question expired and there's another one coming up.
#  Yep, you guessed it... another TCL list.
set tgtrythenextone [list "Let's see if you can get the next one..." "Get ready for the next one..." "Maybe you'll get the next one..." "Try and get the next one..." "Here comesthe next one..."]

#  Will the bot calculate the time it took to get the correct
#  answer (1) or not (0)? (requires TCL 8.3 or higher).
set tgtimeanswer 1

#  Will the bot show the correct answer if nobody gets it (1) or not (0)?
set tgshowanswer 1

#  When someone answers a question, will the bot show just that person's score (0)
#  or will it show all players' scores (1) (default). This is useful in channels with
#  a large number (>20) players.
set tgshowallscores 0

#  Use bold codes in messages (1) or not (0)?
set tgusebold 0

#  Send private messages using /msg (1) or not (0)?
#  If set to 0, private messages will be sent using /notice
set tgpriv2msg 0

#  Word to use as /msg command to give help.
#  e.g. set tgcmdhelp "helpme" will make the bot give help when someone
#  does "/msg <botnick> helpme"
set tgcmdhelp "?"

#  Channel command used to start the game.
set tgcmdstart "!start"

#  Flags required to be able to use the start command.
set tgflagsstart "-|-"

#  Channel command used to nostop the game.
set tgcmdnostop "!nostop"

#  Flags required to be able to use the nostop command.
set tgflagsnostop "o|o"

#  Channel command used to give a hint.
set tgcmdhint "!hint"

#  Flags required to be able to use the hint command.
set tgflagshint "-|-"

#  Disable the !hint command x seconds after someone uses it. This
#  prevents accidental double hints if two people use the command in
#  quick succession.
set tgtempnohint 10

#  Channel command used to skip the question.
set tgcmdskip "!skip"

#  Flags required to be able to use the skip command.
set tgflagsskip "o|o"

#  Channel command for showing the top 10 scores.
set tgcmdtop10 "!top10"

#  Flags required to use the top 10 command.
set tgflagnostop10 "-|-"

#  /msg command used to reset scores.
set tgcmdreset "reset"

#  Flags required to be able to use the reset command.
set tgflagsreset "m|m"

#  Require password for resetting scores?
#  If enabled, you must use /msg bot reset <password> to reset scores.
#  The password is the one set by a user using '/msg bot pass'.
set tgresetreqpw 1

#  COLOURS
#  The colour codes used are the same as those used by mIRC:
#  00:white        01:black        02:dark blue    03:dark green
#  04:red          05:brown        06:purple       07:orange
#  08:yellow       09:light green  10:turquoise    11:cyan
#  12:light blue   13:magenta      14:dark grey    15:light grey
#
#  Always specify colour codes as two digits, i.e. use "01" for
#  black, not "1".
#  You can specify a background colour using "00,04" (white text
#  on red background).
#  To disable a colour, use "".
#  Note that disabling some colours but not others may yield
#  unexpected results.

set tgcolourstart "03"          ;#Game has started.
set tgcolournostop "04"         ;#Game has nostopped.
set tgcolourskip "10"           ;#Question has been skipped.
set tgcolourerr "04"            ;#How to report errors.
set tgcolourmiss "10"           ;#Nobody answered the question.
set tgcolourqhead "04"          ;#Question heading.
set tgcolourqbody "12"          ;#Question text
set tgcolourhint "03"           ;#Hint.
set tgcolourstrk "12"           ;#Person is on a winning streak.
set tgcolourscr1 "04"           ;#Score of person in first place.
set tgcolourscr2 "12"           ;#Score of person in second place.
set tgcolourscr3 "03"           ;#Score of person in third place.
set tgcolourrset "04"           ;#Scores have been reset.
set tgcolourstend "12"          ;#Winning streak ended.
set tgcolourmisc1 "06"          ;#Miscellaneous colour #1.
set tgcolourmisc2 "04"          ;#Miscellaneous colour #2.


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                   #
#    Any editing done beyond this point is done at your own risk!   #
#                                                                   #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#Misc checks & var initialisations
set tgver "1.3.4"
set tgrel "release"
if {[info tclversion]<8.2} {
        putlog "\002[file tail [info script]]\002 failed to load: in order to use this script, eggdrop needs to be compiled to use tcl 8.2 or higher (recommended: latest stable version)."
        return
}
if {$tgtimeanswer==1&&[info tclversion]<8.3} {
        putlog "\002[file tail [info script]]\002 warning: timing of answers has been automatically disabled. this feature requires tcl 8.3 or higher."
        set tgtimeanswer 0
}
if {![info exists alltools_loaded]||$allt_version<205} {
        putlog "\002[file tail [info script]]\002 failed to load: please load alltools.tcl v1.14 or higher (available with eggdrop 1.6.13 or higher) before attempting to load this script."
        return
}
if {[utimerexists tghtml]!=""} {killutimer $tghtmlrefreshtimer}
if {$tghtmlrefresh>0} {
        set tghtmlrefreshtimer [utimer $tghtmlrefresh tghtml]
}
if {![file exists $tgqdb]} {
        putlog "\002[file tail [info script]]\002 failed to load: $tgqdb does not exist."
        return
}
if {[llength [split $tgchan]]!=1} {
        putlog "\002[file tail [info script]]\002 failed to load: too many channels specified."
        return
}
if {![info exists tgplaying]} {
        set ctcp-version "${ctcp-version} (with trivia.tcl $tgver ($tgrel) from www.eggdrop.za.net)"
        set tgplaying 0
}
if {![info exists tghintnum]} {set tghintnum 0}
if {![info exists tgmissed]} {set tgmissed 0}

#Binds
bind pubm $tgflagsstart "$tgchan %$tgcmdstart" tgstart
bind pubm $tgflagsnostop "$tgchan %$tgcmdnostop" tgnostop
proc tgbindhintcmd {} {
        global tgflagshint tgcmdhint
        bind pubm $tgflagshint "$::tgchan %$tgcmdhint" tgforcehint
}
proc tgunbindhintcmd {} {
        global tgflagshint tgcmdhint
        unbind pubm $tgflagshint "$::tgchan %$tgcmdhint" tgforcehint
}
tgbindhintcmd
bind pubm $tgflagsskip "$tgchan %$tgcmdskip" tgskip
bind pubm $tgflagnostop10 "$tgchan %$tgcmdtop10" tgshowtop10
bind msg $tgflagsreset "$tgcmdreset" tgresetscores
bind kick - "$tgchan $botnick" tgbotgotkicked
bind evnt - disconnect-server tgbotgotdisconnected

#starts the game if it isn't running.
proc tgstart {nick host hand chan text} {
        global tgplaying tgstreak tgchan tgerrremindtime tgerrremindtimer tgmissed
        if {[strlwr $tgchan]==[strlwr $chan]} {
                if {$tgplaying==0} {
                        tggamemsg "[tgcolstart]Trivia game started by $nick!"
                        tgnextq
                        set tgplaying 1
                        set tgstreak 0
                        set tgmissed 0
                        set tgerrremindtimer [timer $tgerrremindtime tgerrremind]
                }
        }
}

#nostops the game if it's running.
proc tgnostop {nick host hand chan text} {
        global tghinttimer tgnextqtimer tgplaying tgchan tgcurrentanswer tgstreak tgstreakmin
        global tgerrremindtimer tgrebindhinttimer
        if {[strlwr $tgchan]==[strlwr $chan]} {
                if {$tgplaying==1} {
                        tggamemsg "[tgcolnostop]Trivia game nostopped by $nick!"
                        if {$tgstreakmin>0&&[lindex [split $tgstreak ,] 1]>=$tgstreakmin} { tgstreakend }
                        set tgstreak 0
                        set tgplaying 0
                        catch {unbind pubm -|- "$tgchan *" tgcheckanswer}
                        if {[utimerexists tghint]!=""} {killutimer $tghinttimer}
                        if {[utimerexists tgnextq]!=""} {killutimer $tgnextqtimer}
                        if {[timerexists tgerrremind]!=""} {killtimer $tgerrremindtimer}
                        if {[utimerexists tgrebindhinttimer]!=""} {killtimer $tgrebindhinttimer}
                }
        }
}

#gives a hint if there is currently a question to answer.
proc tgforcehint {nick host hand chan text} {
        global tghinttimer tgnextqtimer tgplaying tgchan tgcurrentanswer tgstreak tgstreakmin
        global tgtempnohint tgmaxhintcurrent tghintnum tgrebindhinttimer tgtempnohint
        if {[strlwr $tgchan]==[strlwr $chan]} {
                if {$tgplaying==1&&[utimerexists tghint]!=""} {
                        killutimer $tghinttimer
                        tghint
                        tgunbindhintcmd
                        if {$tghintnum<$tgmaxhintcurrent} {
                                set tgrebindhinttimer [utimer $tgtempnohint tgbindhintcmd]
                        }
                }
        }
}

#skips the current question if one has been asked.
proc tgskip {nick host hand chan text} {
        global tghinttimer tgnextqtimer tgplaying tgchan tgcurrentanswer tgstreak
        global tgstreakmin tgtimenext tgrebindhinttimer
        global GOSIChannel GOSIRunning GOSIQCount GOSIQNumber GOSIQuestionFile GOSIAdNumber GOSIVersion KDebug CountAnswer CountNoAnswer
        if {[strlwr $tgchan]==[strlwr $chan]} {
                if {$tgplaying==1&&[utimerexists tghint]!=""} {
                        tggamemsg "[tgcolskip]Skipping to next question by [tgcolmisc2]$nick's[tgcolskip] request..."
                        if {$tgstreakmin>0&&[lindex [split $tgstreak ,] 1]>=$tgstreakmin&&[strlwr [lindex [split $tgstreak ,] 0]]==[strlwr $nick]} {
                                tgstreakend
                                set tgstreak 0
                        }
                        catch {unbind pubm -|- "$tgchan *" tgcheckanswer}
                        killutimer $tghinttimer
                        if {[utimerexists tgrebindhinttimer]!=""} {killtimer $tgrebindhinttimer}
                set GOSIQCount 0
                set GOSIAdNumber 0
                GOSI_ReadCFG
                set GOSIQCount [GOSI_ReadQuestionFile]
                set GOSIAskedFileLen [GOSI_ReadAskedFile]
                bind pubm - "*" GOSICheckGuess
                set GOSIRunning 1
                GOSIAskQuestion

                }
        }
}

#bot got kicked. nostop the game.
proc tgbotgotkicked {nick host hand chan targ text} {
        tgquietnostop
}

#bot got disconnected. nostop the game.
proc tgbotgotdisconnected {disconnect-server} {
        tgquietnostop
}

#nostops the game without telling the channel.
proc tgquietnostop {} {
        global tgplaying tgstreak tgchan tgcurrentanswer tghinttimer tgnextqtimer tgerrremindtimer
        global tgrebindhinttimer
        if {$tgplaying==1} {
                set tgstreak 0
                set tgplaying 0
                catch {unbind pubm -|- "$tgchan *" tgcheckanswer}
                if {[utimerexists tghint]!=""} {killutimer $tghinttimer}
                if {[utimerexists tgnextq]!=""} {killutimer $tgnextqtimer}
                if {[timerexists tgerrremind]!=""} {killtimer $tgerrremindtimer}
                if {[utimerexists tgrebindhinttimer]!=""} {killtimer $tgrebindhinttimer}
        }
}

#reads the question database.
proc tgreadqdb {} {
        global tgqdb tgquestionstotal tgquestionslist
        set tgquestionstotal 0
        set tgquestionslist ""
        set qfile [open $tgqdb r]
        set tgquestionslist [split [read -nonewline $qfile] "\n"]
        set tgquestionstotal [llength $tgquestionslist]
        close $qfile
}

#selects the next question.
proc tgnextq {} {
        global tgqdb tgcurrentquestion tgcurrentanswer tgquestionnumber
        global tgquestionstotal tghintnum tgchan tgquestionslist tgqdbsep tgqdbquestionfirst
        global tgcapsquestion tgcapsanswer
        tgreadqdb
        set tgcurrentquestion ""
        set tgcurrentanswer ""
        while {$tgcurrentquestion == ""} {
                set tgquestionnumber [rand [llength $tgquestionslist]]
                set tgquestionselected [lindex $tgquestionslist $tgquestionnumber]
                set tgcurrentquestion [lindex [split $tgquestionselected $tgqdbsep] [expr $tgqdbquestionfirst^1]]
                if {$tgcapsquestion==1} {
                        set tgcurrentquestion [strupr $tgcurrentquestion]
                }
                set tgcurrentanswer [string trim [lindex [split $tgquestionselected $tgqdbsep] $tgqdbquestionfirst]]
                if {$tgcapsanswer==1} {
                        set tgcurrentanswer [strupr $tgcurrentanswer]
                }
        }
        unset tghintnum
        tghint
        bind pubm -|- "$tgchan *" tgcheckanswer
        return
}

#shows timed hints.
proc tghint {} {
        global tgmaxhint tghintnum tgcurrentanswer tghinttimer tgchan
        global tgtimehint tghintchar tgquestionnumber tgquestionstotal
        global tgcurrentquestion tghintcharsused tgnextqtimer tgtimenext tgstreak tgstreakmin
        global tgnobodygotit tgtrythenextone tgmissed tgmaxmissed tgcmdstart tgshowanswer
        global tgtimestart tgtimeanswer tgalwaysshowq tgmaxhintcurrent tgtempnohint tgcapshint
        global GOSIChannel GOSIRunning GOSIQCount GOSIQNumber GOSIQuestionFile GOSIAdNumber GOSIVersion KDebug CountAnswer CountNoAnswer

        if {[catch {incr tghintnum}]!=0} {
                set tghintnum 0
                regsub -all -- "\[^A-Za-z0-9\]" $tgcurrentanswer "" _hintchars
                set tgmaxhintcurrent [expr [strlen $_hintchars]<=$tgmaxhint?[expr [strlen $_hintchars]-1]:$tgmaxhint]
                catch {tgunbindhintcmd}
                if {$tgmaxhintcurrent>0} {
                        set tgrebindhinttimer [utimer $tgtempnohint tgbindhintcmd]
                }
        }
        if {$tghintnum >= [expr $tgmaxhintcurrent+1]} {
                incr tgmissed
                set _msg ""
                append _msg "\0032[lindex $tgnobodygotit [rand [llength $tgnobodygotit]]]"
                if {$tgshowanswer==1} {
                        append _msg " The answer was \0036$tgcurrentanswer"
                }
                if {$tgmaxmissed>0&&$tgmissed>=$tgmaxmissed} {
                        append _msg " That's $tgmissed questions gone by unanswered! The game is now automatically disabled. To start the game again, type $tgcmdstart"
                        tgquietnostop
                } else {
                        append _msg " \0032[lindex $tgtrythenextone [rand [llength $tgtrythenextone]]]"
                }
                tggamemsg "[tgcolmiss]$_msg"
                if {$tgstreakmin>0&&[lindex [split $tgstreak ,] 1]>=$tgstreakmin} { tgstreakend }
                set tgstreak 0
                catch {unbind pubm -|- "$tgchan *" tgcheckanswer}
                if {$tgmaxmissed==0||$tgmissed<$tgmaxmissed} {
                set GOSIQCount 0
                set GOSIAdNumber 0
                GOSI_ReadCFG
                set GOSIQCount [GOSI_ReadQuestionFile]
                set GOSIAskedFileLen [GOSI_ReadAskedFile]
                bind pubm - "*" GOSICheckGuess
                set GOSIRunning 1
                GOSIAskQuestion
                }
                return
        } elseif {$tghintnum == 0} {
                set i 0
                set _hint {}
                set tghintcharsused {}
                foreach word [split $tgcurrentanswer] {
                        regsub -all -- "\[A-Za-z0-9\]" $word $tghintchar _current
                        lappend _hint $_current
                }
                if {$tgtimeanswer==1} {
                        set tgtimestart [clock clicks -milliseconds]
                }
        } elseif {$tghintnum == 1} {
                set i 0
                set _hint {}
                while {$i<[llength [split $tgcurrentanswer]]} {
                        set _word [lindex [split $tgcurrentanswer] $i]
                        set j 0
                        set _newword {}
                        while {$j<[strlen $_word]} {
                                if {$j==0} {
                                        append _newword [stridx $_word $j]
                                        lappend tghintcharsused $i,$j
                                } else {
                                        if {[string is alnum [stridx $_word $j]]} {
                                                append _newword $tghintchar
                                        } else {
                                                append _newword [stridx $_word $j]
                                                lappend tghintcharsused $i,$j
                                        }
                                }
                                incr j
                        }
                        lappend _hint $_newword
                        incr i
                }
                } else {
                        set i 0
                        set _hint {}
                        while {$i<[llength [split $tgcurrentanswer]]} {
                                set _word [lindex [split $tgcurrentanswer] $i]
                                set j 0
                                set _newword {}
                                set _selected [rand [strlen $_word]]
                                regsub -all -- "\[^A-Za-z0-9\]" $_word "" _wordalnum
                                if {[strlen $_wordalnum]>=$tghintnum} {
                                        while {[lsearch $tghintcharsused $i,$_selected]!=-1||[string is alnum [stridx $_word $_selected]]==0} {
                                         set _selected [rand [strlen $_word]]
                                        }
                                }
                                lappend tghintcharsused $i,$_selected
                                while {$j<[strlen $_word]} {
                                        if {[lsearch $tghintcharsused $i,$j]!=-1||[string is alnum [stridx $_word $j]]==0} {
                                                append _newword [stridx $_word $j]
                                        } else {
                                                if {[string is alnum [stridx $_word $j]]} {
                                                        append _newword $tghintchar
                                                }
                                }
                                incr j
                        }
                        lappend _hint $_newword
                        incr i
                }
        }
        if {$tgcapshint==1} {
                set _hint [strupr $_hint]
        }
        if {$tgalwaysshowq==1||$tghintnum==0} {
        tggamemsg "\0030,2 :: Question no. $tgquestionnumber\/$tgquestionstotal \0038\[\00311 ®Trivia®\0038 \] \0030 :: \003"
        tggamemsg "\0032\037\002Word\002\037: $tgcurrentquestion\003"
        tggamemsg "\0032\037\002Hint\002\037: $_hint"
        tggamemsg "\0030,2 :: \00311+30 \0030Points Bila Anda Menjawab Dengan Benar :: \037-= GoodLuck =-\037 :: \003"
        }
        tggamemsg "\0032\037\002Hint\002\037: [join $_hint]\003"
        set tghinttimer [utimer $tgtimehint tghint]
}

#checks if anyone has said the correct answer on channel.
proc tgcheckanswer {nick host hand chan text} {
        global tgcurrentanswer
        if {[strlwr $tgcurrentanswer] == [tgstripcodes [strlwr [string trim $text]]]} {
                tgcorrectanswer $nick
        }
}

#triggered when someone says the correct answer.
proc tgcorrectanswer {nick} {
        global tgcurrentanswer tghinttimer tgtimenext tgchan tgnextqtimer tgstreak tgstreakmin
        global tgcongrats tgmissed
        global tgtimestart tgrealnames tgtimeanswer tgpointsperanswer
        global GOSIChannel GOSIRunning GOSIQCount GOSIQNumber GOSIQuestionFile GOSIAdNumber GOSIVersion KDebug CountAnswer CountNoAnswer
        global lastwinner lastwinnercount botnick userlist quizconf rankfile timerankreset

    variable bestscore 0 lastbestscore 0 lastbest ""
    variable userarray
    variable waitforrank 0 gameend 0

    mx_getcreate_userentry $nick $nick
    array set userarray $userlist($nick)

            set lastbest [lindex [lsort -command mx_sortrank [array names userlist]] 0]
            if {$lastbest == ""} {
                set lastbestscore 0
            } else {
                array set aa $userlist($lastbest)
                set lastbestscore $aa(score)
            }
            incr userarray(score) $tgpointsperanswer
            if {$userarray(score) == 1} {
                set userarray(started) [unixtime]
            }
            set userlist($nick) [array get userarray]

        set _timetoanswer ""
        if {$tgtimeanswer==1} {
                set _timetoanswer [expr [expr [clock clicks -milliseconds]-$tgtimestart]/1000.00]
        }
        set _msg "\0032[lindex $tgcongrats [rand [llength $tgcongrats]]] :\0036 $tgcurrentanswer \0032Oleh\0036 $nick \0032setelah\0036 $_timetoanswer \0032Detik - Score: \0036+30 \0032Points. Total Score:\0036 $userarray(score) \0032Points - Rank:\0036 [mx_get_rank_pos $nick]"
        tggamemsg "$_msg"
        pushmode $tgchan +v $nick
        if {$tgstreak!=0} {
                if {[lindex [split $tgstreak ,] 0]==[strlwr $nick]} {
                        set tgstreak [strlwr $nick],[expr [lindex [split $tgstreak ,] 1]+1]
                        if {$tgstreakmin>0&&[lindex [split $tgstreak ,] 1]>=$tgstreakmin} {
                                tggamemsg "[tgcolstrk][tgcolmisc2]$nick[tgcolstrk] is on a winning streak! [tgcolmisc2][lindex [split $tgstreak ,] 1] [tgcolstrk]in a row so far!"
                        }
                } else {
                        if {$tgstreakmin>0&&[lindex [split $tgstreak ,] 1]>=$tgstreakmin} { tgstreakend }
                        set tgstreak [strlwr $nick],1
                }
        } else {
                set tgstreak [strlwr $nick],1
        }
        set tgmissed 0
        catch {unbind pubm -|- "$tgchan *" tgcheckanswer}
        killutimer $tghinttimer
        tmcquiz_rank_save {} {} {}
        set GOSIQCount 0
        set GOSIAdNumber 0
        GOSI_ReadCFG
        set GOSIQCount [GOSI_ReadQuestionFile]
        set GOSIAskedFileLen [GOSI_ReadAskedFile]
        bind pubm - "*" GOSICheckGuess
        set GOSIRunning 1
        GOSIAskQuestion
}

#triggered when someone joins trivia chan.
proc tgjoinmsg {nick host hand chan} {
        global botnick tgplaying tgcmdhelp tgcmdstart tgflagsstart tgcmdnostop tgflagsnostop tgchan
        if {$nick != $botnick} {
                set _msg ""
                append _msg "Welcome to $botnick's event channel. Trivia game is currently"
                if {$tgplaying==1} {
                        append _msg " \002on\002."
                } else {
                        append _msg " \002off\002."
                }
                if {[matchattr $hand $tgflagsstart $tgchan]&&$tgplaying==0} {
                        append _msg " To start the game, type \002$tgcmdstart\002 on $tgchan."
                }
                append _msg " Please type \002/MSG $botnick [strupr $tgcmdhelp]\002 if you need help. Enjoy your stay! :-)"
                [tgpriv] $nick "$_msg"
        }
}

# Returns text without colour, bold, etc. control codes.
# This is a stripped down version of the proc in MC_8's mc.moretools.tcl.
proc tgstripcodes {text} {
        regsub -all -- "\003(\[0-9\]\[0-9\]?(,\[0-9\]\[0-9\]?)?)?" $text "" text
        set text "[string map -nocase [list \002 "" \017 "" \026 "" \037 ""] $text]"
        return $text
}

proc tggamemsg {what} {
        global tgchan
        putquick "PRIVMSG $tgchan :[tgbold]$what"
}

proc tgbold {} {
        global tgusebold
        if {$tgusebold==1} { return "\002" }
}
proc tgcolstart {} {
        global tgcolourstart
        if {$tgcolourstart!=""} { return "\003$tgcolourstart" }
}
proc tgcolnostop {} {
        global tgcolournostop
        if {$tgcolournostop!=""} { return "\003$tgcolournostop" }
}
proc tgcolskip {} {
        global tgcolourskip
        if {$tgcolourskip!=""} { return "\003$tgcolourskip" }
}
proc tgcolerr {} {
        global tgcolourerr
        if {$tgcolourerr!=""} { return "\003$tgcolourerr" }
}
proc tgcolmiss {} {
        global tgcolourmiss
        if {$tgcolourmiss!=""} { return "\003$tgcolourmiss" }
}
proc tgcolqhead {} {
        global tgcolourqhead
        if {$tgcolourqhead!=""} { return "\003$tgcolourqhead" }
}
proc tgcolqbody {} {
        global tgcolourqbody
        if {$tgcolourqbody!=""} { return "\003$tgcolourqbody" }
}
proc tgcolhint {} {
        global tgcolourhint
        if {$tgcolourhint!=""} { return "\003$tgcolourhint" }
}
proc tgcolstrk {} {
        global tgcolourstrk
        if {$tgcolourstrk!=""} { return "\003$tgcolourstrk" }
}
proc tgcolscr1 {} {
        global tgcolourscr1
        if {$tgcolourscr1!=""} { return "\003$tgcolourscr1" }
}
proc tgcolscr2 {} {
        global tgcolourscr2
        if {$tgcolourscr2!=""} { return "\003$tgcolourscr2" }
}
proc tgcolscr3 {} {
        global tgcolourscr3
        if {$tgcolourscr3!=""} { return "\003$tgcolourscr3" }
}
proc tgcolrset {} {
        global tgcolourrset
        if {$tgcolourrset!=""} { return "\003$tgcolourrset" }
}
proc tgcolstend {} {
        global tgcolourstend
        if {$tgcolourstend!=""} { return "\003$tgcolourstend" }
}
proc tgcolmisc1 {} {
        global tgcolourmisc1
        if {$tgcolourmisc1!=""} { return "\003$tgcolourmisc1" }
}
proc tgcolmisc2 {} {
        global tgcolourmisc2
        if {$tgcolourmisc2!=""} { return "\003$tgcolourmisc2" }
}
proc tgpriv {} {
        global tgpriv2msg
        if {$tgpriv2msg==1} { return "putmsg" } else { return "putnotc" }
}

putlog "Trivia ® Succesfully LoaDeD..."
