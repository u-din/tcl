variable quizbasedir        scripts/scramble
variable datadir            $quizbasedir/datascramble
variable configfile         $quizbasedir/quiz.rc

variable rankfile           $datadir/rank.dat
variable allstarsfile       $datadir/stars.dat
variable userqfile          $datadir/questions.user.en
variable commentsfile       $datadir/comments.txt
variable channeltipfile     $datadir/tips.txt
variable channelrulesfile   $datadir/rules.txt
variable pricesfile         $datadir/prices.txt
variable quizconf

set quizconf(quizchannel)        "#game"
set quizconf(quizloglevel)       1
 
# several global numbers
set quizconf(maxranklines)       5
set quizconf(tipcycle)           5
set quizconf(useractivetime)     180
set quizconf(userqbufferlength)  5

# timer delays in seconds
set quizconf(askdelay)           1
set quizconf(tipdelay)           30

# safety features and other configs
set quizconf(lastwinner_restriction)  no
set quizconf(lastwinner_max_games)    10
set quizconf(colorize)                no
set quizconf(monthly_allstars)        no
set quizconf(channeltips)             no
set quizconf(pausemoderated)          no
set quizconf(userquestions)           no
set quizconf(msgwhisper)              no
set quizconf(channelrules)            no
set quizconf(prices)                  no
set quizconf(stripumlauts)            no

variable quizstate "halted"
variable statepaused ""
variable statemoderated ""
variable usergame 0
variable timeasked [unixtime]
variable revoltmax 0
variable aftergame "newgame"
variable channeltips ""
variable channelrules ""
variable prices ""
variable timerankreset [unixtime]
variable userlist
variable allstarsarray
variable revoltlist ""
variable lastsolver ""
variable lastsolvercount 0
variable lastwinner ""
variable lastwinnercount 0
variable allstars_starttime 0
variable tiplist ""
variable theq
variable qnumber 0
variable qnum_thisgame 0
variable userqnumber 0
variable tipno 0
variable qlist ""
variable qlistorder ""
variable userqlist ""
variable whisperprefix "NOTICE"

##################################################
## bindings

# userquest and other user (public) commands
bind pubm - * tmcquiz_pubm
bind pub - !start tmcquiz_ask
bind pub - !stop tmcquiz_stops
bind pub m !exit tmcquiz_exit
bind msg - !newquest tmcquiz_userquest
bind msg - !usercancel tmcquiz_usercancel
bind msg - !usersolve tmcquiz_usersolve
bind pub - !qhelp tmcquiz_pub_help
bind pub - !score tmcquiz_pub_score
bind pub - !point tmcquiz_pub_rank
bind dcc n !scoreset tmcquiz_rank_set
bind pub - !load rank_save
bind join - * tmcquiz_on_joined
bind evnt - prerehash mx_event
bind evnt - rehash mx_event
bind dcc n !colors tmcquiz_colors

set quizshorthelp [list \
	"Most important commands are: !start, !point, !score and !stop" \
	"To learn more, specify a topic: !qhelp <topic>." \
	"Topics are: %s"]

## stop everything and kill all timers
proc tmcquiz_stop {handle idx arg} {
    global quizstate
    global quizconf
    variable t
    variable prefix 


    ## called directly?
    if {[info level] != 1} {
	set prefix
    } else {
	set prefix
    }

    set quizstate "stopped"
    foreach t [utimers] {
	if {[lindex $t 1] == "mx_timer_ask" || [lindex $t 1] == "mx_timer_tip"} {
	    killutimer [lindex $t 2]
	}
    }
    mxirc_say $quizconf(quizchannel) "Scramble Game stopped."
    return 1
}

proc tmcquiz_halt {handle idx arg} {
    global quizstate banner bannerspace
    global quizconf

    variable t
    variable prefix

    ## called directly?
    if {[info level] != 1} {
	set prefix [bannerspace]
    } else {
	set prefix
    }

    set quizstate "halted"
    
    ## kill timers
    foreach t [utimers] {
	if {[lindex $t 1] == "mx_timer_ask" || [lindex $t 1] == "mx_timer_tip"} {
	    killutimer [lindex $t 2]
	}
    }

    mxirc_say $quizconf(quizchannel) "S7©®ämbL7ë Berhenti. Ketik 12!start Untuk Memulai S7©®ämbL7ë Lagi."
    return 1
}


## reload questions
proc tmcquiz_reload {handle idx arg} {
    global qlist quizconf
    global datadir

    variable alist ""
    variable banks
    variable suffix

    set arg [string trim $arg]
    if {$arg == ""} {
	# get question files
	set alist [glob -nocomplain "$datadir/questions.*"]

	# get suffixes
	foreach file $alist {
	    regexp "^.*\\.(\[^\\.\]+)$" $file foo suffix
	    set banks($suffix) 1
	}

	# report them
	mxirc_dcc $idx "There are the following question banks available (current: $quizconf(questionset)): [lsort [array names banks]]"
    } else {
	if {[mx_read_questions $arg] != 0} {
	    mxirc_dcc $idx "There was an error reading files for $arg."
	    mxirc_dcc $idx "There are [llength $qlist] questions available."
	} else {
	    mxirc_dcc $idx "Reloaded database, [llength $qlist] questions."
	    set quizconf(questionset) $arg
	}
    }

    return 1
}



## exit -- finish da thing and logoff
proc tmcquiz_exit {nick host handle channel idx} {
    global rankfile uptime botnick
    global quizconf
    mx_log "--- EXIT requested."
    mxirc_say $quizconf(quizchannel) "I am leaving now."
    tmcquiz_rank_save $handle $idx {}
    tmcquiz_saveuserquests $handle $idx "all"
    tmcquiz_config_save $handle $idx {}
    mxirc_dcc $idx "$botnick now exits."
    mx_log "--- $botnick exited"
    mx_log "**********************************************************************"

    utimer 5 die
}

###########################################################################
#
# commands for the questions
#
###########################################################################

## something was said. Solution?
proc tmcquiz_pubm {nick host handle channel text} {
    global quizstate 
    global timeasked theq aftergame
    global usergame revoltlist
    global lastsolver lastsolvercount
    global lastwinner lastwinnercount
    global botnick
    global userlist channeltips prices
    global quizconf
    variable bestscore 0 lastbestscore 0 lastbest ""
    variable userarray
    variable authorsolved 0 waitforrank 0 gameend 0

#    ## only accept chatter on quizchannel
#    if {![mx_str_ieq $channel $quizconf(quizchannel)]} {
#	return
#    }

    ## record that the $nick spoke and create entries for unknown people
    mx_getcreate_userentry $nick $host
    array set userarray $userlist($nick)
    set hostmask $userarray(mask)

    ## not in asking state?
    if {$quizstate != "asked"} {
	return
    }

    # nick has revolted
    if {[lsearch -exact $revoltlist $hostmask] != -1} {
	return
    }

    # nick is author of userquest
    if {([info exists theq(Author)] && [mx_str_ieq $nick $theq(Author)])
    || ([info exists theq(Hostmask)] && [mx_str_ieq [maskhost $host] $theq(Hostmask)])} {
	set authorsolved 1
    }

    ## tweak german umlauts in input
    set text [mx_tweak_umlauts $text]

    if {[regexp -nocase -- $theq(Regexp) $text]} {
	## reset quiz state related stuff (and save userquestions)
	mx_answered
	set duration [mx_duration $timeasked]

	# if it wasn't the author
	if {!$authorsolved} {
	    ## save last top score for the test if reset is near (later below)
	    set lastbest [lindex [lsort -command mx_sortrank [array names userlist]] 0]
	    if {$lastbest == ""} {
		set lastbestscore 0
	    } else {
		array set aa $userlist($lastbest)
		set lastbestscore $aa(score)
	    }

	    ## record nick for bonus points
	    if {[mx_str_ieq [maskhost $host] $lastsolver]} {
		incr lastsolvercount
	    } else {
		set lastsolver [maskhost $host]
		set lastsolvercount 1
	    }

	    ## save score (set started time to time of first point)
	    incr userarray(score) $theq(Score)
	    if {$userarray(score) == 1} {
		set userarray(started) [unixtime]
	    }
	    set userlist($nick) [array get userarray]
	    regsub -all "\#(\[^\#\]*\)\#" $theq(Answer) "\\1" answer
	    mxirc_say $channel "12$answer ...betul..setelah12 $duration ... 12$nick +$theq(Score) pts. Total nilai:12 $userarray(score) points. Ranking:12 [mx_get_rank_pos $nick]"
	    if {$lastsolvercount == 3} {
		mxirc_say $channel "3Wow..Beruntung Kamu Dapat Bonus12 8 pts "
                pushmode $channel +v $nick
                tmcquiz_rank_set $botnick 0 "$nick +8"
	    } elseif {$lastsolvercount == 6} {
		mxirc_say $channel "3Anak siapa kamu! Hari ini dapat bonus12 14 pts "
		tmcquiz_rank_set $botnick 0 "$nick +14"
	    } elseif {$lastsolvercount == 10} {
		mxirc_say $channel "3Busseettttt! Mujur banget nasib mu, bonus12 22 pts "
		tmcquiz_rank_set $botnick 0 "$nick +22"
	    } elseif {$lastsolvercount == 15} {
		mxirc_say $channel "3Wah on holiday deh kamu!, dapat bonus12 30 pts "
		tmcquiz_rank_set $botnick 0 "$nick +30"
	    } elseif {$lastsolvercount == 20} {
		mxirc_say $channel "3Twenty in a row! This is really rare, so you receive12 40 pts "
		tmcquiz_rank_set $botnick 0 "$nick +40"

	    }

	  
	    set best [lindex [lsort -command mx_sortrank [array names userlist]] 0]
	    if {$best == ""} {
		set bestscore 0
	    } else {
		array set aa $userlist($best)
		set bestscore $aa(score)
	    }

	    set waitforrank 0
	    if {[mx_str_ieq $best $nick] && $bestscore > $lastbestscore} {
		array set aa $userlist($best)
		if {$bestscore >= $quizconf(winscore)} {
                    set price "."

                    if {$quizconf(prices) == "yes"} {
                        set price " [lindex $prices [rand [llength $prices]]]"
                    }

		    set now [unixtime]
		    if {[mx_str_ieq [maskhost $host] $lastwinner]} {
			incr lastwinnercount
			if {$lastwinnercount >= $quizconf(lastwinner_max_games)
			&& $quizconf(lastwinner_restriction) == "yes"} {
			}
		    } else {
			set lastwinner [maskhost $host]
			set lastwinnercount 1
		    }
		    mx_saveallstar $now [expr $now - $aa(started)] $bestscore $nick [maskhost $host]
		} elseif {$bestscore == [expr $quizconf(winscore) / 2]} {
		    mxirc_say $channel "Halftime.  Game is won at $quizconf(winscore) points."
		} elseif {$bestscore == [expr $quizconf(winscore) - 10]} {
		    mxirc_say $channel "$best has 10 points to go."
		} elseif {$bestscore == [expr $quizconf(winscore) - 5]} {
		    mxirc_say $channel "$best has 5 points to go."
		} elseif {$bestscore >= [expr $quizconf(winscore) - 3]} {
		    mxirc_say $channel "$best has [expr $quizconf(winscore) - $bestscore] point(s) to go."
		}

		# show rank at 1/3, 2/3 of and 5 before winscore
		set spitrank 1
		foreach third [list [expr $quizconf(winscore) / 3] [expr 2 * $quizconf(winscore) / 3] [expr $quizconf(winscore) - 5]] {
		    if {$lastbestscore < $third && $bestscore >= $third && $spitrank} {
			tmcquiz_rank $botnick 0 {}
			set spitrank 0
		    }
		}
	    }
	} else {
	    ## tell channel, that the question is solved by author
	    mx_log "--- solved after $duration by $nick with \"$text\" by author"
	    regsub -all "\#(\[^\#\]*\)\#" $theq(Answer) "\\1" answer
	    mxirc_say $channel "$nick skip pertanyaan , sorry kamu tidak dapat point.  Jawabannya: \002$answer\002"

	    # remove area of tip generation tags
	    regsub -all "\#(\[^\#\]*\)\#" $theq(Answer) "\\1" answer
#	    mxirc_say $channel "The answer was: $answer"
	}
	## check if game has ended and react
	if {!$gameend || $aftergame == "newgame"} {
	    # set up ask timer
	    utimer [expr $waitforrank + $quizconf(askdelay)] mx_timer_ask
	} else {
	    mx_aftergameaction
	}
    }
}

