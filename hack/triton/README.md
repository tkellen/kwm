# KWM on Triton

## Setup
1. `export TRITON_ACCOUNT=<your account name>`
2. `export TRITON_KEY_ID=${$(ssh-keygen -l -E md5 -f ~/.ssh/id_rsa.pub | awk '{print $2}')#MD5:}`
3. `terraform init`
4. `terraform apply`
5. `./generate-settings > ../../settings`
6. `cd ../..`
7. `source settings`
8. `./kwm`
9. Follow the prompts.

## Notes
Triton infrastructure containers do not permit direct access to the kernel.
This type of container emulates the Linux environment by enabling Linux binaries
to be executed directly on the hardware. Containers running this way shares the
kernel with the host server cannot configure kernel modules, or set kernel
parameters.

If I want to run k8s on triton, I should do it fully containerized, not in a
containerized Ubuntu running a container runtime :p

This is presently not a candidate for KWM.

*Evidence:*
ExecStartPre fails on containerd startup trying to run `modprobe overlay`:
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/4.3.0/modules.dep.bin'
modprobe: FATAL: Module overlay not found in directory /lib/modules/4.3.0
