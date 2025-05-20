# What is the difference between L2 Out and L3 Out in ACI?

- The connection between the Cisco ACI fabric and the entity is usually called L2Out, because one or more broadcast domain are extended to the entity. L2Out can be internal or external:
    - Internal: the external entity will be within the EPG, so no contract is needed to make the entity communicate with anything is already inside the fabric (within the same EPG)
    - external: the external entity will be on a dedicated EPG and a contract must be defined to make the entity communicate with anything inside the fabric.
- External Layer 3 connectivity is configured in Cisco Application Centric Infrastructure (Cisco ACI) using the Layer 3 Outside configuration policy (commonly referred to as L3Out).
    - Cisco ACI supports multiple L3Out connections per tenant and VRF instance.
    - When multiple L3Outs are configured in the same tenant and VRF instance, external routes learned from one L3Out can be advertised through another L3Out, making the Cisco ACI fabric a transit network. The propagation of externally learned routes from one L3Out to another L3Out is controlled by a policy with the default behavior to not advertise externally learned routes from one L3Out to another L3Out.
    - L3Outs are deployed on Cisco ACI leaf switches. When an L3Out is configured on a leaf switch, this effectively makes the leaf switch a border leaf switch. Multiple border leaf switches can be configured in each tenant and VRF instance.
    - From a routing perspective, the Cisco ACI fabric does not function as a single logical router, but rather as a network of routers that are connected to an MP-BGP core. All routes learned from an L3Out are leaked into MP-BGP and then redistributed to every leaf switch in the fabric where the VRF instance is deployed.
    - If another L3Out is configured on another leaf switch, those routes can be advertised back out the other L3Out.