## ask a question, start game
proc tmcquiz_ask {nick host handle channel arg} {
    global qlist quizstate botnick
    global tipno tiplist
    global userqnumber usergame userqlist
    global timeasked qnumber qlistorder theq
    global qnum_thisgame
    global userlist timerankreset
    global quizconf
    variable anum 0
    variable txt

    ## only accept chatter on quizchannel
    if {![mx_str_ieq $channel $quizconf(quizchannel)]} {
	return
    }

    ## record that $nick spoke (prevents desert detection from stopping,
    ## when an user joins and starts the game with !ask)
    if {![mx_str_ieq $nick $botnick]} {
	mx_getcreate_userentry $nick $host
    }

    ## any questions available?
    if {[llength $qlist] == 0 && [mx_userquests_available] == 0} {
	mxirc_say $channel "Sorry, my database is empty."
    } elseif {$quizstate == "asked"} {
	## game runs, tell user the question via msg
	set txt "Current"
	if {[info exists theq(Level)]} {
	    set txt "$txt level $theq(Level)"
	}
	if {$usergame == 1} {
	    set txt "$txt user"
	}
	set txt "$txt question no. $qnum_thisgame is \""
	if {[info exists theq(Category)]} { 
	    set txt "${txt}\($theq(Category)\) "
	}
	set txt "$txt$theq(Question)\" open for [mx_duration $timeasked]"
	if {$theq(Score) > 1} {
	    set txt "$txt, worth $theq(Score) points."
	} else {	
	    set txt "$txt."
	}
	mxirc_notc $nick $txt
    } elseif {$quizstate == "waittoask" && ![mx_str_ieq $nick $botnick]} {
	## no, user has to be patient
	mxirc_notc $nick "Please stand by, the next question comes in less than $quizconf(askdelay) seconds."
    } else {

	## ok, now lets see, which question to ask (normal or user)

	## clear old question
	foreach k [array names theq] {
	    unset theq($k)
	}

	if {[mx_userquests_available]} {
	    ## select a user question
	    array set theq [lindex $userqlist $userqnumber]
	    set usergame 1
	    incr userqnumber
	    mx_log "--- asking a user question: $theq(Question)"
	} else {
	    variable ok 0
	    while {!$ok} {
		## select a normal question

		if {$qnumber >= [llength $qlistorder]} {
		    set qnumber 0
		    set qlistorder [mx_mixedlist [llength $qlist]]
		}
		array set theq [lindex $qlist [lindex $qlistorder $qnumber]]
		set usergame 0

		# skip question if author is about to win
		if {[info exists theq(Author)] && [info exists userlist($theq(Author))]} {
		    array set auser $userlist($theq(Author))
		    if {$auser(score) >= [expr $quizconf(winscore) - 5]} {
			mx_log "--- skipping question number $qnumber ([lindex $qlistorder $qnumber]), author is about to win"
			## clear old question
			foreach k [array names theq] {
			    unset theq($k)
			}
		    } else {
			mx_log "--- asking question number $qnumber ([lindex $qlistorder $qnumber]): $theq(Question)"
			set ok 1
		    }
		} else {
		    mx_log "--- asking question number $qnumber ([lindex $qlistorder $qnumber]): $theq(Question)"
		    set ok 1
		}
		incr qnumber
	    }
	}
	incr qnum_thisgame
	if {$qnum_thisgame == 1} {
	    set timerankreset [unixtime]
	    mx_log "---- it's the no. $qnum_thisgame in this game, rank timer started."
	} else {
	    mx_log "---- it's the no. $qnum_thisgame in this game."
	}

    ## ok, set some minimal required fields like score, regexp and the tiplist.
	
	## set regexp to match
	if {![info exists theq(Regexp)]} {
	    ## mask all regexp special chars except "."
	    set aexp [mx_tweak_umlauts $theq(Answer)]
	    regsub -all "(\\+|\\?|\\*|\\^|\\$|\\(|\\)|\\\[|\\\]|\\||\\\\)" $aexp "\\\\\\1" aexp
	    # get #...# area tags for tipgeneration as regexp
	    regsub -all ".*\#(\[^\#\]*\)\#.*" $aexp "\\1" aexp
	    set theq(Regexp) $aexp 
	} else {
	    set theq(Regexp) [mx_tweak_umlauts $theq(Regexp)]
	}

	# protect embedded numbers
	if {[regexp "\[0-9\]+" $theq(Regexp)]} {
	    set newexp ""
	    set oldexp $theq(Regexp)
	    set theq(Oldexp) $oldexp

	    while {[regexp -indices "(\[0-9\]+)" $oldexp pair]} {
		set subexp [string range $oldexp [lindex $pair 0]  [lindex $pair 1]]
		set newexp "${newexp}[string range $oldexp -1 [expr [lindex $pair 0] - 1]]"
		if {[regexp -- $theq(Regexp) $subexp]} {
		    set newexp "${newexp}(^|\[^0-9\])${subexp}(\$|\[^0-9\])"
		} else {
		    set newexp "${newexp}${subexp}"
		}
		set oldexp "[string range $oldexp [expr [lindex $pair 1] + 1] [string length $oldexp]]"
	    }
	    set newexp "${newexp}${oldexp}"
	    set theq(Regexp) $newexp
	    mx_log "---- replaced regexp '$theq(Oldexp)' with '$newexp' to protect numbers."
	}

	## set score
	if {![info exists theq(Score)]} {
	    set theq(Score) 3
	}

	## initialize tiplist
	set anum 0
	set tiplist ""
	while {[info exists theq(Tip$anum)]} {
	    lappend tiplist $theq(Tip$anum)
	    incr anum
	}
	# No tips found?  construct standard list
	if {$anum == 0} {
	    set add "·"

	    # extract area of tip generation tags
	    if {![regsub -all ".*\#(\[^\#\]*\)\#.*" $theq(Answer) "\\1" answer]} {
		set answer $theq(Answer)
	    }

	    	if {[info exists theq(Tipcycle)]} {
		set limit $theq(Tipcycle)
	    } else {
		set limit $quizconf(tipcycle)
		## check if at least one word long enough
		set tmplist [lsort -command mx_cmp_length -decreasing [split $answer " "]]
		# not a big word
		if {[string length [lindex $tmplist 0]] < $quizconf(tipcycle)} {
		    set limit [string length [lindex $tmplist 0]]
		}
	    }
	    
	    for {set anum 0} {$anum < $limit} {incr anum} {
		set tiptext ""
		set letterno 0
		for {set i 0} {$i < [string length $answer]} {incr i} {
		    if {([expr [expr $letterno - $anum] % $quizconf(tipcycle)] == 0) || 
		    ([regexp "\[- \.,`'\"\]" [string range $answer $i $i] foo])} {
			set tiptext "$tiptext[string range $answer $i $i]"
			if {[regexp "\[- \.,`'\"\]" [string range $answer $i $i] foo]} {
			    set letterno -1
			}
		    } else {
			set tiptext "$tiptext$add"
		    }
		    incr letterno
		}
		lappend tiplist $tiptext
	    }
	}

	# Now construct the text to print
    #  set ans "word : $answer"
	set txt "null"
	if {[info exists theq(Level)]} {
	    set txt "$txt level $theq(Level)"
	}
	if {$usergame == 1} {
	    set txt "$txt user"
	}
	set txt "4* 12Pondoksex 12S©®ämbLë 4* 12Soal 12No.4 $qnum_thisgame"
	if {$theq(Score) > 1} {
	}
	if {[info exists theq(Author)]} {
	    set txt "$txt"
	} else {
	    set txt "$txt"
	}
	mxirc_say $channel $txt


	set txt ""
	if {[info exists theq(Category)]} {
	    set txt "$txt\($theq(Category)\) $theq(Question)"
	} else {
	    set txt "12Soal : 4< $txt$theq(Question) 4>"
	}
      set ans "12Acak : 4< [randomanswer $answer] 4>"
      set tipz "[get_InfoItem]"

 mxirc_say $channel $txt
 mxirc_say $channel $ans
 mxirc_say $channel $tipz

	set quizstate "asked"
	set tipno 0
	set timeasked [unixtime]
	## set up tip timer
	utimer $quizconf(tipdelay) mx_timer_tip
    }
}


