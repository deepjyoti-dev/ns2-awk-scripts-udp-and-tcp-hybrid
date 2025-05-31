


BEGIN {
    FS = " ";
}

# Packet sent at AGT layer
$1 == "s" && $4 == "AGT" {
    flow = $6 "-" $7;  # protocol-source-dest pair as key
    sent[flow]++;
    send_time[flow, $11] = $2;  # packet ID as subkey
    bytes[flow] += $10;

    if (start_time == "" || $2 < start_time) start_time = $2;
}

# Packet received at AGT layer
$1 == "r" && $4 == "AGT" {
    flow = $6 "-" $7;
    recv[flow]++;
    bytes_recv[flow] += $10;

    delay_key = flow SUBSEP $11;
    if (delay_key in send_time)
        delay[flow] += ($2 - send_time[delay_key]);

    if ($2 > end_time) end_time = $2;
}

# Packet dropped at RTR/IFQ
$1 == "d" && ($4 == "RTR" || $4 == "IFQ") {
    drop[$6 "-" $7]++;
}

END {
    print "============= NS2 Universal Trace Analysis =============";
    total_sent = 0; total_recv = 0; total_bytes = 0;

    for (flow in sent) {
        proto = substr(flow, 1, index(flow, "-") - 1);
        s = sent[flow];
        r = recv[flow];
        d = drop[flow] + 0;
        pdr = (s > 0) ? (r / s) * 100 : 0;
        loss = (s > 0) ? ((s - r) / s) * 100 : 0;
        avg_delay = (r > 0) ? delay[flow] / r : 0;
        tput = (bytes_recv[flow] * 8) / ((end_time - start_time) * 1000);  # in kbps

        print "Flow                : " flow;
        print "  Protocol          : " proto;
        print "  Packets Sent      : " s;
        print "  Packets Received  : " r;
        print "  Packets Dropped   : " d;
        printf "  PDR (%%)           : %.2f\n", pdr;
        printf "  Packet Loss (%%)   : %.2f\n", loss;
        printf "  Avg Delay (s)     : %.6f\n", avg_delay;
        printf "  Throughput (kbps) : %.2f\n", tput;
        print "--------------------------------------------------------";

        total_sent += s;
        total_recv += r;
        total_bytes += bytes_recv[flow];
    }

    overall_pdr = (total_sent > 0) ? (total_recv / total_sent) * 100 : 0;
    overall_loss = 100 - overall_pdr;
    sim_time = end_time - start_time;
    overall_tput = (sim_time > 0) ? (total_bytes * 8) / (sim_time * 1000) : 0;

    print "Overall Simulation Summary:";
    print "  Total Sent Packets     : " total_sent;
    print "  Total Received Packets : " total_recv;
    printf "  Overall PDR (%%)         : %.2f\n", overall_pdr;
    printf "  Overall Loss (%%)        : %.2f\n", overall_loss;
    printf "  Overall Throughput (kbps): %.2f\n", overall_tput;
    print "  Simulation Time (s)     : " sim_time;
    print "========================================================";
}
























































































