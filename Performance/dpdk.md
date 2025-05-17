# What is DPDK?
- DPDK is a set of libraries and drivers for fast packet processing.
- It is designed to run on any processors. The first supported CPU was Intel x86 and it is now extended to IBM POWER and ARM.
- It runs mostly in Linux userland. A FreeBSD port is available for a subset of DPDK features.
- The DPDK framework creates a set of libraries for specific hardware/software environments through the creation of an Environment Abstraction Layer (EAL).The EAL hides the environmental specific and provides a standard programming interface to libraries, available hardware accelerators and other hardware and operating system (Linux, FreeBSD) elements. Once the EAL is created for a specific environment, developers link to the library to create their applications. For instance, EAL provides the frameworks to support Linux,FreeBSD, Intel IA 32- or 64-bit, IBM Power8, EZchip TILE-Gx and ARM.
- DPDK is not a networking stack and does not provide functions such as Layer-3 forwarding, IPsec, firewalling, etc.

## Libraries
- multicore framework
- huge page memory
- ring buffers
- poll-mode drivers for networking

## Usage of Libraries
- These libraries can be used to:
    - receive and send packets within the minimum number of CPU cycles (usually less than 80 cycles)
    - develop fast packet capture algorithms (tcpdump-like)
    - run third-party fast path stacks
- Some packet processing functions have been bench marked up to hundreds million frames per second, using 64-byte packets with a PCIe NIC.

## Documentation
- [quick start guide](http://dpdk.org/doc/quick-start)
- [dpdk api](http://dpdk.org/doc/api/)
- [dpdk-supported nics](http://dpdk.org/doc/nics)
- [dpdk-detailed-guide](http://dpdk.org/doc/guides/)
- Pktgen, (Packet Gen-erator) is a software based traffic generator powered by the DPDK fast packet processing framework. [pktget](http://pktgen-dpdk.readthedocs.io/en/latest/)