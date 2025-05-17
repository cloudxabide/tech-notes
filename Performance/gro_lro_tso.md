# Segmentation offload and Protocols

- When a system needs to send large chunks of data out over a computer network, the chunks first need breaking down into smaller segments that can pass through all the network elements like routers and switches between the source and destination computers. This process is referred to as segmentation.

## GRO
- Generic Receive Offload (GRO) is a widely used SW-based offloading technique to reduce per-packet processing overhead.
- It gains performance by reassembling small packets into large ones.
- To enable more flexibility to applications, DPDK implements GRO as a standalone library.
- Applications explicitly use the GRO library to merge small packets into large ones.
- The GRO library assumes all input packets have correct checksums. In addition, the GRO library doesn’t re-calculate checksums for merged packets. If input packets are IP fragmented, the GRO library assumes they are complete packets (i.e. with L4 headers).
- Currently, the GRO library implements TCP/IPv4 packet reassembly.
- Check if the packet should be processed. Packets with one of the following properties aren’t processed and are returned immediately:
    - FIN, SYN, RST, URG, PSH, ECE or CWR bit is set.
    - L4 payload length is 0.
- [gro](http://dpdk.org/doc/guides/prog_guide/generic_receive_offload_lib.html)

## LRO
- Large Receive Offload (LRO) is a technique to reduce the CPU time for processing TCP packets that arrive from the network at a high rate.
- LRO reassembles incoming packets into larger ones (but fewer packets) to deliver them to the network stack of the system. 
- LRO processes fewer packets, which reduces its CPU time for networking.
- Throughput can be improved accordingly since more CPU is available to deliver additional traffic.

## TSO
- Often the TCP protocol in the host computer performs this segmentation. Offloading this work to the NIC is called Transmit Segmentation Offload or TCP Segmentation Offload.
- TSO is available to be tested on Intel Ethernet Controller, including Intel 82599 10GbE Ethernet Controller and Fortville 40GbE Ethernet Controller.
- TSO enables the TCP/IP stack to pass to the network device a larger ULP datagram than the Maximum Transmit Unit Size (MTU).
- NIC divides the large ULP datagram to multiple segments according to the MTU size.