# Parses the haproxy error log
function dogstatsd(metric_name, metric_type, value, tags) {
        s = "";
        for (tag in tags) {
                s = s tag":" tags[tag] ",";
        }
        # drop the final comma
        if (length(s) > 0) {
                s = substr(s, 1, length(s) - 1);
        }
        d = metric_name ":" value "|" metric_type "|#" s;
        print d > "/inet4/udp/0/localhost/8125";
        close("/inet4/udp/0/localhost/8125");
        return d;
}

!/is going DOWN for maintenance/ {
        split($7, arr, "/");
        pool = arr[1];
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
        # Assemble tags
        t["server"] = host;
        t["stem"] = stem;
        t["pool"] = pool;
        # send to dogstatsd
        dogstatsd("haproxy.connection.error", "c", 1, t);
        dogstatsd("haproxy.request.tq", "ms", tq, t);
        dogstatsd("haproxy.request.tw", "ms", tw, t);
        dogstatsd("haproxy.request.tc", "ms", tc, t);
        dogstatsd("haproxy.request.tr", "ms", tr, t);
        dogstatsd("haproxy.request.tt", "ms", tt, t);
}