## A user dislikes the question
proc tmcquiz_user_revolt {nick host handle channel text} {
    global revoltlist revoltmax tipno botnick quizstate
    global userlist
    global quizconf

    ## only accept revolts on the quizchannel
    if {![mx_str_ieq $channel $quizconf(quizchannel)]} {
	return
    }

    if {$quizstate == "asked"} {
	if {$tipno < 1} {
#	    mxirc_action $channel "does not react on revolts before at least one tip was given."
	    return
	}

	## ensure that the revolting user has an entry
	if {![info exists userlist($nick)]} {
	    mx_getcreate_userentry $nick $host
	}

	## calculate people needed to make a revolution (50% of active users)
	mx_log "--- a game runs, !revolt.  revoltmax = $revoltmax"
	if {$revoltmax == 0} {
	    set now [unixtime]
	    foreach u [array names userlist] {
		array set afoo $userlist($u)
		if {[expr $now - $afoo(lastspoken)] <= $quizconf(useractivetime)} {
		    incr revoltmax
		}
	    }
	    mx_log "---- active people are $revoltmax"
	    # one and two player shoud revolt "both"
	    if {$revoltmax > 2} {
		set revoltmax [expr int(ceil(double($revoltmax) / 2))]
	    }
	    mx_log "---- people needed for a successful revolution: $revoltmax"
	}

	# records known users dislike
	if {[info exists userlist($nick)]} {
	    array set anarray $userlist($nick)
	    set hostmask $anarray(mask)
	    if {[lsearch -exact $revoltlist $hostmask] == -1} {
		mxirc_quick_notc $nick "Since you are revolting, you will be ignored for this question."
		lappend revoltlist $hostmask
		set anarray(lastspoken) [unixtime]
		set userlist($nick) [array get anarray]
		mx_log "--- $nick is revolting, revoltmax is $revoltmax"
	    }
	}
	if {[llength $revoltlist] >= $revoltmax} {
	    set revoltmax 0
	    mx_log "--- solution forced by revolting."
	    mxirc_action $channel "will solve the question immediately."
	    tmcquiz_solve $botnick 0 {}
	}
    }
}

## solve question
proc tmcquiz_solve {handle idx arg} {
    global quizstate theq
    global botnick lastsolvercount lastsolver timeasked
    global quizconf

    variable txt
    variable answer
    if {$quizstate != "asked"} {
	mxirc_dcc $idx "There is no open question."
    } else {
	mx_answered
	set lastsolver ""
	set lastsolvercount 0

	if {[mx_str_ieq $botnick $handle]} {
	    set txt "Time Out"
	    set solver ""
	} else {
	    set txt "Manually"
	    set solver " by $handle"
	}
        regsub -all "\#(\[^\#\]*\)\#" $theq(Answer) "\\1" answer
	set txt "3$txt, the answer is 12| 4$answer 12|"
	mxirc_say $quizconf(quizchannel) $txt

	# remove protection of numbers from regexp
	if {[info exists theq(Oldexp)]} {
	    set theexp $theq(Oldexp)
	} else {
	    set theexp $theq(Regexp)
	}

	if {$answer != $theexp} {
#	    mxirc_say $quizconf(quizchannel) "bisa juga jawabannya: $theexp"
	}

	mx_log "--- solved by $handle manually."
	# schedule ask
	utimer $quizconf(askdelay) mx_timer_ask
    } 
    return 1
}

## show a tip
proc tmcquiz_tip {handle idx arg} {
    global tipno quizstate
    global botnick tiplist
    global quizconf

    if {$quizstate == "asked"} {
	if {$arg != ""} {
	    mxirc_dcc $idx "Extra tip \'$arg\' will be given."
	    set tiplist [linsert $tiplist $tipno $arg]
	}
	if {$tipno == [llength $tiplist]} {
	    # enough tips, solve!
	    set tipno 0
	    tmcquiz_solve $botnick 0 {}
	} else {
	    set tiptext [lindex $tiplist $tipno]
	    foreach j [utimers] {
		if {[lindex $j 1] == "mx_timer_tip"} {
		    killutimer [lindex $j 2]
		}
	    }
	    mx_log "----- Tip number $tipno: $tiptext"
	    # only short delay after last tip
	    incr tipno
	    if {$tipno == [llength $tiplist]} {
		utimer 15 mx_timer_tip
	    } else {
		utimer $quizconf(tipdelay) mx_timer_tip
	    }
	}
    } else {
	mxirc_dcc $idx "Sorry, no question is open."
    }
    return 1
}

## schedule a userquest
proc tmcquiz_userquest {nick host handle arg} {
    global userqlist
    global quizconf
    variable uanswer "" uquestion "" umatch ""
    variable tmptext ""

    if {$quizconf(userquestions) == "no"} {
	mxirc_notc $nick "Sorry, userquestions are disabled."
	return
    }

    if {![onchan $nick $quizconf(quizchannel)]} {
	mxirc_notc $nick "Sorry, kamu harus join quizchannel dolo!"
    } else {
	if {[mx_userquests_available] >= $quizconf(userqbufferlength)} {
	    mxirc_notc $nick "Sorry, there are already $quizconf(userqbufferlength) user questions scheduled.  Try again later."
	} else {
	    set arg [mx_strip_colors $arg]
            if {$quizconf(stripumlauts) == "yes"} {
                set arg [mx_tweak_umlauts $arg]
            }
	    if {[regexp "^(.+)::(.+)::(.+)$" $arg foo uquestion uanswer umatch] || \
		    [regexp "(.+)::(.+)" $arg foo uquestion uanswer]} {
		set uquestion [string trim $uquestion]
		set uanswer [string trim $uanswer]
		set alist [concat "Question" "{$uquestion}" "Answer" "{$uanswer}" "Author" "{$nick}" "Hostmask" "[maskhost $host]" "Date" "[ctime [unixtime]]"]
		if {$umatch != ""} {
		    set umatch [string trim $umatch]
		    lappend alist "Regexp" "$umatch"
		    set mtext ", match \"$umatch\""
		}
		lappend userqlist $alist
		
		mxirc_notc $nick "Pertanyaan \"$uquestion\" dan Jawabannya \"$uanswer\"$tmptext"
		mx_log "--- Userquest scheduled by $nick: \"$uquestion\"."
	    } else {
		mxirc_notc $nick "Wrong number of parameters.  Use alike <question>::<answer>::<regexp>.  The regexp is optional and used with care." 
		mxirc_notc $nick "You said: \"$arg\".  I recognize this as: \"$uquestion\" and \"$uanswer\", regexp: \"$umatch\"."
		mx_log "--- userquest from $nick failed with: \"$arg\""
	    }
	}
    }
    return
}


## usertip
proc tmcquiz_usertip {nick host handle arg} {
    global quizstate usergame theq
    global quizconf
    
    if {[onchan $nick $quizconf(quizchannel)]} {
	mx_log "--- Usertip requested by $nick: \"$arg\"."
	if {$quizstate == "asked" && $usergame == 1} {
	    if {[info exists theq(Author)] && ![mx_str_ieq $nick $theq(Author)]} {
		mxirc_notc $nick "No, only $theq(Author) can give tips here!"
	    } else {
		tmcquiz_tip $nick 0 $arg
	    }
	} else {
	    mxirc_notc $nick "No usergame running."
	}
    } else {
	mxirc_notc $nick "Sorry, kamu harus join ke channel dolo"
    }
    return 1
}


## usersolve
proc tmcquiz_usersolve {nick host handle arg} {
    global quizstate usergame theq

    mx_log "--- Usersolve requested by $nick."
    if {$quizstate == "asked" && $usergame == 1} {
	if {[info exists theq(Author)] && ![mx_str_ieq $nick $theq(Author)]} {
	    mxirc_notc $nick "No, only $theq(Author) can solve this question!"
	} else {
	    tmcquiz_solve $nick 0 {}
	}
    } else {
	mxirc_notc $nick "Game Lagi Off"
    }
    return 1
}


## usercancel
proc tmcquiz_usercancel {nick host handle arg} {
    global quizstate usergame theq userqnumber userqlist
    mx_log "--- Usercancel requested by $nick."
    if {$quizstate == "asked" && $usergame == 1} {
	if {[info exists theq(Author)] && ![mx_str_ieq $nick $theq(Author)]} {
	    mxirc_notc $nick "No, only $theq(Author) can cancel this question!"
	} else {
	    mxirc_notc $nick "Pertanyaanmu dibatalkan"
	    set theq(Comment) "canceled by user"
	    tmcquiz_solve "user canceling" 0 {}
	}
    } elseif {[mx_userquests_available]} {
	array set aq [lindex $userqlist $userqnumber]
	if {[mx_str_ieq $aq(Author) $nick]} {
	    mxirc_notc $nick "Your question \"$aq(Question)\" will be skipped."
	    set aq(Comment) "canceled by user"
  	    set userqlist [lreplace $userqlist $userqnumber $userqnumber [array get aq]]
	    incr userqnumber
	} else {
	    mxirc_notc $nick "maaf pertanyaan selanjutnya oleh $aq(Author)."
	}
    } else {
	mxirc_notc $nick "Game Lagi Off"
    }
    return 1
}


