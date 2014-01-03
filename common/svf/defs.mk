
COMMON_SVF_DIR=$(SOCBLOX)/common/svf

COMMON_SVF_SRC=\
	svf_elf_loader.cpp
	
COMMON_SVF_OBJS=$(foreach o,$(COMMON_SVF_SRC:.cpp=.o),$(SOCBLOX_OBJDIR)/$(o))

COMMON_SVF_LINK=-lcommon_svf

COMMON_SVF_LIB=$(SOCBLOX_LIBDIR)/$(LIBPREF)common_svf$(DLLEXT)

LIB_TARGETS += $(COMMON_SVF_LIB)

CXXFLAGS += -I$(COMMON_SVF_DIR)

