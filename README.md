# cray-tests
Libfabric test suite targets primarily at the GNI provider. The original cray-tests project allows only two processes to be running. This project supports various test scenarios with multiple nodes:

1. One-sided communications.
2. Two-sided communications.
3. configurable numbers of outgoing/incoming connections per node.
4. check the performance when a hop node is in between.
5. Check the performance of RDMA writes and RDMA reads.