## pubm help wrapper
proc tmcquiz_pub_help {nick host handle channel arg} {
    global quizconf

    if {![mx_str_ieq $channel $quizconf(quizchannel)]} {
	return 0
    } else {
	tmcquiz_help $nick $host $handle $arg
	return 1
    }
}


## pubm !score to report scores
proc tmcquiz_pub_score {nick host handle channel arg} {
    global allstarsarray userlist
    global quizconf

    variable allstarspos
    variable pos 0
    variable self_has "You have"
    variable self_is "You are"
    variable self "You"
    variable target

    set arg [string trim "$arg"]

    if {$arg != "" && $arg != $nick} {
	set self_has "$arg has"
	set self_is "$arg is"
	set self "$arg"
	set target $arg
    } else {
	set target $nick
    }


    if {![mx_str_ieq $channel $quizconf(quizchannel)]} {
	return 0
    } else {
	# report rank entries
	if {[info exists userlist($target)]} {
	    array set userarray $userlist($target)
	    if {$userarray(score)} {
		# calc position
		set pos [mx_get_rank_pos $target]
		mxirc_say $channel "4$nick $target 12$userarray(score) points and di posisi 12$pos pada session game sekarang!"
	    } else {
		mxirc_say $channel "4$nick Tidak punya score!"
	    }
	} else {
	    mxirc_say $channel "4$nick Tidak Terdaftar!!."
	}

	# report allstars entries
	if {[mx_get_allstars_pos $target]} {
	} else {
	}
	return 1
    }
}

## help
proc tmcquiz_help {nick host handle arg} {
    global botnick
    global quizconf quizhelp quizshorthelp
    global funstuff_enabled

    variable lines
    variable help
    variable topics [array names quizhelp]

    set arg [string tolower [string trim $arg]]

    
    # choose help text
    mx_log "--- help requested by $nick about '$arg'"

    # elide some help text based on configuration
    if {$quizconf(userquestions) == "no"} {
	set index [lsearch $topics "userquestions"]
	set topics [lreplace $topics $index $index]
    }
    
    if {![info exists funstuff_enabled] || $funstuff_enabled != 1} {
	set index [lsearch $topics "fun"]
	set topics [lreplace $topics $index $index]
    }
   
    # select help text
    if {$arg == ""} {
	set lines [format $quizshorthelp $topics]
    } else {
	if {[lsearch $topics $arg] != -1} {
	    set lines $quizhelp($arg)
	} else {
	    set lines [list "Can't help you about '$arg'.  Choose a topic from: $topics."]
	}
    }

    
    # dump help
    mxirc_notc $nick "\002Selamat datang di Menu Help" 
    foreach line $lines {
	mxirc_notc $nick $line
    }
    
    return 1
}

# skipuserquest  -- removes a scheduled userquest
proc tmcquiz_skipuserquest {handle idx arg} {
    global userqnumber userqlist
    if {[mx_userquests_available]} {
	mxirc_dcc $idx "Skipping the userquest [lindex $userqlist $userqnumber]"
	incr userqnumber
    } else {
	mxirc_dcc $idx "No usergame scheduled."
    }
    return 1
}

## saveuserquest  -- append all asked user questions to $userqfile
proc tmcquiz_saveuserquests {handle idx arg} {
    global userqfile userqlist userqnumber
    variable uptonum $userqnumber
    array set aq ""

    if {[llength $userqlist] == 0 || ($userqnumber == 0 && $arg == "")} {
	mxirc_dcc $idx "No user questions to save."
    } else {
	# save all questions?
	if {[string tolower [string trim $arg]] == "all"} {
	    set uptonum [llength $userqlist]
	}

	mx_log "--- Saving userquestions ..."
	if {[file exists $userqfile] && ![file writable $userqfile]} {
	    mxirc_dcc $idx "Cannot save user questions to \"$userqfile\"."
	    mx_log "--- Saving userquestions ... failed."
	} else {
	    set fd [open $userqfile a+]
	    ## assumes, that userqlist is correct!!
	    for {set anum 0} {$anum < $uptonum} {incr anum} {
		set q [lindex $userqlist $anum]
		# clear old values
		foreach val [array names aq] {
		    unset aq($val)
		}
		array set aq $q
		
		# write some first elements
		foreach n [list "Question" "Answer" "Regexp"] {
		    if {[info exists aq($n)]} {
			puts $fd "$n: $aq($n)"
			unset aq($n)
		    }
		}
		
		# spit the rest
		foreach n [lsort -dictionary [array names aq]] {
		    puts $fd "$n: $aq($n)"
		}
		puts $fd ""
	    }
	    close $fd

	    # prune saved and asked questions
	    for {set i 0} {$i < $userqnumber} {incr i} {
		set userqlist [lreplace $userqlist 0 0]
	    }

	    mxirc_dcc $idx "Saved $userqnumber user questions."
	    mx_log "--- Saving userquestions ... done"

	    ## reset userqnumber
	    set userqnumber 0
	}
    }
    return 1
}


## set score of open question
proc tmcquiz_set_score {handle idx arg} {
    ## [pending] obeye state!
    global quizstate theq banner
    global quizconf

    mx_log "--- set_score by $handle: $arg"
    if {![regexp {^[0-9]+$} $arg]} {
	mxirc_dcc $idx "$arg not a valid number."
    } elseif {$arg == $theq(Score)} {
	mxirc_dcc $idx "New score is same as old score."
    } else {
	mxirc_dcc $idx "Setting score for the question to $arg points ([format "%+d" [expr $arg - $theq(Score)]])."
	mxirc_say $quizconf(quizchannel) "Setting score for the question to $arg points ([format "%+d" [expr $arg - $theq(Score)]])."
	set theq(Score) $arg
    }
    return 1
}

# commands to manage the rankings

## read ranks from $rankfile
proc tmcquiz_rank_load {handle idx arg} {
    global rankfile userlist timerankreset
    global lastsolver lastsolvercount qnum_thisgame
    global quizconf
    variable timeranksaved [unixtime]
    variable fd
    variable line
    variable us 0 sc 0 mask ""

    ## clear old userlist (ranks)
    foreach u [array names userlist] {
	unset userlist($u)
    }

    ## load saved scores
    if {[file exists $rankfile] && [file readable $rankfile]} {
	set fd [open $rankfile r]
	while {![eof $fd]} {
	    set line [gets $fd]
	    if {![regexp "#.*" $line]} {
		switch -regexp $line {
		    "^winscore: .+ *$" {
			scan $line "winscore: %d" quizconf(winscore)
		    }
		    "^rankreset: +[0-9]+ *$" {
			scan $line "rankreset: %d" timerankreset
		    }
		    "^lastsolver:" {
			scan $line "lastsolver: %s = %d" lastsolver lastsolvercount
		    }
		    "^ranksave:" {
			scan $line "ranksave: %d" timeranksaved
		    }
		    "^qnumber:" {
			scan $line "qnumber: %d" qnum_thisgame
		    }
		    default {
			scan $line "%d %d : %s at %s" started sc us mask
			set alist [list "mask" $mask "score" $sc "lastspoken" 0 "started" [expr $started + [unixtime] - $timeranksaved]]
			set userlist($us) $alist
		    }
		}
	    }
	}
	close $fd
	mxirc_dcc $idx "Ranks loaded ([llength [array names userlist]]), winscore = $quizconf(winscore), saved at unixtime $timeranksaved."
	mx_log "--- Ranks loaded ([llength [array names userlist]]), winscore = $quizconf(winscore), saved at unixtime $timeranksaved."
    } else {
	mxirc_dcc $idx "Could not read \"$rankfile\"."
	mx_log "---- could not read \"$rankfile\"."
    }
    return 1
}


## save ranks to $rankfile
proc tmcquiz_rank_save {handle idx arg} {
    global rankfile userlist
    global lastsolver lastsolvercount timerankreset
    global qnum_thisgame
    global quizconf
    variable fd

    ## save ranks
    if {[llength [array names userlist]] > 0} {
	set fd [open $rankfile w]
	puts $fd "# rankings from $quizconf(quizchannel) at [ctime [unixtime]]."
	puts $fd "winscore: $quizconf(winscore)"
	puts $fd "rankreset: $timerankreset"
	puts $fd "ranksave: [unixtime]"
	puts $fd "qnumber: $qnum_thisgame"
	if {$lastsolver != ""} {
	    puts $fd "lastsolver: $lastsolver = $lastsolvercount"
	}
	foreach u [lsort -command mx_sortrank [array names userlist]] {
	    array set aa $userlist($u)
	    puts $fd [format "%d %d : %s at %s" $aa(started) $aa(score) $u $aa(mask)]
	}
	close $fd
	mx_log "--- Ranks saved to \"$rankfile\"."
	mxirc_dcc $idx "Ranks saved to \"$rankfile\"."
    } else {
	mxirc_dcc $idx "Ranks are empty, nothing saved."
    }
    return 1
}


#### public command for save #####

