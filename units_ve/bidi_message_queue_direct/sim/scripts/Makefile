#****************************************************************************
#* Makefile
#*
#* TODO: 
#****************************************************************************

TIMEOUT := 25ms
SCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

#* TODO: Uncomment to enable target build
# TARGET_MAKEFILE := $(SCRIPTS_DIR)/target.mk

COMMON_BFM_DIR ?= $(COMMON_SIM_MK_DIR)/bfm
COMMON_SVF_DIR ?= $(COMMON_SIM_MK_DIR)/svf

UNIT_SW_DIRS = bidi_message_queue

BFM_UNIT_DIRS = axi4_svf bidi_message_queue_direct_bfm
MK_INCLUDES += $(foreach dir,$(BFM_UNIT_DIRS), $(COMMON_BFM_DIR)/$(dir)/defs_rules.mk)
MK_INCLUDES += $(foreach dir,$(UNIT_SW_DIRS), $(UNITS)/$(dir)/sw/defs_rules.mk)

MK_INCLUDES += $(COMMON_SIM_MK_DIR)/../svf/svf_defs.mk
MK_INCLUDES += $(COMMON_SVF_DIR)/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tb/defs_rules.mk 
MK_INCLUDES += $(SIM_DIR)/../stim/defs_rules.mk
MK_INCLUDES += $(SIM_DIR)/../tests/defs_rules.mk

UNIT_VE=bidi_message_queue_direct
TB=$(UNIT_VE)_tb



BFMS += SVF_AXI4_BFM COMMON_SVF BIDI_MESSAGE_QUEUE_DIRECT_BFM BIDI_MESSAGE_QUEUE_DRV

VERILATOR_TRACE_EN ?= 1

include $(SOCBLOX)/common/common_sim.mk

