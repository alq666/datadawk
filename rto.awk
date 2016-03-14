# Measures RTO, retransmits and lost packets on a per-connection basis.
# Requires `ss`
/rto/ {
        split($3, arr, ":");
        rto = arr[2];
        if (match($0, /rto:([[:digit:]]+)/, arr)) rto = arr[1];
        if (match($0, /unacked:([[:digit:]]+)/, arr)) unacked = arr[1];
        if (match($0, /retrans:([[:digit:]]+)?\/([[:digit:]]+)/, arr)) retrans = arr[1];
        if (match($0, /lost:([[:digit:]]+)?/, arr)) lost = arr[1];
        d = "system.net.tcp.rto:" rto "|ms";
        print d > "/inet4/udp/0/localhost/8125";
        close("/inet4/udp/0/localhost/8125");
        if (unacked > 0) {
                d = "system.net.tcp.unacked:" unacked "|c";
                print d > "/inet4/udp/0/localhost/8125";
                close("/inet4/udp/0/localhost/8125");
        }
        if (retrans > 0) {
                d = "system.net.tcp.retrans:" retrans "|ms";
                print d > "/inet4/udp/0/localhost/8125";
                close("/inet4/udp/0/localhost/8125");
        }
        if (lost > 0) {
                d = "system.net.tcp.lost:" lost "|c";
                print d > "/inet4/udp/0/localhost/8125";
                close("/inet4/udp/0/localhost/8125");
        }
}