proc rank_save {nick host handle channel arg} {
    global rankfile userlist
    global lastsolver lastsolvercount timerankreset
    global qnum_thisgame
    global quizconf 
    variable fd

    ## save ranks
    if {[llength [array names userlist]] > 0} {
	set fd [open $rankfile w]
	puts $fd "# rankings from $quizconf(quizchannel) at [ctime [unixtime]]."
	puts $fd "winscore: $quizconf(winscore)"
	puts $fd "rankreset: $timerankreset"
	puts $fd "ranksave: [unixtime]"
	puts $fd "qnumber: $qnum_thisgame"
	if {$lastsolver != ""} {
	    puts $fd "lastsolver: $lastsolver = $lastsolvercount"
	}
	foreach u [lsort -command mx_sortrank [array names userlist]] {
	    array set aa $userlist($u)
	    puts $fd [format "%d %d : %s at %s" $aa(started) $aa(score) $u $aa(mask)]
	}
	close $fd
	
	putserv "PRIVMSG $quizconf(quizchannel) :7Score Kamu telah Di save $nick"
    } else {
	putserv "PRIVMSG $quizconf(quizchannel) :7Score Kosong - Tidak ada yang di save"
    }
    return 1
}


## set score of a player
proc tmcquiz_rank_set {handle idx arg} {
    global userlist botnick
    global quizconf
    variable list
    variable user "" newscore 0 oldscore 0
#    variable prefix

    mx_log "--- rankset requested by $handle: $arg"

    set list [split $arg]
    for {set i 0} {$i < [llength $list]} {incr i 2} {
	set user [lindex $list $i]
	set newscore [lindex $list [expr 1 + $i]]
	if {($newscore == "") || ($user == "")} {
	    mxirc_dcc $idx "Wrong number of parameters.  Cannot set \"$user\" to \"$newscore\"."
	} elseif {[regexp {^[\+\-]?[0-9]+$} $newscore] == 0} {
	    mxirc_dcc $idx "$newscore is not a number.  Ignoring set for $user."
	} else {
	    if {![info exists userlist($user)]} {
		if {[onchan $user $quizconf(quizchannel)]} {
		    mx_getcreate_userentry $user [getchanhost $user $quizconf(quizchannel)]
		} else {
		    mxirc_dcc $idx "Could not set rank for $user.  Not in list nor in quizchannel."
		    continue
		}
	    }
	    array set aa $userlist($user)
	    set oldscore $aa(score)
	    if {[regexp {^[\+\-][0-9]+$} $newscore]} {
		set newscore [expr $oldscore + $newscore]
		if {$newscore < 0} {
		    mxirc_dcc $idx "Kamu menjadikan score $user ke $newscore.  akan di bulatkan ke 0."
		    set newscore 0
		}
	    }
	    set aa(score) $newscore
	    set userlist($user) [array get aa]
	    ## did we change something?
	    if {[expr $newscore - $oldscore] != 0} {
		set txt "12$user 3dapat extra score4 [format "%+d" [expr $newscore - $oldscore]] 3...hebat..Score sekarang:4 $newscore 3points dan berada di ranking4 [mx_get_rank_pos $user]."
		if {![mx_str_ieq $handle $botnick] && [hand2nick $handle] != ""} {
		    set txt "$txt Set By [hand2nick $handle]."
		}
		mxirc_say $quizconf(quizchannel) $txt
	    }
	} 
    }
    return 1
}


## delete a player from rank
proc tmcquiz_rank_delete {handle idx arg} {
    global userlist

    mx_log "--- rank delete requested by $handle: $arg"

    if {$arg == ""} {
	mxirc_dcc $idx "Tell me whom to delete."
    } else {
	foreach u [split $arg " "] {
	    if {[info exists userlist($u)]} {
		array set aa $userlist($u)
		mxirc_dcc $idx "Nick $u removed from ranks.  Score was $aa(score) points."
		unset userlist($u)
	    } else {
		mxirc_dcc $idx "Nick $u not in ranks."
	    }
	}
    }
    return 1
}


## list ranks by notice to a user
proc tmcquiz_pub_rank {nick host handle channel arg} {
    set arg [string trim $arg]
    if {$arg == ""} {
	set arg 10
    } elseif {![regexp "^\[0-9\]+$" $arg]} {
	mxirc_notc $nick "Sorry, \"$arg\" is not an acccepted number."
	return
    }
    mx_spit_rank "NOTC" $channel $arg
}

## show rankings
proc tmcquiz_rank {handle idx arg} {
    global quizconf

    set arg [string trim $arg]
    if {$arg == ""} {
	set arg 5
    } elseif {![regexp "^\[0-9\]+$" $arg]} {
	mxirc_dcc $idx "Sorry, \"$arg\" is not an acccepted number."
    }
    mx_spit_rank "CHANNEL" $quizconf(quizchannel) $arg
}

## function to show the rank to a nick or channel
proc mx_spit_rank {how where length} {
    global timerankreset
    global userlist
    global quizconf
    variable pos 1
    variable prevscore 0
    variable entries 0
    variable lines ""

    # anybody with a point?
    foreach u [array names userlist] {
	array set aa $userlist($u)
	if {$aa(score) > 0} {
	    set entries 1
	    break
	}
    }

    # build list
    if {$entries == 0} {
	lappend lines "Highscore list is empty."
    } else {
	if {$length > $quizconf(maxranklines)} {
	    set length $quizconf(maxranklines)
#	    lappend lines "Your requested too many lines, limiting to
$quizconf(maxranklines)."
	}
	lappend lines "Highscore Current Top \002$length\002:"
	set pos 1
	set prevscore 0
	foreach u [lsort -command mx_sortrank [array names userlist]] {
	    array set aa $userlist($u)
	    if {$aa(score) == 0} { break }
	    if {$pos > $length && $aa(score) != $prevscore} { break }

	    if {$aa(score) == $prevscore} {
		set text "= " 
	    } else {
		set text [format "12,15%2d " $pos]
	    }
	    set text [format "12,15$text %12s :: %5d pts." $u $aa(score)]
	    if {$pos == 1} {
		set text "12,15$text"
	    }
	    lappend lines $text
	    set prevscore $aa(score)
	    incr pos
	}
	lappend lines "Rank started [mx_duration $timerankreset] ago."
    }

    # spit lines
    foreach line $lines {
	if {$how == "NOTC"} {
	    mxirc_say $where $line
#	    mxirc_notc $where $line

	} else {
	    mxirc_say $where $line
	}
    }

    return 1
}


# reset rankings
proc tmcquiz_rank_reset {handle idx arg} {
    global timerankreset userlist lastsolver lastsolvercount
    global quizconf qnum_thisgame aftergame

    ## called directly?
    if {[info level] != 1} {
	set prefix 
    } else {
	set prefix 
    }

    # forget last solver
    set lastsolver ""
    set lastsolvercount 0

    # clear userlist
    foreach u [array names userlist] {
	unset userlist($u)
    }
    set timerankreset [unixtime]
    mxirc_say $quizconf(quizchannel) "$prefix [botcolor boldtxt]Ranks reseted by $handle after $qnum_thisgame questions."
    mxirc_dcc $idx "Ranks are resetted.  Note that the value of aftergame was neither considered nor changed."
    set qnum_thisgame 0
    mx_log "--- Ranks reseted by $handle at [unixtime]."
    return 1
}


## calculate position of nick in the rank table
proc mx_get_rank_pos {nick} {
    global userlist
    variable pos 0
    variable prevscore 0

    if {[llength [array names userlist]] == 0 || \
	![info exists userlist($nick)]} {
	return 0
    }

    # calc position
    foreach name [lsort -command mx_sortrank [array names userlist]] {
	array set afoo $userlist($name)
	if {$afoo(score) != $prevscore} {
	    incr pos
	}

	set prevscore $afoo(score)
	if {[mx_str_ieq $name $nick]} {
	    break
	}
    }
    return $pos
}


## sort routine for the rankings
proc mx_sortrank {a b} {

    global userlist
    array set aa $userlist($a)
    array set bb $userlist($b)
    if {$aa(score) == $bb(score)} {
	return 0
    } elseif {$aa(score) > $bb(score)} {
	return -1
    } else {
	return 1
    }
}


# Commands to handle the allstars list


## load allstars list
proc tmcquiz_allstars_load {handle idx arg} {

    global allstarsarray allstarsfile allstars_starttime
    global quizconf

    variable thismonth 0

    mx_log "--- reading allstars list from $allstarsfile"

    if {$quizconf(monthly_allstars) == "yes"} {
	set thismonth [clock scan [clock format [unixtime] -format "%m/01/%Y"]]
    }

    if {[file exists $allstarsfile] && [file readable $allstarsfile]} {
	# clear old list
	foreach name [array names allstarsarray] {
	    unset allstarsarray($name)
	}
	set allstars_starttime -1

	## read datafile
	set fd [open $allstarsfile r]
	while {![eof $fd]} {
	    set line [gets $fd]
	    if {![regexp "#.*" $line]} {
		if {[scan $line "%d %d : %d %d --  %s %s " time duration sctotal sc us usermask] == 6} {
		    if {$time >= $thismonth} {
			if {$allstars_starttime == -1} {
			    set allstars_starttime $time
			}
			if {[info exists allstarsarray($us)]} {
			    set entry $allstarsarray($us)
			    set allstarsarray($us) [list \
				    [expr [lindex $entry 0] + 1] \
				    [expr [lindex $entry 1] + [mx_allstarpoints $sctotal $sc $duration]] \
				    ]
			} else {
			    set allstarsarray($us) [list \
				    1 \
				    [mx_allstarpoints $sctotal $sc $duration] \
				    ]
			}
		    }
		} else {
		    mx_log "---- allstar line not recognized: \"$line\"."
		}
	    }
	}
	close $fd
	mx_log "---- allstars list successfully read ([llength [array names allstarsarray]] users)."
	mxirc_dcc $idx "Allstars list successfully read ([llength [array names allstarsarray]] users)."
    } else {
	mx_log  "---- could not read \"$allstarsfile\", allstars list set empty."
	mxirc_dcc $idx  "Could not read \"$allstarsfile\", allstars list set empty."
	array set allstarsarray {}
    }
    return 1
}


