# Poll Mode Drivers (PMD)
- A Poll Mode Driver (PMD) consists of APIs, provided through the BSD driver running in user space, to configure the devices and their respective queues.
- DPDK includes 1 Gigabit, 10 Gigabit and 40 Gigabit and para virtualized Virtio Poll Mode Drivers.
- In addition, a PMD accesses the RX and TX descriptors directly without any interrupts (with the exception of Link Status Change interrupts) to quickly receive, process and deliver packets in the user’s application.
- [dpdk_pmd](http://dpdk.org/doc/guides/prog_guide/poll_mode_drv.html)

## Virtio NIC
- It supports merge-able buffers per packet when receiving packets and scattered buffer per packet when transmitting packets. The packet size supported is from 64 to 1518.
- It supports multicast packets and promiscuous mode.
- Virtio does not support run time configuration.
- Virtio supports Link State interrupt.
- Virtio supports Rx interrupt (so far, only support 1:1 mapping for queue/interrupt).
- Virtio supports software vlan stripping and inserting.
- [virtio](http://dpdk.org/doc/guides/nics/virtio.html)

## VMXNET3 NIC
- The VMXNET3 adapter is the next generation of a paravirtualized NIC, introduced by VMware ESXi.
- It is designed for performance, offers all the features available in VMXNET2, and adds several new features such as, multi-queue support (also known as Receive Side Scaling, RSS), IPv6 offloads, and MSI/MSI-X interrupt delivery.
- Features and Limitations of VMXNET3:
    - MAC Address based filtering:
        - Unicast, Broadcast, All Multicast modes - SUPPORTED BY DEFAULT
        - Multicast with Multicast Filter table - NOT SUPPORTED
        - Promiscuous mode - SUPPORTED
        - RSS based load balancing between queues - SUPPORTED
    - VLAN filtering:
        - VLAN tag based filtering without load balancing - SUPPORTED
- [vmxnet3](http://dpdk.org/doc/guides/nics/vmxnet3.html)

## KNI
- The DPDK Kernel NIC Interface (KNI) allows userspace applications access to the Linux control plane.
- The benefits of using the DPDK KNI are:
    - Faster than existing Linux TUN/TAP interfaces (by eliminating system calls and copy_to_user()/copy_from_user() operations.)
    - Allows management of DPDK ports using standard Linux net tools such as ethtool, ifconfig and tcpdump.
    - Allows an interface with the kernel network stack.
- This PMD enables using KNI without having a KNI specific application, any forwarding application can use PMD interface for KNI.
- Sending packets to any DPDK controlled interface or sending to the Linux networking stack will be transparent to the DPDK application.
- Packets sent to the KNI Linux interface will be received by the DPDK application, and DPDK application may forward packets to a physical NIC or to a virtual device (like another KNI interface or PCAP interface).
- [kni](http://dpdk.org/doc/guides/nics/kni.html)

## IXGBE
- Vector PMD uses Intel® SIMD instructions to optimize packet I/O. It improves load/store bandwidth efficiency of L1 data cache by using a wider SSE/AVX register 1 (1).
- The wider register gives space to hold multiple packet buffers so as to save instruction number when processing bulk of packets.
- Although the user can set the MTU separately on PF and VF ports, the IXGBE NIC only supports one global MTU per physical port.
- So when the user sets different MTU's on PF and VF ports in one physical port, the real MTU for all these PF and VF ports is the largest value set. This behavior is based on the kernel driver behavior.
- Supported Chipsets and NIC:
    - Intel 82599EB 10 Gigabit Ethernet Controller
    - Intel 82598EB 10 Gigabit Ethernet Controller
    - Intel 82599ES 10 Gigabit Ethernet Controller
    - Intel 82599EN 10 Gigabit Ethernet Controller
- [ixgbe](http://dpdk.org/doc/guides/nics/ixgbe.html)

## Libpcap
- In addition to Poll Mode Drivers (PMDs) for physical and virtual hardware, the DPDK also includes pure-software PMDs.
- A libpcap -based PMD (librte_pmd_pcap) that reads and writes packets using libpcap, - both from files on disk, as well as from physical NIC devices using standard Linux kernel drivers.
- Pcap-based devices can be created using the virtual device –vdev option.
- The device name must start with the net_pcap prefix followed by numbers or letters. The name is unique for each device. Each device can have multiple stream options and multiple devices can be used.
- [libpcap](http://dpdk.org/doc/guides/nics/pcap_ring.html)

## MLX4
- Mellanox Poll Mode Driver (PMD) is designed for fast packet processing and low latency by providing kernel bypass for receive, send, and by avoiding the interrupt processing performance overhead.
- mlx4 is the DPDK Poll-Mode Driver for Mellanox ConnectX®-3 Pro Ethernet adapters
- Mellanox PMDs supports bare metal, KVM and VMware SR-IOV on x86_64 and Power8 architectures.
- RSS, also known as RCA, is supported. In this mode the number of configured RX queues must be a power of two.
- VLAN filtering is supported.
- Link state information is provided.
- Promiscuous mode is supported.
- All multicast mode is supported.
- Multiple MAC addresses (unicast, multicast) can be configured.
- Scattered packets are supported for TX and RX.
- Inner L3/L4 (IP, TCP and UDP) TX/RX checksum offloading and validation.
- Outer L3 (IP) TX/RX checksum offloading and validation for VXLAN frames.
- Secondary process TX is supported.
- RX interrupts.
- RSS hash key cannot be modified.
- RSS RETA cannot be configured
- RSS always includes L3 (IPv4/IPv6) and L4 (UDP/TCP). They cannot be dissociated.
- Hardware counters are not implemented (they are software counters).
- Secondary process RX is not supported.
- [mlx4](https://doc.dpdk.org/guides/nics/mlx4.html)