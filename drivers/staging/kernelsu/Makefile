kernelsu-objs := ksu.o
kernelsu-objs += allowlist.o
kernelsu-objs += apk_sign.o
kernelsu-objs += sucompat.o
kernelsu-objs += throne_tracker.o
kernelsu-objs += core_hook.o
kernelsu-objs += ksud.o
kernelsu-objs += embed_ksud.o
kernelsu-objs += kernel_compat.o

kernelsu-objs += selinux/selinux.o
kernelsu-objs += selinux/sepolicy.o
kernelsu-objs += selinux/rules.o
ccflags-y += -I$(srctree)/security/selinux -I$(srctree)/security/selinux/include
ccflags-y += -I$(objtree)/security/selinux -include $(srctree)/include/uapi/asm-generic/errno.h

obj-$(CONFIG_KSU) += kernelsu.o

$(eval WKSU_VERSION=12069)
$(info -- Wild KSU version: $(KSU_VERSION))
ccflags-y += -DKSU_VERSION=$(KSU_VERSION)

ifeq ($(shell grep -q " current_sid(void)" $(srctree)/security/selinux/include/objsec.h; echo $$?),0)
ccflags-y += -DKSU_COMPAT_HAS_CURRENT_SID
endif

ifeq ($(shell grep -q "struct selinux_state " $(srctree)/security/selinux/include/security.h; echo $$?),0)
ccflags-y += -DKSU_COMPAT_HAS_SELINUX_STATE
endif

ifndef WKSU_EXPECTED_SIZE
ifndef WKSU_MANAGER_SIZE
WKSU_MANAGER_SIZE := 0x39b
endif

ifndef WKSU_MANAGER_HASH
WKSU_MANAGER_HASH := 593d4ce870c02468639efeef631e07ca4d852d63f154be56706229f9a5be0800
endif

ifdef KSU_MANAGER_PACKAGE
ccflags-y += -DKSU_MANAGER_PACKAGE=\"$(KSU_MANAGER_PACKAGE)\"
$(info -- Wild KSU Manager package name: $(KSU_MANAGER_PACKAGE))
endif

$(info -- Wild KSU Manager signature size: $(WKSU_MANAGER_SIZE))
$(info -- Wild KSU Manager signature hash: $(WKSU_MANAGER_HASH))

ccflags-y += -DEXPECTED_MANAGER_SIZE=$(WKSU_MANAGER_SIZE)
ccflags-y += -DEXPECTED_MANAGER_HASH=\"$(WKSU_MANAGER_HASH) \

# UL, look for "ext4_unregister_sysfs" on fs/ext4
ifeq ($(shell grep -q "^extern void ext4_unregister_sysfs" $(srctree)/fs/ext4/ext4.h 2>/dev/null; echo $$?),0)
ccflags-y += -DKSU_HAS_MODERN_EXT4
endif

# enable functions that use stuct filename when ksu_handle_execveat is found
ifeq ($(shell grep -q "ksu_handle_execveat" $(srctree)/fs/exec.c; echo $$?),0)
ccflags-y += -DKSU_USE_STRUCT_FILENAME
endif

ifeq ($(shell grep -q "ksu_handle_execveat" $(srctree)/arch/arm/kernel/sys_arm.c; echo $$?),0)
ccflags-y += -DKSU_USE_STRUCT_FILENAME
endif

ifneq ($(shell grep -q "get_cred_rcu" $(srctree)/include/linux/cred.h; echo $$?),0)
$(error You must backport get_cred_rcu - https://github.com/tiann/KernelSU/pull/2320#issuecomment-2564232958 )
endif

ifeq ($(shell grep -q "int path_umount" $(srctree)/fs/namespace.c; echo $$?),0)
$(info -- KernelSU/compat: path_umount found)
ccflags-y += -DKSU_HAS_PATH_UMOUNT
endif

ifeq ($(shell grep -q "strncpy_from_user_nofault" $(srctree)/include/linux/uaccess.h; echo $$?),0)
$(info -- KernelSU/compat: strncpy_from_user_nofault found)
ccflags-y += -DKSU_STRNCPY_FROM_USER_NOFAULT
endif

ifeq ($(shell grep -q "strncpy_from_unsafe_user" $(srctree)/include/linux/uaccess.h; echo $$?),0)
$(info -- KernelSU/compat: strncpy_from_unsafe_user found)
ccflags-y += -DKSU_STRNCPY_FROM_UNSAFE_USER
endif

ifeq ($(shell grep -q "ssize_t kernel_read" $(srctree)/fs/read_write.c; echo $$?),0)
$(info -- KernelSU/compat: newer kernel_read found)
ccflags-y += -DKSU_NEW_KERNEL_READ
endif

ifeq ($(shell grep "ssize_t kernel_write" $(srctree)/fs/read_write.c | grep -q "const void" ; echo $$?),0)
$(info -- KernelSU/compat: newer kernel_write found)
ccflags-y += -DKSU_NEW_KERNEL_WRITE
endif

ccflags-y += -Wno-implicit-function-declaration -Wno-strict-prototypes -Wno-int-conversion
ccflags-y += -Wno-declaration-after-statement -Wno-unused-function

# Keep a new line here!! Because someone may append config