## list allstars by notice to a user
proc tmcquiz_pub_allstars {nick host handle channel arg} {
    set arg [string trim $arg]
    if {$arg == ""} {
	set arg 10
    } elseif {![regexp "^\[0-9\]+$" $arg]} {
	mxirc_notc $nick "Sorry, \"$arg\" is not an acccepted number."
    }
    mx_spit_allstars "NOTC" $nick $arg
}

## show allstars
proc tmcquiz_allstars {handle idx arg} {
    global quizconf

    set arg [string trim $arg]
    if {$arg == ""} {
	set arg 5
    } elseif {![regexp "^\[0-9\]+$" $arg]} {
	mxirc_dcc $idx "Sorry, \"$arg\" is not an acccepted number."
	return
    }
    mx_spit_allstars "CHANNEL" $quizconf(quizchannel) $arg
}

## show all-star rankings
proc mx_spit_allstars {how where length} {
    global allstarsarray allstars_starttime
    global quizconf
    variable score
    variable games
    variable numofgames 0
    variable lines ""

    if {[llength [array names allstarsarray]] == 0} {
	lappend lines "Allstars list is empty."
    } else {
	# limit num of lines
	if {$length > $quizconf(maxranklines)} {
	    set length $quizconf(maxranklines)
	    lappend lines "Your requested too many lines, limiting to $quizconf(maxranklines)."
	}

	# build table
	set aline "[banner] [botcolor highscore]"
	if {$quizconf(monthly_allstars) == "yes"} {
	    set aline "$aline[clock format $allstars_starttime -format %B] "
	}
	set aline "$aline[]All-Stars top $length:"
	lappend lines $aline
	set pos 1
	set prevscore 0
	foreach u [lsort -command mx_sortallstars [array names allstarsarray]] {
	    set entry $allstarsarray($u)
	    set games [lindex $entry 0]
	    set score [lindex $entry 1]
	    incr numofgames $games

	    if {$pos > $length && $score != $prevscore} { continue }
	    if {$score == $prevscore} {
		set text " = " 
	    } else {
		set text [format "%2d " $pos]
	    }
	    set text [format "$text %18s  -- %5.3f pts, %2d games." $u $score $games]
	    if {$pos == 1} {
		set text "$text * Congrats! *"
	    }
	    lappend lines $text
	    set prevscore $score
	    incr pos
	}
	lappend lines "[botcolor boldtxt]There were [llength [array names allstarsarray]] users playing $numofgames games."
    }

    # spit table
    foreach line $lines {
	if {$how == "NOTC"} {
	    mxirc_notc $where $line
	} else {
	    mxirc_say $where $line
	}
    }

    return 1
}


proc mx_saveallstar {time duration score name mask} {
    global allstarsfile userlist allstarsarray allstars_starttime
    global quizconf botnick
    variable scoretotal 0
    
    # compute sum of scores in this game
    foreach u [array names userlist] {
	array set afoo $userlist($u)
	incr scoretotal $afoo(score)
    }
    
    if {$scoretotal == $score} {
#	mxirc_action $quizconf(quizchannel) "does not record you in the allstars table, since you played alone."
	mx_log "--- $name was not saved to allstars since he/she was playing alone."
    } else {
	# save entry
	set fd [open $allstarsfile a]
	puts $fd "$time $duration : $scoretotal $score -- $name $mask"
	close $fd
	if {[info exists allstarsarray($name)]} {
	    set entry $allstarsarray($name)
	    set allstarsarray($name) [list \
		    [expr [lindex $entry 0] + 1] \
		    [expr [lindex $entry 1] + [mx_allstarpoints $scoretotal $score $duration]] \
		    ]
	} else {
	    set allstarsarray($name) [list \
		    1 \
		    [mx_allstarpoints $scoretotal $score $duration] \
		    ]
	}

	# reload allstars table if a new month began
	if {$quizconf(monthly_allstars) == "yes" &&
	$allstars_starttime < [clock scan [clock format [unixtime] -format "%m/01/%Y"]]} {
	    mx_log "--- new month, reloading allstars table"
	    tmcquiz_allstars_load $botnick 0 {}
	}
	mx_log "--- saved $name with [mx_allstarpoints $scoretotal $score $duration] points (now [format "%5.3f" [lindex $allstarsarray($name) 1]] points, pos [mx_get_allstars_pos $name]) to the allstars file. Time: $time"
    }
}


## compute position of $nick in allstarsarray
proc mx_get_allstars_pos {nick} {
    global allstarsarray
    variable pos 0
    variable prevscore 0

    if {[llength [array names allstarsarray]] == 0 || \
	![info exists allstarsarray($nick)]} {
	return 0
    }

    # calc position
    foreach name [lsort -command mx_sortallstars [array names allstarsarray]] {
	if {[lindex $allstarsarray($name) 1] != $prevscore} {
	    incr pos
	}

	set prevscore [lindex $allstarsarray($name) 1]
	if {[mx_str_ieq $name $nick]} {
	    break
	}
    }
    return $pos
}


## calculate entry in allstar table
proc mx_allstarpoints {sum score duration} {
    if {$sum == $score} {
	return 0
    } else {
	return [expr (10 * double($sum)) / (log10($score) * $duration)]
    }
}


## sort routine for the allstars
proc mx_sortallstars {a b} {
    global allstarsarray
    variable sca [lindex $allstarsarray($a) 1]
    variable scb [lindex $allstarsarray($b) 1]

    if {$sca == $scb} {
	return 0
    } elseif {$sca > $scb} {
	return -1
    } else {
	return 1
    }
}


###########################################################################
#
# User comment handling
#
###########################################################################

## record a comment
proc tmcquiz_pub_comment {nick host handle channel arg} {
    global commentsfile

    set arg [string trim $arg]
    if {$arg != ""} {
	set fd [open $commentsfile a]
	puts $fd "\[[ctime [unixtime]]\] $nick on $channel comments: $arg"
	close $fd

	mxirc_notc $nick "Your comment was logged."
    } else {
	mxirc_notc $nick "Well, comment something *g*"
    }
}

## record a comment
proc tmcquiz_dcc_comment {handle idx arg} {
    global commentsfile

    set arg [string trim $arg]
    if {$arg != ""} {
	set fd [open $commentsfile a]
	puts $fd "\[[ctime [unixtime]]\] $handle comments: $arg"
	close $fd

	mxirc_dcc $idx "Your comment was logged."
    } else {
	mxirc_dcc $idx "Well, comment something *g*"
    }
}

# Configuration file reading and writing, setup

# public interface to set the configuration variables from the config file
proc tmcquiz_config_set {handle idx arg} {
    global quizconf
    variable key
    variable value
    variable success 0

    # collapse whitespace
    regsub -all " +" $arg " " arg

    # extract key and value
    set list [split $arg]
    for {set i 0} {$i < [llength $list]} {incr i 2} {
	set key [string tolower [lindex $list $i]]
	set value [lindex $list [expr 1 + $i]]

	# first lets see if the key exists
	set keylist [array names quizconf "*$key*"]
	if {[llength $keylist] == 1} { set key [lindex $keylist 0] }

	if {[info exists quizconf($key)]} {
	    if {$value == ""} {
		mxirc_dcc $idx "$key = $quizconf($key)"
	    } else {
		mx_log "--- config tried $key = $value"
		set success 0
		set oldvalue $quizconf($key)
		switch -regexp $oldvalue {
		    "^(yes|no)" {
			if {[regexp "^(yes|no)$" $value]} {
			    set quizconf($key) $value
			    set success 1
			}
		    }
		    "^\[0-9\]+$" {
			if {[regexp "^\[0-9\]+$" $value]} {
			    set quizconf($key) $value
			    set success 1
			}
		    }
		    default {
			set quizconf($key) $value
			set success 1
		    }
		}
		
		if {$success == 1} {
		    mxirc_dcc $idx "Config $key successfully set to $value."
		    mx_log "-- config $key set to $value."
		    
		    # action on certain variables
		    mx_config_apply $key $oldvalue

		} else {
		    mxirc_dcc $idx "Config $key could not be set to '$value', wrong format."
		    mx_log "-- Config $key could not be set to '$value', wrong format."
		}
		set success 0
	    }
	} else {
	    # dump keys with substring
	    set keylist [array names quizconf "*$key*"]
	    if {[llength $keylist] == 0} {
		mxirc_dcc $idx "Sorry, no configuration matches '$key'"
	    } else {
		mxirc_dcc $idx "Matched configuration settings for '$key':"
		for {set j 0} {$j < [llength $keylist]} {incr j 1} {
		    mxirc_dcc $idx "[lindex $keylist $j] = $quizconf([lindex $keylist $j])"
		}
	    }
	}
    }
    # check if arg was empty and dump _all_ known keys then
    if {$arg == ""} {
	set keylist [array names quizconf]
	mxirc_dcc $idx "Listing all settings:"
	for {set j 0} {$j < [llength $keylist]} {incr j 1} {
	    mxirc_dcc $idx "[lindex $keylist $j] = $quizconf([lindex $keylist $j])"
	}
    }
    return 1
}


# public interface for readconfig
proc tmcquiz_config_load {handle idx arg} {
    global configfile
    mxirc_dcc $idx "Loaded [mx_config_read $configfile] configuration entries."
}


# public interface for readconfig
proc tmcquiz_config_save {handle idx arg} {
    global configfile
    mxirc_dcc $idx "Saved [mx_config_write $configfile] configuration entries."
}

