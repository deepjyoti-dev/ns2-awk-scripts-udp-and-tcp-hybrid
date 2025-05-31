#!/usr/bin/awk -f

BEGIN {
    FS = " ";
    print "\nSelect Protocol Type:";
    print " 0 - TCP";
    print " 1 - UDP";
    print " 2 - Both TCP and UDP";
    getline choice < "/dev/stdin";
}

{
    event = $1;         # s, r, d, +, -
    time = $2;
    level = $4;         # layer
    proto = $5;         # tcp or cbr
    pkt_size = $8;
    fid = $11;

    # Track events
    if (proto == "tcp") {
        if (event == "r") tcp_recv++;
        if (event == "d") tcp_drop++;
        if (event == "+") tcp_enq++;
        if (event == "-") tcp_deq++;

        if (event == "r" && level == "AGT") {
            tcp_bytes += pkt_size;
            if (!tcp_start) tcp_start = time;
            tcp_end = time;
        }
    }

    if (proto == "cbr") {
        if (event == "r") udp_recv++;
        if (event == "d") udp_drop++;
        if (event == "+") udp_enq++;
        if (event == "-") udp_deq++;

        if (event == "r" && level == "AGT") {
            udp_bytes += pkt_size;
            if (!udp_start) udp_start = time;
            udp_end = time;
        }
    }

    # Common delay logic
    if ((event == "r" || event == "d") && fid != "") {
        if (!(fid in start_time)) start_time[fid] = time;
        end_time[fid] = time;
    }
}

END {
    ### TCP Stats ###
    if (choice == 0 || choice == 2) {
        delay_sum = 0;
        for (id in end_time)
            delay_sum += end_time[id] - start_time[id];

        tcp_latency = (tcp_end - tcp_start > 0) ? tcp_end - tcp_start : 1;
        tcp_throughput = (tcp_bytes * 8) / tcp_latency; # bps
        tcp_pdr = (tcp_recv + tcp_drop > 0) ? (tcp_recv / (tcp_recv + tcp_drop)) * 100 : 0;
        tcp_loss = 100 - tcp_pdr;
        avg_delay = (tcp_recv + tcp_drop > 0) ? delay_sum / (tcp_recv + tcp_drop) : 0;

        printf("\n---------------- TCP Statistics ----------------\n");
        printf("Total Received     : %d\n", tcp_recv);
        printf("Total Dropped      : %d\n", tcp_drop);
        printf("Enqueued           : %d\n", tcp_enq);
        printf("Dequeued           : %d\n", tcp_deq);
        printf("Latency            : %.4f ms\n", tcp_latency * 1000);
        printf("Average Delay      : %.6f s\n", avg_delay);
        printf("Throughput         : %.2f bps\n", tcp_throughput);
        printf("PDR                : %.2f%%\n", tcp_pdr);
        printf("Packet Loss Ratio  : %.2f%%\n", tcp_loss);
        printf("------------------------------------------------\n");
    }

    ### UDP Stats ###
    if (choice == 1 || choice == 2) {
        udp_latency = (udp_end - udp_start > 0) ? udp_end - udp_start : 1;
        udp_throughput = (udp_bytes * 8) / udp_latency; # bps
        udp_pdr = (udp_recv + udp_drop > 0) ? (udp_recv / (udp_recv + udp_drop)) * 100 : 0;
        udp_loss = 100 - udp_pdr;

        printf("\n---------------- UDP Statistics ----------------\n");
        printf("Total Received     : %d\n", udp_recv);
        printf("Total Dropped      : %d\n", udp_drop);
        printf("Enqueued           : %d\n", udp_enq);
        printf("Dequeued           : %d\n", udp_deq);
        printf("Latency            : %.4f ms\n", udp_latency * 1000);
        printf("Throughput         : %.2f bps\n", udp_throughput);
        printf("PDR                : %.2f%%\n", udp_pdr);
        printf("Packet Loss Ratio  : %.2f%%\n", udp_loss);
        printf("------------------------------------------------\n");
    }

    if (choice != 0 && choice != 1 && choice != 2) {
        print "\nInvalid option selected.";
    }
}






