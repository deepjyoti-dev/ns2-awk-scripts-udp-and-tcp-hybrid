#!/usr/bin/awk -f

BEGIN {

	start_time=0;
	finish_time=0;
	flag=0;
	flag1=0;
	f_size=0;
	throughput=0;
	latency=0;
	pdr=0;
	flag2=0;
        start_time1=0;
	finish_time1=0;
	flag1=0;
	f_size1=0;
	throughput1=0;
	latency1=0;
	pdr1=0;
	total_delay=0;
	packet_loss1=0;
        rec=0;
        dep=0;
	dep1=0;
       enq=0;
	 enq1=0;
	packet_loss1=0;
       time1=0;
	total2=0;
	deque1=0;
        total=0;
       deque=0;
	rec1=0;
        bh=0;
	check;
	printf("\nEnter:-\n 0 for TCP \n 1 for UDP\n");
	getline check <"/dev/stdin"
      }

{
	       
        event = $1 	
        time = $2 	
        node = $3	
	level = $4 	 
	pkt = $6 	
	traffic = $7 	 
        pktsize = $8
	finish_time2[$11]
	start_time2[$11]	
	delay1[$11]	  	
	

if (event == "r" && $5 == "tcp")
{

rec++

}	
else if (event == "d" && $5 == "tcp")
{
dep++

}
else if (event == "+" && $5 == "tcp")
{

enq++

}
else if (event == "-" && $5 == "tcp")

{
deque++

}
else if (event == "r" && $5 == "cbr")
{

rec1++
}

else if (event == "d" && $5 == "cbr")
{
dep1++

}
else if (event == "+" && $5 == "cbr")
{

enq1++

}
else if (event == "-" && $5 == "cbr")

{
deque1++

}



if ((event == "r" && level == 1) && $5 =="tcp")
{

f_size=f_size+pkt
if(flag == 0)
{
start_time=time
flag=1
}
finish_time=time
}

if (event == "r" && level == 5 && $5=="cbr")
{

f_size1=f_size1+pkt
if(flag2 == 0)
{
start_time1=time
flag2=1
}
finish_time1=time
}




if (event == "r" || event == "d")
{
if(flag1 == 0)
{
start_time2[$11]=time
flag1=1
}
finish_time2[$11]=time
delay1[$11]=finish_time2[$11]-start_time2[$11]
total_delay=total_delay+delay1[$11]
}





}

END {




latency1=finish_time1 - start_time1

throughput1=(f_size * 8)/latency1

pdr1=(rec1/(rec1+dep1))*100;
packet_loss1=((rec1+dep1)-rec1)*100

total = dep + rec + enq + deque;
total2= dep1 + rec1 + enq1 + deque1


latency=finish_time - start_time
throughput=(f_size * 8)/latency
pdr=(rec/(rec+dep))*100
packet_loss=((rec+dep)-rec)*100
average_delay=total_delay/(rec+dep)



if (check == 0)
{
printf("--------------------------------------------------------------------------")
printf("\n\t For TCP\n");
printf ("\n Total Delay = %f\n",total_delay);
printf ("\n Average Delay = %0.4f \n",average_delay);
printf ("\n Packet Loss Ratio =%d %\n",packet_loss);
printf ("\n Packet Delivery Ratio=%.2f %\n",pdr);
printf ("\n Throughput =%f bps\n",throughput);
printf ("\n Latency =%f ms\n",latency);
printf ("\n Total=%d\n",total);
printf ("\n Drop=%d\n",dep);
printf ("\n Received=%d\n",rec);
printf ("\n Enque =%d\n",enq);
printf ("\n Deque =%d\n",deque);
printf("--------------------------------------------------------------------------\n")
}

else if (check == 1)
{
printf("--------------------------------------------------------------------------")
printf("\n\t For UDP\n");
printf ("\n Packet Loss Ratio =%d %\n",packet_loss1);
printf ("\n PDR =%0.2f %\n",pdr1);
printf ("\n Throughput =%f bps\n",throughput1);
printf ("\n Latency =%f ms\n",latency1);
printf ("\n Total=%d\n",total2);
printf ("\n Drop=%d\n",dep1);
printf ("\n Received=%d\n",rec1);
printf ("\n Enque =%d\n",enq1);
printf ("\n Deque =%d\n",deque1);
printf("--------------------------------------------------------------------------\n")
}

else
{

printf("--------------------------------------------------------------------------")
printf ("\npacket size =%d\n",pkt);
#printf ("\nTotal Time =%0.4fms\n",time);

#printf ("\n size($8) = %d\n",pktsize);
printf("--------------------------------------------------------------------------\n")

}


}