# applies a configuration and makes neccessary setup
proc mx_config_apply {key oldvalue} {
    global whisperprefix quizconf channelrules botnick pricesfile
    variable value $quizconf($key)

    switch -exact $key {
	"winscore" {
	    if {$oldvalue != {}} {
	    }
	}
	"msgwhisper" {
	    if {$value == "yes"} {
		set whisperprefix "PRIVMSG"
	    } else {
		set whisperprefix "NOTICE"
	    }
	}
	"channelrules" {
	    if {$value == "yes"} {
		bind msg - !rules tmcquiz_rules
		bind pub - !rules tmcquiz_pub_rules
		tmcquiz_rules_read $botnick 0 {}
	    } else {
		unbind msg - !rules tmcquiz_rules
		unbind pub - !rules tmcquiz_pub_rules
	    }
	}
        "prices" {
            if {$value == "yes"} {
                mx_read_prices $pricesfile
            }
        }
    }
}

# reads configuration from cfile into global variable quizconf
proc mx_config_read {cfile} {
    global quizconf

    variable num 0

    mx_log "--- Loading configuration from $cfile ..."

    set fd [open $cfile r]
    while {![eof $fd]} {
	gets $fd line
	if {![regexp "^ *#.*$" $line] && ![regexp "^ *$" $line]} {
	    set content [split $line {=}]
	    set key [string trim [lindex $content 0]]
	    set value [string trim [lindex $content 1]]
	    set quizconf($key) $value
	    incr num
	}
    }
    close $fd

    mx_log "--- Configuration loaded: $num settings."

    foreach $key [array names quizconf] {
	mx_config_apply $key {}
    }

    return $num
}


# writes configuration from global quizconf to cfile
proc mx_config_write {cfile} {
    global quizconf

    variable num 0
    variable written ""

    mx_log "--- Saving configuration to $cfile ..."


    set fdin [open $cfile r]
    set fdout [open "$cfile.tmp" w]

    # replace known configs
    while {![eof $fdin]} {
	gets $fdin line
	switch -regexp $line {
	    "(^ *$|^ *#.*$)" {
		puts $fdout $line
	    }
	    "^(.*)=(.*)$" {
		set content [split $line {=}]
		set key [string trim [lindex $content 0]]
		set value [string trim [lindex $content 1]]
		if {[info exists quizconf([string trim $key])]} {
		    puts $fdout "$key = $quizconf([string trim $key])"
		    incr num
		} else {
		    puts $fdout $line
		}
		lappend written [string trim $key]
	    }
	}
    }

    # append "new" configs not mentioned in the file
    puts $fdout "###########################################################################"
    puts $fdout "#"
    puts $fdout "# New Configuration values."
    puts $fdout "#"

    set keys [array names quizconf]
    for {set i 0} {$i < [llength $keys]} {incr i} {
	set key [lindex $keys $i]
	if {[lsearch -exact $written $key] == -1} {
	    puts $fdout "$key = $quizconf($key)"
	}
    }

    close $fdin
    close $fdout

    # delete old config
    file rename -force "$cfile.tmp" $cfile

    mx_log "--- Configuration saved: $num settings."
    return $num
}

###########################################################################
#
# Handling of certain events, like +m, nickchanges and others
#
###########################################################################

# notification when a user joins in
proc tmcquiz_on_joined {nick host handle channel} {
    global qlist version_tmcquizz userlist
    global quizconf quizstate qnum_thisgame
    
    variable text

    if {![mx_str_ieq $channel $quizconf(quizchannel)]} {
	return
    }
    
    set text "\[\002$nick\002\] Welcome to $channel - Type \002!start\002 to get the current question."

    if {$quizconf(channelrules) == "yes"} {
	set text "$text"
    }

    mxirc_notc $nick $text
    if {[info exists userlist($nick)]} {
	array set aa $userlist($nick)
	if {$aa(mask) == [maskhost $host]} {
	    if {$aa(score) > 0} {
		mxirc_notc $nick "You are listed with \002$aa(score)\002 points on rank \002[mx_get_rank_pos $nick]\002."
	    }
	 
	}
    }

   }


## internal routines
proc mx_event {type} {
    global botnick quizstate 
    switch -exact $type {
	"prerehash" {
	    mx_log "--- Preparing for rehashing"
	    if {$quizstate != "halted"} {
		tmcquiz_halt $botnick 0 {}
	    }
	    tmcquiz_rank_save $botnick 0 {}
	    tmcquiz_saveuserquests $botnick 0 "all"
	    tmcquiz_config_save $botnick 0 {}
	    set tmp_logfiles [logfile]
	    mx_log "---- will reopen logfiles: $tmp_logfiles"
	    mx_log "--- Ready for rehashing"
	}
	"rehash" {
	    # reopen logfiles
	    mx_log "--- rehash: reloading ranks"
	    tmcquiz_rank_load $botnick 0 {}
	    mx_log "--- rehash: done."
	}
    }
}

## ----------------------------------------------------------------------
## mxirc ... stuff to speak
## ----------------------------------------------------------------------

## say something on quizchannel
proc mxirc_say {channel text} {
    putserv "PRIVMSG $channel :$text"
}

## say something on all channels
proc mxirc_say_everywhere {text} {
    foreach channel [channels] {
	if {[validchan $channel] && [botonchan $channel]} {
	    mxirc_say $channel $text
	}
    }
}

## act on all channels
proc mxirc_action_everywhere {text} {
    foreach channel [channels] {
	if {[validchan $channel] && [botonchan $channel]} {
	    mxirc_action $channel $text
	}
    }
}

## say something through another buffer
proc mxirc_quick {channel text} {
    putquick "PRIVMSG $channel :$text"
}

## act in some way (/me)
proc mxirc_action {channel text} {
    putserv "PRIVMSG $channel :\001ACTION $text\001"
}


## say something to a user
proc mxirc_msg {nick text} {
    global botnick
    if {![mx_str_ieq $botnick $nick]} {
	puthelp "PRIVMSG $nick :$text"
    }
}

## say something through another buffer
proc mxirc_quick_notc {nick text} {
    global botnick whisperprefix
    if {![mx_str_ieq $botnick $nick]} {
	putquick "$whisperprefix $nick :$text"
    }
}


## notice something to a user (whisper)
proc mxirc_notc {nick text} {
    global botnick whisperprefix
    if {![mx_str_ieq $botnick $nick]} {
	puthelp "$whisperprefix $nick :$text"
    }
}

## notice something to a user
proc mxirc_dcc {idx text} {
    if {[valididx $idx]} {
	putdcc $idx $text 
    }
}

## func to act according to the value of $aftergame
proc mx_aftergameaction {} {
    global botnick aftergame quizconf

    switch -exact $aftergame {
	"stop" {
	    tmcquiz_stop $botnick 0 {}
	    set aftergame "newgame"
	}
	"halt" {
	    tmcquiz_halt $botnick 0 {}
	    set aftergame "newgame"
	}
	"exit" {
	    # sleep some milliseconds
	    tmcquiz_stop $botnick 0 {}
	    mxirc_say $quizconf(quizchannel) "Thanks for playing ppl, I'll exit now (and thanks for all the fish)."
	    utimer 2 mx_timer_aftergame
	}
	"newgame" {
	    # do nothing special here
	}
	default {
	    mx_log "ERROR: Bad aftergame-value: \"$aftergame\" -- halted"
	    tmcquiz_halt $botnick 0 {}
	}
    }
}

proc mx_timer_aftergame {} {
    global botnick
    if {[queuesize] != 0} {
	utimer 2 mx_timer_aftergame
    } else {
	tmcquiz_exit $botnick 0 {}
    }

}

## func to log stuff
proc mx_log {text} {
    global quizconf
    putloglev $quizconf(quizloglevel) $quizconf(quizchannel) $text
}

## return a duration as a string
proc mx_duration {time} {
    return [duration [expr [unixtime] - $time]]
}

## return if strings are equal case ignored
proc mx_str_ieq {a b} {
    if {[string tolower $a] == [string tolower $b]} {
	return 1
    } else {
  	return 0
    }
}

## return a mixed list of numbers from 0 ... size
proc mx_mixedlist {size} {
    variable alist "" blist ""

    for {set i 0} {$i < $size} {incr i} {
	lappend alist "$i"
    }
    set blist ""
    for {set i 0} {$i < $size} {incr i} {
	
	set pos [rand [llength $alist]]
	lappend blist [lindex $alist $pos]
	set alist [lreplace $alist $pos $pos]

    }
    return $blist
}



## read question data
## RETURNS:  0 if no error
##           1 if no file found
proc mx_read_questions {questionset} {
    global qlist qlistorder qnumber datadir
    variable entry
    variable tipno 0
    variable key
    variable errno 0
    # 0=out 1=in
    variable readstate 0

    mx_log "--- Loading questions."


    # keep the old questions safe
    set tmplist $qlist
    set qlist ""

    foreach datafile [glob -nocomplain "$datadir/questions*$questionset"] {

	set fd [open $datafile r]
	while {![eof $fd]} {
	    set line [gets $fd]
	    # an empty line terminates an entry
	    if {[regexp "^ *$" $line]} {
		if {$readstate == 1} {
		    # reject crippled entries
		    if {[info exists entry(Question)] 
		    && [info exists entry(Answer)]} {
			lappend qlist [array get entry]
		    } else {
			mx_log "[array get entry] not complete."
		    }
		    set tipno 0
		    unset entry
		}
		set readstate 0
	    } elseif {![regexp "^#.*" $line]} {
		set readstate 1
		set data [split $line {:}]
		if {![regexp "(Answer|Author|Category|Comment|Level|Question|Regexp|Score|Tip|Tipcycle)" [lindex $data 0]]} {
		    mx_log "Key [lindex $data 0] unknown!"
		} else {
		    set key [string trim [lindex $data 0]]
		    if {$key == "Tip"} {
			set key "$key$tipno"
			incr tipno
		    }
		    set entry($key) [string trim [join [lrange $data 1 end] ":"]]
		}
	    }
	}
	close $fd

	mx_log "---- now [llength $qlist] questions, added $datafile"
    }

    if {[llength $qlist] == 0} {
	set qlist $tmplist
	mx_log "----- reset to prior questions ([llength $qlist] ones)."
	set errno 1
    }

    mx_log "--- Questions loaded."

    set qlistorder [mx_mixedlist [llength $qlist]]
    set qnumber 0
    return $errno
}


