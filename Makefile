
SOCBLOX := $(shell pwd)

include $(SOCBLOX)/defs.mk

all : inc_targets lib_targets

lib_targets : $(LIB_TARGETS)


inc_targets : $(INC_TARGETS)

clean :
	rm -rf $(SOCBLOX_LIBDIR) $(SOCBLOX_OBJDIR) inc_targets lib_targets
#	rm -rf $(CLEAN_LIST)

include $(SOCBLOX)/rules.mk

