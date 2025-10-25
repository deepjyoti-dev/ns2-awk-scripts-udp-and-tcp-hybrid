📊 NS2 AWK Scripts – UDP and TCP Hybrid Flow Analysis

A collection of AWK scripts to analyze NS2 trace files for simulations containing any number of TCP and UDP flows. Provides per-flow and aggregate metrics including throughput, delay, and drop counts.

✅ Features
Feature	Description
Universal	Works for any number of TCP/UDP flows
Auto Flow Detection	Detects flows automatically using $6-$7 (protocol, source, destination)
Accurate Delay	Calculates delay per packet by matching packet IDs
Drop Count	Handles RTR and IFQ layer drops
Throughput	Reports throughput in kbps per flow and overall
Overall Metrics	Aggregates stats for the entire simulation at the end
🔧 Usage

Run your NS2 simulation to generate trace files:

ns your_simulation.tcl


Analyze TCP/UDP flows using AWK scripts:

awk -f flow_analysis.awk exp7.tr > flow_metrics.txt


Output includes:

Per-flow delay, throughput, and drop counts

Total throughput and overall metrics

🧠 Notes

Works with hybrid simulations containing multiple TCP and UDP flows.

Ensure trace files are in standard NS2 trace format.

Can be combined with NAM visualization for topology verification.

🏷️ Tags

#ns2 #awk #networking #udp #tcp #throughput #delay #simulation #hybrid #flow-analysis
