

set ns [new Simulator]

set f [open exp6.tr w]

$ns trace-all $f

set nf [open 1exp6.nam w]

$ns namtrace-all $nf

 

proc finish {} {

global ns nf f

$ns flush-trace

close $nf

close $f

exec nam 1exp6.nam &
#awk for delay
exit 0

}



#Create six nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#Create links between the nodes
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
$ns duplex-link $n3 $n5 2Mb 10ms DropTail
$ns duplex-link $n4 $n2 2Mb 10ms DropTail
$ns duplex-link $n3 $n1 2Mb 10ms DropTail

#Setup a TCP connection between nodes n0 and n1
set tcp1 [new Agent/TCP]
$tcp1 set segmentSize- 1000
$tcp1 set class_ 2
$ns attach-agent $n0 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 1





$ns queue-limit $n0 $n2 20
$ns queue-limit $n2 $n3 20
$ns queue-limit $n3 $n5 20



#Setup a FTP over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP





#schedule events for the ftp  agents
$ns at 1.0 "$ftp1 start"
$ns at 3.0 "$ftp1 stop"




#Setup a UDP connection between nodes n4 and n5
set udp1 [new Agent/UDP]
$ns attach-agent $n4 $udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$udp1 set class_ 2
$udp1 set segmentSize- 1500
set null0 [new Agent/Null]
$ns attach-agent $n5 $null0
$ns connect $udp1 $null0




#schedule events for the ftp  agents
$ns at 5.0 "$cbr1 start"
$ns at 9.0 "$cbr1 stop"





#Call the finish procedure after 5 seconds of simulation time
$ns at 30.0 "finish"


#Run the simulation
$ns run
























































































