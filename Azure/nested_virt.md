# Nested Virt in Azure on a D4sV3 VM

- Please confirm that your VM is set to Security type: Standard.
![Nested Virt](Azure/Diagrams/5.png)

```
# lsmod | grep kvm
kvm_intel             479232  12
kvm                  1372160  9 kvm_intel
irqbypass              12288  1 kvm

# ls -lah /dev/kvm
crw-rw---- 1 root kvm 10, 232 Mar  3 07:34 /dev/kvm

# cat /sys/module/kvm_intel/parameters/nested
Y

# modinfo kvm_intel | grep nested
parm:           nested_early_check:bool
parm:           nested:bool
```