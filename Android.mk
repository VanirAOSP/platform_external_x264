include $(CLEAR_VARS)
X264_TCDIR := $(realpath $(shell dirname $(TARGET_TOOLS_PREFIX)))
X264_TCPREFIX := $(shell basename $(TARGET_TOOLS_PREFIX))
# FIXME remove -fno-strict-aliasing once the code is fixed
COMPILER_FLAGS := $(subst -I ,-I../../,$(subst -include system/core/include/arch/linux-arm/AndroidConfig.h,,$(subst -include build/core/combo/include/arch/linux-arm/AndroidConfig.h,,$(TARGET_GLOBAL_CFLAGS)))) -fno-strict-aliasing

.phony: x264

droid: x264

systemtarball: x264

x264: $(TARGET_CRTBEGIN_DYNAMIC_O) $(TARGET_CRTEND_O) $(TARGET_OUT_SHARED_LIBRARIES)/libm.so $(TARGET_OUT_SHARED_LIBRARIES)/libc.so $(TARGET_OUT_SHARED_LIBRARIES)/libdl.so
	cd $(TOP)/external/x264 && \
	export PATH=$(X264_TCDIR):$(PATH) && \
	./configure \
		--host=arm-linux \
		--prefix=/system \
		--bindir=/system/bin \
		--libdir=/system/lib \
		--enable-shared \
		--disable-thread \
		--cross-prefix=$(X264_TCPREFIX) \
		--extra-ldflags="-nostdlib -Wl,-dynamic-linker,/system/bin/linker -L../../$(PRODUCT_OUT)/system/lib -L../../$(TARGET_OUT_SHARED_LIBRARIES) -lgcc -ldl -lc" \
		--extra-cflags="$(COMPILER_FLAGS) -I../../bionic/libc/include -I../../bionic/libc/kernel/common -I../../bionic/libc/kernel/arch-arm -I../../bionic/libc/arch-arm/include -I../../bionic/libm/include" && \
	$(MAKE) && \
	$(MAKE) install DESTDIR=../../$(PRODUCT_OUT)/