## sets back all variables when a question is solved
## and goes to state waittoask (no timer set !!)
proc mx_answered {} {
    global quizstate tipno usergame qlistfinished userqnumber
    global userqlist tiplist revoltlist revoltmax
    variable alist

    if {$quizstate == "asked"} {
	if {$usergame == 1} {
	    ## save usergame
	    set pos [expr $userqnumber - 1]
  	    set alist [lindex $userqlist $pos]
	    mx_log "---- userquest stored: $alist"
  	    set i 0
  	    foreach t $tiplist {
  		lappend alist "Tip$i" [lindex $tiplist $i]
  		incr i
  	    }
  	    set userqlist [lreplace $userqlist $pos $pos $alist]
	    ## [pending] save each question to disc
	}
	set quizstate "waittoask"
	set tipno 0
	set revoltlist ""
	set revoltmax 0

	foreach j [utimers] {
	    if {[lindex $j 1] == "mx_timer_tip"} {
		killutimer [lindex $j 2]
	    }
	}
    }
}


proc mx_timer_ask {} {
    global botnick quizconf
    tmcquiz_ask $botnick {} {} $quizconf(quizchannel) {}
}


## give a tip and check if channel is desert!
proc mx_timer_tip {} {
    global userlist botnick banner
    global aftergame timerankreset qnum_thisgame
    global quizconf

    variable desert 0

    foreach u [array names userlist] {
	array set afoo $userlist($u)
	if {$afoo(lastspoken) >= [expr [unixtime] - ($quizconf(tipcycle) * $quizconf(tipdelay) * 2) - $quizconf(askdelay)]} {
	    set desert 0
	    break
	}
    }

    # ask at least one question
    if {$desert && $qnum_thisgame > 2} {
	mxirc_say $quizconf(quizchannel) "Channel found desert."
        mx_log "--- Channel found desert."
	tmcquiz_rank_reset $botnick {} {}
	if {$aftergame != "exit"} {
	    tmcquiz_halt $botnick 0 {}
	} else {
	    mx_aftergameaction
	}
    } else {
	tmcquiz_tip $botnick 0 {}
    }
}


## compare length of two elements
proc mx_cmp_length {a b} {
    variable la [string length $a] lb [string length $b]
    if {$la == $lb} {
	return 0
    } elseif {$la > $lb} {
	return 1
    } else {
	return -1
    }
}

## returns number of open userquests
proc mx_userquests_available {} {
    global userqlist userqnumber

    set num [expr [llength $userqlist] - $userqnumber]

    if {$num < 0} {
	return 0
    } else {
	return $num
    }
}


## create an entry in the userlist or update an existing
## then entry is returned
proc mx_getcreate_userentry {nick host} {
    global userlist botnick

    ## prevent myself from being added, though this will never happen
    if {[mx_str_ieq $nick $botnick]} {
	return
    }

    if {[info exists userlist($nick)]} {
	array set anarray $userlist($nick)
	set anarray(lastspoken) [unixtime]
	set userlist($nick) [array get anarray]
    } else {
	set userlist($nick) [list "mask" [maskhost $host] "score" 0 "started" [unixtime] "lastspoken" [unixtime]]
	mx_log "---- new user $nick: $userlist($nick)"
	array set anarray $userlist($nick)
    }
}

## convert some latin1 special chars
proc mx_tweak_umlauts {text} {
    regsub -all "ä" $text "ae" text
    regsub -all "ö" $text "oe" text
    regsub -all "ü" $text "ue" text
    regsub -all "Ä" $text "AE" text
    regsub -all "Ö" $text "OE" text
    regsub -all "Ü" $text "UE" text
    regsub -all "ß" $text "ss" text
    regsub -all "è" $text "e" text
    regsub -all "È" $text "E" text
    regsub -all "é" $text "e" text
    regsub -all "É" $text "E" text
    return $text
}

# functions for colors
proc mx_strip_colors {txt} {
    variable result
    regsub -all "\[\002\017\]" $txt "" result
    regsub -all "\003\[0-9\]\[0-9\]?\(,\[0-9\]\[0-9\]?\)?" $result "" result
    return $result
}

# return botcolor
proc botcolor {thing} {
    global quizconf
    if {$quizconf(colorize) != "yes"} {return ""}
    if {$thing == "question"} {return "[color dblue white][col uline]"}
    if {$thing == "answer"} {return "[color dbluesky black]"}
    if {$thing == "tip"} {return "[color dblue white]"}
    if {$thing == "nick"} {return "[color dbluewhite black]"}
    if {$thing == "nickscore"} {return "[color lightgreen blue]"}
    if {$thing == "highscore"} {return "\003[col turqois][col uline][col bold]"}
    if {$thing == "txt"} {return "[color blue lightblue]"}
    if {$thing == "boldtxt"} {return "[col bold][color blue lightblue]"}
    if {$thing == "own"} {return "[color red black]"}
    if {$thing == "norm"} {return "\017"}
    if {$thing == "grats"} {return "[color purple norm]"}
    if {$thing == "score"} {return "[color blue lightblue]"}
    if {$thing == ""} {return "\003"}
}

# internal function, never used from ouside. (doesn't check colorize!)
proc color {fg bg} {
    return "\003[col $fg],[col $bg]"
}

# taken from eggdrop mailinglist archive
proc col {acolor} {
    global quizconf
    if {$quizconf(colorize) != "yes"} {return ""}

    if {$acolor == "norm"} {return "00"} 
    if {$acolor == "white"} {return "00"} 
    if {$acolor == "black"} {return "01"} 
    if {$acolor == "blue"} {return "02"} 
    if {$acolor == "green"} {return "03"} 
    if {$acolor == "red"} {return "04"} 
    if {$acolor == "brown"} {return "05"} 
    if {$acolor == "purple"} {return "06"} 
    if {$acolor == "orange"} {return "07"} 
    if {$acolor == "yellow"} {return "08"} 
    if {$acolor == "lightgreen"} {return "09"} 
    if {$acolor == "turqois"} {return "10"} 
    if {$acolor == "lightblue"} {return "11"} 
    if {$acolor == "dblue"} {return "12"} 
    if {$acolor == "pink"} {return "13"} 
    if {$acolor == "grey"} {return "14"} 
    if {$acolor == "blusky"} {return "11,1"}


    if {$acolor == "bold"} {return "\002"} 
    if {$acolor == "uline"} {return "\037"} 
#    if {$color == "reverse"} {return "\022"} 
}

## Banner:

proc banner {} {
    return "Scramble Game"
}

# should return as much spaces as the banner needs (for best results)
proc bannerspace {} {
    return " "
}

# Initialize

mx_config_read $configfile

mx_log "**********************************************************************"
mx_log "--- $botnick started"

mx_read_questions $quizconf(questionset)
tmcquiz_rank_load $botnick 0 {}
tmcquiz_allstars_load $botnick 0 {}
set quizconf(quizchannel) [string tolower $quizconf(quizchannel)]
channel add $quizconf(quizchannel)

proc randomanswer {answer} {
   set lq [split $answer " "]
   set tq ""
   foreach elq $lq {
      if {[string trim $elq] != ""} {
         append tq [randstr $elq] " "
      }
   }
   return [string trim $tq]
}

proc randstr {word} {
   set l [string length $word]
   set n 0
   while {$n < $l} {
      set c [string index $word $n]
      set ch($n) $c
      incr n
   }
   set n 0
   while {$n < $l} {
      set r [rand $l]
      set t $ch($n)
      set ch($n) $ch($r)
      set ch($r) $t
      incr n
   }
   set w ""
   set n 0
   while {$n < $l} {
      append w $ch($n)
      incr n
   }
   return $w
}

## Tips To Use
set TipsToUse {
"4Ketik 12!start Untuk Memulai Permainan Game"
"4Ketik 12!point Untuk Melihat Peringkat Sementara"  
"4Ketik 12!score Untuk Melihat Nilai Kamu"
"4Ketik 12!save Untuk Simpan Score Anda" 
"4Ketik 12!stop Untuk Menghentikan Scramble Game"
"4Ketik 12!seen <nick> Untuk Mencari Nick Teman Kamu"
"4Ketik 12!qhelp Untuk Melihat Petunjuk Scramble Game"
"4Aturan 4*12|4* Yang Sopan Ya Kalau Main :)"
"4Aturan 4*12|4* Ndak Boleh Ngeflood Yach"
"4Aturan 4*12|4* Pakailah Nick Sopan"
"4Aturan 4*12|4* Jangan Repeat"
"4Aturan 4*12|4* DiLarang Merokok"
"4Aturan 4*12|4* Yang Gak Pake Kolor Di Larang Maen!"
"4Aturan 4*12|4* Sesama Pemain Di Larang Mendahului :)"
"4Info 4*12|4* 1Kalau Ada Soal Yang Salah atau Mau Buat Soal Baru Kirim Ke 12isfan"
}

## Proc to Randomly Select an Info Item!
proc get_InfoItem { } {
 global TipsToUse
 set outputiz2 [lindex $TipsToUse [rand [llength $TipsToUse]]]
 return $outputiz2
}

proc tmcquiz_stops {nick host handle idx channel} {
    global rankfile uptime botnick
    global quizconf
     tmcquiz_rank_save $handle $idx {}
    tmcquiz_saveuserquests $handle $idx "all"
    tmcquiz_config_save $handle $idx {}
    mxirc_dcc $idx "$botnick now exits."
    tmcquiz_halt $handle $idx {}

}
putlog "TCL Loaded: scramble.tcl"
