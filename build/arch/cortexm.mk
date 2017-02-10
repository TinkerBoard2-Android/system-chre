#
# Build targets for a Cortex-M-based processor
#

include $(CHRE_PREFIX)/build/defs.mk

# Hexagon Environment Checks ###################################################

# If building for the Cortex-M target, ensure that the user has specified a path
# to the Cortex-M toolchain that they wish to use.
ifeq ($(CORTEXM_TOOLS_PREFIX),)
$(error "You must supply a CORTEXM_TOOLS_PREFIX environment variable \
         containing a path to the Cortex-M toolchain. Example: \
         export CORTEXM_TOOLS_PREFIX=$$HOME/bin/gcc-arm-none-eabi-5_3-2016q1")
endif

# Cortex-M Tools ###############################################################

TARGET_AR = $(CORTEXM_TOOLS_PREFIX)/bin/arm-none-eabi-ar
TARGET_CC = $(CORTEXM_TOOLS_PREFIX)/bin/arm-none-eabi-gcc
TARGET_LD = $(CORTEXM_TOOLS_PREFIX)/bin/arm-none-eabi-ld

# Cortex-M Compiler Flags ######################################################

# Add Cortex-M compiler flags.
TARGET_CFLAGS += $(CORTEXM_CFLAGS)

# TODO: Add more Cortex-M flags from the Nanohub build

# Code generation flags.
TARGET_CFLAGS += -mthumb
TARGET_CFLAGS += -mfloat-abi=softfp
TARGET_CFLAGS += -mno-thumb-interwork
TARGET_CFLAGS += -ffast-math
TARGET_CFLAGS += -fsingle-precision-constant

# Cortex-M Archive Flags #######################################################

TARGET_ARFLAGS = -rsc

# Cortex-M Linker Flags ########################################################

TARGET_LDFLAGS += -shared

# Supported Cortex-M Architectures #############################################

CORTEXM_SUPPORTED_ARCHS = m4

# Environment Checks ###########################################################

# Ensure that an architecture is chosen.
ifeq ($(filter $(CORTEXM_ARCH), $(CORTEXM_SUPPORTED_ARCHS)),)
$(error "The CORTEXM_ARCH argument must be set to a supported architecture (\
         $(CORTEXM_SUPPORTED_ARCHS))")
endif

# Target Architecture ##########################################################

# Set the Cortex-M architecture.
ifeq ($(CORTEXM_ARCH), m4)
TARGET_CFLAGS += -mcpu=cortex-m4
TARGET_CFLAGS += -mfpu=fpv4-sp-d16
endif

# Optimization Level ###########################################################

TARGET_CFLAGS += -O$(OPT_LEVEL)

# Variant Specific Sources #####################################################

TARGET_VARIANT_SRCS += $(CORTEXM_SRCS)
