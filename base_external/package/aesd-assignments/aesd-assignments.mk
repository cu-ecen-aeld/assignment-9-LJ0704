##############################################################
#
# AESD-ASSIGNMENTS PACKAGE FOR BUILDROOT
#
##############################################################
#ChatGPT : https://chatgpt.com/share/69ae35ac-a2fc-8009-92ab-f80581fea5c9
AESD_ASSIGNMENTS_VERSION = addb90ac2ff4bf2a8fd9a4ae0bcdf67dd87b9bfb
AESD_ASSIGNMENTS_SITE = git@github.com:cu-ecen-aeld/assignments-3-and-later-LJ0704.git
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_GIT_SUBMODULES = YES

# This is the directory where your kernel module resides
AESD_ASSIGNMENTS_MODULE_SUBDIRS = aesd-char-driver

# Build commands for userspace programs
define AESD_ASSIGNMENTS_BUILD_CMDS
	# Build server and kernel module
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/server all
endef

# Install userspace executables and kernel module helpers
define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
    # Install the socket server
    $(INSTALL) -m 0755 $(@D)/server/aesdsocket $(TARGET_DIR)/usr/bin/
    $(INSTALL) -m 0755 $(@D)/server/aesdsocket-start-stop $(TARGET_DIR)/etc/init.d/S99aesdsocket

    # Install kernel module load/unload scripts
    $(INSTALL) -m 0755 $(@D)/aesd-char-driver/aesdchar_load $(TARGET_DIR)/usr/bin/
    $(INSTALL) -m 0755 $(@D)/aesd-char-driver/aesdchar_unload $(TARGET_DIR)/usr/bin/

    # Ensure kernel module loads at boot
    mkdir -p $(TARGET_DIR)/etc/modules-load.d
    echo "aesdchar" > $(TARGET_DIR)/etc/modules-load.d/aesdchar.conf
endef

$(eval $(kernel-module))
$(eval $(generic-package))
