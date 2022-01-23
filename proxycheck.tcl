##################################################################################
## Check IP From Proxycheck.io                                                  ##
## Simple CovidIP TCL By iJoo                                                   ##
##                                                                              ##
##                                                                   02/10/2021 ##
##################################################################################

package require http
package require tls
http::register https 443 [list ::tls::socket -autoservername true]

## Siapa yang bisa command? n = owner
set akses ""
set perintah "!cp"

bind pub $akses $perintah ijoo_ganteng

proc ijoo_ganteng {nick uhost hand chan rest} {
        set chkip [lindex $rest 0]
        set theURL "https://proxycheck.io/v2/$chkip?vpn=1&asn=1"
        set token [http::geturl $theURL]
        regexp {"status": "(.*?)"} [http::data $token] -> checkin
        if { [string match "error" $checkin] } {
                putquick "PRIVMSG $chan :Sorry IP Error!"
        } else {
                regexp {"asn": "(.*?)"} [http::data $token] -> ijoo_asn
                regexp {"provider": "(.*?)"} [http::data $token] -> ijoo_prov
                regexp {"continent": "(.*?)"} [http::data $token] -> ijoo_cont
                regexp {"country": "(.*?)"} [http::data $token] -> ijoo_cont2
                regexp {"isocode": "(.*?)"} [http::data $token] -> ijoo_code
                regexp {"proxy": "(.*?)"} [http::data $token] -> ijoo_prox
                regexp {"type": "(.*?)"} [http::data $token] -> ijoo_type
                putquick "PRIVMSG $chan :IP:\002 $chkip\002, Provider Oleh:\002 $ijoo_prov\002, ASN:\002 $ijoo_asn\002, Lokasi:\002 $ijoo_cont, $ijoo_cont2 ($ijoo_code)\002, Proxy Status:\002 $ijoo_prox ($ijoo_type)\002"
        }
}

putlog "proxycheck is Loaded!"
