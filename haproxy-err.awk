# Parses the haproxy error log
/YOUR_PATTERN_HERE_EG_A_URL_OR_GET/ {
        split($7, arr, "/");
        host = arr[2];
        if (host == "<NOSRV>") {
                host = "nosrv";
        }   
        split($8, arr, "/");
        tq = arr[1];
        tw = arr[2];
        tc = arr[3];
        tr = arr[4];
        tt = arr[5];
        split($18, arr, "?");
        stem = arr[1];
        # send to dogstatsd
        d = "app.connection.error:1|c|#server:" host ",stem:" stem;
        print d > "/inet4/udp/0/localhost/8125";
        close("/inet4/udp/0/localhost/8125");

        # send other metrics
        d = "haproxy.request.tq:" tq "|ms|#server:" host ",stem:" stem;
        print d > "/inet4/udp/0/localhost/8125";
        close("/inet4/udp/0/localhost/8125");
        d = "haproxy.request.tw:" tw "|ms|#server:" host ",stem:" stem;
        print d > "/inet4/udp/0/localhost/8125";
        close("/inet4/udp/0/localhost/8125");
        d = "haproxy.request.tc:" tc "|ms|#server:" host ",stem:" stem;
        print d > "/inet4/udp/0/localhost/8125";
        close("/inet4/udp/0/localhost/8125");
        d = "haproxy.request.tr:" tr "|ms|#server:" host ",stem:" stem;
        print d > "/inet4/udp/0/localhost/8125";
        close("/inet4/udp/0/localhost/8125");
        d = "haproxy.request.tt:" tt "|ms|#server:" host ",stem:" stem;
        print d > "/inet4/udp/0/localhost/8125";
        close("/inet4/udp/0/localhost/8125");

}
