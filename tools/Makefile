#!make
#
# Copyright (C) 2021-2025 Intel Corporation
# SPDX-License-Identifier: BSD-3-Clause
#

NPROC := $(shell nproc)

default: tools-riscv64
.PHONY: default tools tools-aarch64 tools-x86_64 tools-riscv64 async-profiler avx-turbo cpuid dmidecode ethtool fio ipmitool lshw lspci msr-tools pcm perf-x86_64 processwatch spectre-meltdown-checker sshpass stackcollapse-perf stress-ng sysstat tsc turbostat
tools-x86_64: async-profiler avx-turbo cpuid dmidecode ethtool fio ipmitool lshw lspci msr-tools spectre-meltdown-checker sshpass stackcollapse-perf stress-ng sysstat tsc
ifeq ($(shell uname -m),x86_64)
	make turbostat
endif
	mkdir -p bin/x86_64
	cp -R async-profiler bin/x86_64/
	#cp avx-turbo/avx-turbo bin/x86_64/
	#cp cpuid/cpuid bin/x86_64/
	cp dmidecode/dmidecode bin/x86_64/
	cp ethtool/ethtool bin/x86_64/
	cp fio/fio bin/x86_64/
	cp stackcollapse-perf/stackcollapse-perf bin/x86_64/
	cp ipmitool/src/ipmitool.static bin/x86_64/ipmitool
	cp lshw/src/lshw-static bin/x86_64/lshw
	cp lspci/lspci bin/x86_64/
	cp lspci/pci.ids.gz bin/x86_64/
	cp msr-tools/rdmsr bin/x86_64/
	cp msr-tools/wrmsr bin/x86_64/
	#cp pcm/build/bin/pcm-tpmi bin/x86_64/
	#cp pcm/scripts/bhs-power-mode.sh bin/x86_64/
	cp perf-archive/perf-archive.sh bin/x86_64/perf-archive && chmod +rx bin/x86_64/perf-archive
	cp spectre-meltdown-checker/spectre-meltdown-checker.sh bin/x86_64/
	cp sshpass/sshpass bin/x86_64/
	cp stress-ng/stress-ng bin/x86_64/
	cp sysstat/mpstat bin/x86_64/
	cp sysstat/iostat bin/x86_64/
	cp sysstat/sar bin/x86_64/
	cp sysstat/sadc bin/x86_64/
	cp tsc/tsc bin/x86_64/
ifeq ($(shell uname -m),x86_64)
	cp linux_turbostat/tools/power/x86/turbostat/turbostat bin/x86_64/
endif
	cd bin/x86_64 && strip --strip-unneeded *

tools-aarch64: async-profiler-aarch64 dmidecode-aarch64 ethtool-aarch64 fio-aarch64 ipmitool-aarch64 lshw-aarch64 lspci-aarch64 spectre-meltdown-checker sshpass-aarch64 stackcollapse-perf-aarch64 stress-ng-aarch64 sysstat-aarch64 tsc-aarch64
	mkdir -p bin/aarch64
	cp -R async-profiler-aarch64 bin/aarch64/async-profiler
	cp dmidecode-aarch64/dmidecode bin/aarch64/
	cp ethtool-aarch64/ethtool bin/aarch64/
	cp fio-aarch64/fio bin/aarch64/	
	cp stackcollapse-perf/stackcollapse-perf-aarch64 bin/aarch64/stackcollapse-perf
	cp ipmitool-aarch64/src/ipmitool.static bin/aarch64/ipmitool
	cp lshw-aarch64/src/lshw-static bin/aarch64/lshw
	cp lspci-aarch64/lspci bin/aarch64/
	cp lspci-aarch64/pci.ids.gz bin/aarch64/
	cp perf-archive/perf-archive.sh bin/aarch64/perf-archive && chmod +rx bin/aarch64/perf-archive
	cp spectre-meltdown-checker/spectre-meltdown-checker.sh bin/aarch64/
	cp sshpass-aarch64/sshpass bin/aarch64/
	cp stress-ng-aarch64/stress-ng bin/aarch64/
	cp sysstat-aarch64/mpstat bin/aarch64/
	cp sysstat-aarch64/iostat bin/aarch64/
	cp sysstat-aarch64/sar bin/aarch64/
	cp sysstat-aarch64/sadc bin/aarch64/
	cp tsc/tsc-aarch64 bin/aarch64/tsc
	-cd bin/aarch64 && aarch64-linux-gnu-strip --strip-unneeded * || true

tools-riscv64:
	@echo "=== Building PerfSpect tools for RISC-V ==="
	mkdir -p bin/riscv64

	@echo "Skipping async-profiler for RISC-V (not supported)"
	@echo "Skipping dmidecode for RISC-V (not supported)"
	@echo "Skipping ethtool for RISC-V (not supported)"
	@echo "Skipping ipmitool for RISC-V (not supported)"
	@echo "Skipping lshw for RISC-V (not supported)"
	@echo "Skipping lspci for RISC-V (not supported)"

	# Copy tools that exist (ignore missing ones)
	@if [ -f fio/fio ]; then cp fio/fio bin/riscv64/ || true; fi
	@if [ -f stackcollapse-perf/stackcollapse-perf ]; then cp stackcollapse-perf/stackcollapse-perf bin/riscv64/ || true; fi
	@if [ -f stress-ng/stress-ng ]; then cp stress-ng/stress-ng bin/riscv64/ || true; fi
	@if [ -f sysstat/mpstat ]; then cp sysstat/mpstat bin/riscv64/ || true; fi
	@if [ -f sysstat/iostat ]; then cp sysstat/iostat bin/riscv64/ || true; fi
	@if [ -f sysstat/sar ]; then cp sysstat/sar bin/riscv64/ || true; fi
	@if [ -f sysstat/sadc ]; then cp sysstat/sadc bin/riscv64/ || true; fi
	@if [ -f tsc/tsc ]; then cp tsc/tsc bin/riscv64/ || true; fi
	@if [ -f sshpass/sshpass ]; then cp sshpass/sshpass bin/riscv64/ || true; fi
	@if [ -f perf-archive/perf-archive.sh ]; then cp perf-archive/perf-archive.sh bin/riscv64/perf-archive && chmod +x bin/riscv64/perf-archive || true; fi
	@if [ -f spectre-meltdown-checker/spectre-meltdown-checker.sh ]; then cp spectre-meltdown-checker/spectre-meltdown-checker.sh bin/riscv64/ || true; fi

	@echo "=== RISC-V tools build complete ==="

tools: tools-x86_64 tools-aarch64 tools-riscv64 
	@echo "Tools built successfully in bin/x86_64 and bin/aarch64 and bin/riscv64 directories."

ASYNC_PROFILER_VERSION := "4.0"
async-profiler:
ifeq ("$(wildcard async-profiler)","")
ifeq ("$(wildcard async-profiler-$(ASYNC_PROFILER_VERSION)-linux-x64.tar.gz)","")
	wget https://github.com/async-profiler/async-profiler/releases/download/v$(ASYNC_PROFILER_VERSION)/async-profiler-$(ASYNC_PROFILER_VERSION)-linux-x64.tar.gz
endif
	tar -xf async-profiler-$(ASYNC_PROFILER_VERSION)-linux-x64.tar.gz && mv async-profiler-$(ASYNC_PROFILER_VERSION)-linux-x64 async-profiler
endif

async-profiler-aarch64:
ifeq ("$(wildcard async-profiler-aarch64)","")
ifeq ("$(wildcard async-profiler-$(ASYNC_PROFILER_VERSION)-linux-arm64.tar.gz)","")
	wget https://github.com/async-profiler/async-profiler/releases/download/v$(ASYNC_PROFILER_VERSION)/async-profiler-$(ASYNC_PROFILER_VERSION)-linux-arm64.tar.gz
endif
	tar -xf async-profiler-$(ASYNC_PROFILER_VERSION)-linux-arm64.tar.gz && mv async-profiler-$(ASYNC_PROFILER_VERSION)-linux-arm64 async-profiler-aarch64
endif

async-profiler-riscv64:
	@echo "Skipping async-profiler for RISC-V (not supported)"

AVX_TURBO_VERSION := "9cfe8bf"
avx-turbo:
ifeq ($(shell uname -m),x86_64)
ifeq ("$(wildcard avx-turbo)","")
	git clone https://github.com/travisdowns/avx-turbo.git
else
	cd avx-turbo && git checkout master && git pull
endif
	cd avx-turbo && git checkout $(AVX_TURBO_VERSION)
	# apply our patches to avx-turbo, aperf/mperf first because it doesn't add/remove any lines
	cd avx-turbo && git apply ../avx-turbo-patches/0001-use-fixed-CPU-number-to-determine-if-APERF-MPERF-are.patch
	cd avx-turbo && git apply ../avx-turbo-patches/0001-Add-CPU-ID-pinning-option.patch
	cd avx-turbo && make
else
	@echo "Skipping avx-turbo build on non-x86_64 architecture ($(shell uname -m))."
endif

# if you change the version, check the sed hacks below
CPUID_VERSION := "20250513"
cpuid:
ifeq ($(shell uname -m),x86_64)
ifeq ("$(wildcard cpuid)","")
ifeq ("$(wildcard cpuid-$(CPUID_VERSION).src.tar.gz)","")
	wget http://www.etallen.com/cpuid/cpuid-$(CPUID_VERSION).src.tar.gz
endif	
	tar -xf cpuid-$(CPUID_VERSION).src.tar.gz && mv cpuid-$(CPUID_VERSION)/ cpuid/
endif	
	# gcc 4.8 doesn't support -Wimplicit-fallthrough option
	cd cpuid && sed -i s/"-Wimplicit-fallthrough"/""/ Makefile
	cd cpuid && make
else
	@echo "Skipping cpuid build on non-x86_64 architecture ($(shell uname -m))."
endif

DMIDECODE_VERSION := "dmidecode-3-5"
dmidecode:
ifeq ("$(wildcard dmidecode)","")
	git clone https://github.com/mirror/dmidecode.git
else
	cd dmidecode && git checkout master && git pull
endif
	cd dmidecode && git checkout $(DMIDECODE_VERSION)
	cd dmidecode && make -j$(NPROC)

dmidecode-aarch64:
ifeq ("$(wildcard dmidecode-aarch64)","")
	git clone https://github.com/mirror/dmidecode.git dmidecode-aarch64
else
	cd dmidecode-aarch64 && git checkout master && git pull
endif
	cd dmidecode-aarch64 && git checkout $(DMIDECODE_VERSION)
	cd dmidecode-aarch64 && CC=aarch64-linux-gnu-gcc make -j$(NPROC)

dmidecode-riscv64:
	@echo "Skipping dmidecode for RISC-V (not supported)"

ETHTOOL_VERSION := "v6.5"
ethtool:
ifeq ("$(wildcard ethtool)","")
	git clone https://git.kernel.org/pub/scm/network/ethtool/ethtool.git
else
	cd ethtool && git checkout master && git pull
endif
	cd ethtool && git checkout $(ETHTOOL_VERSION)
ifeq ("$(wildcard ethtool/Makefile)","")
	cd ethtool && ./autogen.sh && ./configure enable_netlink=no
endif
	cd ethtool && make -j$(NPROC)

ethtool-aarch64:
ifeq ("$(wildcard ethtool-aarch64)","")
	git clone https://git.kernel.org/pub/scm/network/ethtool/ethtool.git ethtool-aarch64
else
	cd ethtool-aarch64 && git checkout master && git pull
endif
	cd ethtool-aarch64 && git checkout $(ETHTOOL_VERSION)
ifeq ("$(wildcard ethtool-aarch64/Makefile)","")
	cd ethtool-aarch64 && ./autogen.sh && ./configure --host aarch64-linux-gnu enable_netlink=no
endif
	cd ethtool-aarch64 && make -j$(NPROC)

ethtool-riscv64:
	@echo "Skipping ethtool for RISC-V (not supported)"

FIO_VERSION := "fio-3.38"
fio:
ifeq ("$(wildcard fio)","")
	git clone https://github.com/axboe/fio.git
else
	cd fio && git checkout master && git pull
endif
	cd fio && git checkout $(FIO_VERSION)
ifeq ("$(wildcard fio/config.log)","")
	cd fio && ./configure --build-static --disable-native
endif
	cd fio && make -j$(NPROC)

fio-aarch64:
ifeq ("$(wildcard fio-aarch64)","")
	git clone https://github.com/axboe/fio.git fio-aarch64
else
	cd fio-aarch64 && git checkout master && git pull
endif
	cd fio-aarch64 && git checkout $(FIO_VERSION)
ifeq ("$(wildcard fio-aarch64/config.log)","")
	cd fio-aarch64 && ./configure --build-static --disable-native --cc=aarch64-linux-gnu-gcc
endif
	cd fio-aarch64 && make -j$(NPROC)

IPMITOOL_VERSION := "IPMITOOL_1_8_19"
ipmitool:
ifeq ("$(wildcard ipmitool)","")
	git clone https://github.com/ipmitool/ipmitool.git
endif
	cd ipmitool && git checkout $(IPMITOOL_VERSION)
ifeq ("$(wildcard ipmitool/Makefile)","")
	# hack to get around static build problem - don't check for libreadline
	sed -i "s#x\$$xenable_ipmishell#xno#" ipmitool/configure.ac
	cd ipmitool && ./bootstrap && LDFLAGS=-static ./configure
endif
	cd ipmitool && make -j$(NPROC)
	cd ipmitool/src && ../libtool --silent --tag=CC --mode=link gcc -fno-strict-aliasing -Wreturn-type -all-static -o ipmitool.static ipmitool.o ipmishell.o ../lib/libipmitool.la plugins/libintf.la

ipmitool-aarch64:
ifeq ("$(wildcard ipmitool-aarch64)","")
	git clone https://github.com/ipmitool/ipmitool.git ipmitool-aarch64
endif
	cd ipmitool-aarch64 && git checkout $(IPMITOOL_VERSION)
ifeq ("$(wildcard ipmitool-aarch64/Makefile)","")
	# hack to get around static build problem - don't check for libreadline
	sed -i "s#x\$$xenable_ipmishell#xno#" ipmitool-aarch64/configure.ac
	cd ipmitool-aarch64 && ./bootstrap && LDFLAGS=-static ./configure --host=aarch64-linux-gnu
endif
	cd ipmitool-aarch64 && CC=aarch64-linux-gnu-gcc make -j$(NPROC)
	cd ipmitool-aarch64/src && ../libtool --silent --tag=CC --mode=link aarch64-linux-gnu-gcc -fno-strict-aliasing -Wreturn-type -all-static -o ipmitool.static ipmitool.o ipmishell.o ../lib/libipmitool.la plugins/libintf.la

ipmitool-riscv64:
	@echo "Skipping ipmitool for RISC-V (requires IPMI kernel support)"

LSHW_VERSION := "B.02.19"
lshw:
ifeq ("$(wildcard lshw)","")
	git clone https://github.com/lyonel/lshw.git
else
	cd lshw && git checkout master && git pull
endif
	cd lshw && git checkout $(LSHW_VERSION)
	cd lshw/src && make static

lshw-aarch64:
ifeq ("$(wildcard lshw-aarch64)","")
	git clone https://github.com/lyonel/lshw.git lshw-aarch64
else
	cd lshw-aarch64 && git checkout master && git pull
endif
	cd lshw-aarch64 && git checkout $(LSHW_VERSION)
	cd lshw-aarch64/src && STRIP=aarch64-linux-gnu-strip CXX=aarch64-linux-gnu-g++ make static

lshw-riscv64:
	@echo "Skipping lshw for RISC-V (unsupported arch)"

LSPCI_VERSION := "v3.13.0"
lspci:
ifeq ("$(wildcard lspci)","")
	git clone https://github.com/pciutils/pciutils.git lspci
else
	cd lspci && git checkout master && git pull
endif
	cd lspci && git checkout $(LSPCI_VERSION)
	cd lspci && make -j$(NPROC)
	cd lspci && ./update-pciids.sh
	cd lspci && gzip -c pci.ids > pci.ids.gz

lspci-aarch64:
ifeq ("$(wildcard lspci-aarch64)","")
	git clone https://github.com/pciutils/pciutils.git lspci-aarch64
else
	cd lspci-aarch64 && git checkout master && git pull
endif
	cd lspci-aarch64 && git checkout $(LSPCI_VERSION)
	cd lspci-aarch64 && sed -i '/cpu=.*/cpu=aarch64/g' lib/configure
	cd lspci-aarch64 && sed -i 's/^CROSS_COMPILE=/CROSS_COMPILE?=/g' Makefile
	cd lspci-aarch64 && sed -i 's/^SHARED=/SHARED?=/g' Makefile
	cd lspci-aarch64 && CROSS_COMPILE=aarch64-linux-gnu- SHARED=no make -j$(NPROC)
	cd lspci-aarch64 && ./update-pciids.sh
	cd lspci-aarch64 && gzip -c pci.ids > pci.ids.gz

lspci-riscv64:
	@echo "Skipping lspci for RISC-V (depends on PCI subsystem)"

MSR_TOOLS_VERSION := "master"
msr-tools:
ifeq ("$(wildcard msr-tools)","")
	git clone https://github.com/intel/msr-tools.git
else
	cd msr-tools && git checkout master && git pull
endif
	cd msr-tools && git checkout $(MSR_TOOLS_VERSION) && git pull
	cd msr-tools && ./autogen.sh && make

msr-tools-riscv64:
	@echo "Skipping msr-tools for RISC-V (x86 MSR only)"

PCM_VERSION := "202502"
pcm:
ifeq ($(shell uname -m),x86_64)
ifeq ("$(wildcard pcm)","")
	git clone --recursive https://github.com/intel/pcm.git
else
	cd pcm && git checkout master && git pull
endif
	cd pcm && git checkout $(PCM_VERSION)
	mkdir -p pcm/build
	sed -i 's/-mno-omit-leaf-frame-pointer//g' pcm/CMakeLists.txt
	cd pcm/build && cmake -DNO_ASAN=1 -DCMAKE_CXX_FLAGS="-fno-omit-frame-pointer" ..
	cd pcm/build && cmake --build .
else
	@echo "Skipping PCM build — not supported on $(shell uname -m)"
endif

pcm-riscv64:
	@echo "Skipping pcm for RISC-V (Intel Performance Counter Monitor, x86-only)"

PERF_VERSION := "6.15.3"
perf-x86_64:
	wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$(PERF_VERSION).tar.xz
	tar -xf linux-$(PERF_VERSION).tar.xz && mv linux-$(PERF_VERSION)/ linux_perf/
	cd linux_perf/tools/perf && make LLVM_CONFIG="llvm-config --link-static" LDFLAGS="-static --static" BUILD_BPF_SKEL=1 NO_JVMTI=1 BUILD_NONDISTRO=1 LIBUNWIND=1 -j$(NPROC)
	mkdir -p bin/x86_64
	cp linux_perf/tools/perf/perf bin/x86_64/
	strip --strip-unneeded bin/x86_64/perf

perf-aarch64:
ifeq ("$(wildcard perf-aarch64)","")
	wget -N https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$(PERF_VERSION).tar.xz
	tar -xf linux-$(PERF_VERSION).tar.xz && mv linux-$(PERF_VERSION)/ linux_perf-aarch64/
endif
	cd linux_perf-aarch64/tools/perf && make LDFLAGS="-static --static" BUILD_BPF_SKEL=1 NO_JVMTI=1 ARCH=arm64 NO_LIBTRACEEVENT=1 CROSS_COMPILE=aarch64-linux-gnu- -j$(NPROC)
	mkdir -p bin/aarch64
	cp linux_perf-aarch64/tools/perf/perf bin/aarch64/
	aarch64-linux-gnu-strip --strip-unneeded bin/aarch64/perf

perf-riscv64:
ifeq ("$(wildcard perf-riscv64)","")
		wget -N https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$(PERF_VERSION).tar.xz
		tar -xf linux-$(PERF_VERSION).tar.xz && mv linux-$(PERF_VERSION)/ linux_perf-riscv64/
endif
		cd linux_perf-riscv64/tools/perf && make LDFLAGS="-static --static" BUILD_BPF_SKEL=1 NO_JVMTI=1 ARCH=riscv NO_LIBTRACEEVENT=1 -j$(NPROC)
		mkdir -p bin/riscv64
		cp linux_perf-riscv64/tools/perf/perf bin/riscv64/
		strip --strip-unneeded bin/riscv64/perf

perf: perf-x86_64 perf-aarch64 perf-riscv64
	@echo "Perf tools built successfully in bin/x86_64 and bin/aarch64 and bin/riscv64 directories."

PROCESSWATCH_VERSION := "c394065"	
processwatch:
ifeq ("$(wildcard processwatch)","")
	git clone --recursive https://github.com/intel/processwatch.git
else
	cd processwatch && git checkout main && git pull
endif
	cd processwatch && git checkout $(PROCESSWATCH_VERSION)
	cd processwatch && ./build.sh
	mkdir -p bin
	cp processwatch/processwatch bin/x86_64/
	strip --strip-unneeded bin/x86_64/processwatch

SPECTRE_MELTDOWN_CHECKER_VERSION := "master"
spectre-meltdown-checker:
ifeq ("$(wildcard spectre-meltdown-checker)","")
	git clone https://github.com/speed47/spectre-meltdown-checker.git
else
	cd spectre-meltdown-checker && git checkout master && git pull
endif
	cd spectre-meltdown-checker && git checkout $(SPECTRE_MELTDOWN_CHECKER_VERSION) && git pull

spectre-meltdown-checker-riscv64:
	@echo "Skipping spectre-meltdown-checker for RISC-V (x86-specific mitigations)"

SSHPASS_VERSION := "1.10"
sshpass:
ifeq ("$(wildcard sshpass)","")
	wget https://sourceforge.net/projects/sshpass/files/sshpass/$(SSHPASS_VERSION)/sshpass-$(SSHPASS_VERSION).tar.gz
	tar -xf sshpass-$(SSHPASS_VERSION).tar.gz
	mv sshpass-$(SSHPASS_VERSION) sshpass
	rm sshpass-$(SSHPASS_VERSION).tar.gz
	cd sshpass && ./configure
endif
	cd sshpass && make -j$(NPROC)

sshpass-aarch64:
ifeq ("$(wildcard sshpass-aarch64)","")
	wget https://sourceforge.net/projects/sshpass/files/sshpass/$(SSHPASS_VERSION)/sshpass-$(SSHPASS_VERSION).tar.gz
	tar -xf sshpass-$(SSHPASS_VERSION).tar.gz
	mv sshpass-$(SSHPASS_VERSION) sshpass-aarch64
	rm sshpass-$(SSHPASS_VERSION).tar.gz
	cd sshpass-aarch64 && ./configure --host=aarch64-linux-gnu
endif
	cd sshpass-aarch64 && make -j$(NPROC)

stackcollapse-perf:
	cd stackcollapse-perf && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build

stackcollapse-perf-aarch64:
	cd stackcollapse-perf && CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o $@

STRESS_NG_VERSION := "V0.13.08"
stress-ng:
ifeq ("$(wildcard stress-ng)","")
	git clone https://github.com/ColinIanKing/stress-ng.git
else
	cd stress-ng && git checkout master && git pull
endif
	cd stress-ng && git checkout $(STRESS_NG_VERSION)
	cd stress-ng && STATIC=1 make -j$(NPROC)

stress-ng-aarch64:
ifeq ("$(wildcard stress-ng-aarch64)","")
	git clone https://github.com/ColinIanKing/stress-ng.git stress-ng-aarch64
else
	cd stress-ng-aarch64 && git checkout master && git pull
endif
	cd stress-ng-aarch64 && git checkout $(STRESS_NG_VERSION)
	cd stress-ng-aarch64 && CC=aarch64-linux-gnu-gcc STATIC=1 make -j$(NPROC)

SYSSTAT_VERSION := "v12.7.6"
sysstat:
ifeq ("$(wildcard sysstat)","")
	git clone https://github.com/sysstat/sysstat.git
else
	cd sysstat && git checkout master && git pull
endif
	cd sysstat && git checkout $(SYSSTAT_VERSION)
ifeq ("$(wildcard sysstat/Makefile)","")
	cd sysstat && ./configure
endif
	cd sysstat && make -j$(NPROC)

sysstat-aarch64:
ifeq ("$(wildcard sysstat-aarch64)","")
	git clone https://github.com/sysstat/sysstat.git sysstat-aarch64
else
	cd sysstat-aarch64 && git checkout master && git pull
endif
	cd sysstat-aarch64 && git checkout $(SYSSTAT_VERSION)
ifeq ("$(wildcard sysstat-aarch64/Makefile)","")
	cd sysstat-aarch64 && ./configure --host=aarch64-linux-gnu
endif
	cd sysstat-aarch64 && make -j$(NPROC)

tsc:
	cd tsc && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build

tsc-aarch64:
	cd tsc && CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o tsc-aarch64

TURBOSTAT_VERSION := "6.9.12"
turbostat:
ifeq ($(shell uname -m),x86_64)
	wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$(TURBOSTAT_VERSION).tar.xz
	tar -xf linux-$(TURBOSTAT_VERSION).tar.xz && mv linux-$(TURBOSTAT_VERSION)/ linux_turbostat/
	sed -i '/_Static_assert/d' linux_turbostat/tools/power/x86/turbostat/turbostat.c
	cd linux_turbostat/tools/power/x86/turbostat && make
else
	@echo "Skipping turbostat build (not x86_64 architecture)"
endif

reset:
	@if [ -d async-profiler ]; then cd async-profiler && git clean -fdx && git reset --hard; else echo "Skipping async-profiler (not present)"; fi
	@if [ -d cpuid ]; then cd cpuid && make clean; else echo "Skipping cpuid (not present)"; fi
	@if [ -d dmidecode ]; then cd dmidecode && git clean -fdx && git reset --hard; else echo "Skipping dmidecode (not present)"; fi
	@if [ -d ethtool ]; then cd ethtool && git clean -fdx && git reset --hard; else echo "Skipping ethtool (not present)"; fi
	@if [ -d fio ]; then cd fio && git clean -fdx && git reset --hard; else echo "Skipping fio (not present)"; fi
	@if [ -d ipmitool ]; then cd ipmitool && git clean -fdx && git reset --hard; else echo "Skipping ipmitool (not present)"; fi
	@if [ -d lshw ]; then cd lshw && git clean -fdx && git reset --hard; else echo "Skipping lshw (not present)"; fi
	@if [ -d lspci ]; then cd lspci && git clean -fdx && git reset --hard; else echo "Skipping lspci (not present)"; fi
	@if [ -d pcm ]; then cd pcm && git clean -fdx && git reset --hard; else echo "Skipping pcm (not present)"; fi
	@if [ -d msr-tools ]; then cd msr-tools && git clean -fdx && git reset --hard; else echo "Skipping msr-tools (not present)"; fi
	@if [ -d spectre-meltdown-checker ]; then cd spectre-meltdown-checker && git clean -fdx && git reset --hard; else echo "Skipping spectre-meltdown-checker (not present)"; fi
	@if [ -d sshpass ]; then cd sshpass && make clean; else echo "Skipping sshpass (not present)"; fi
	@if [ -d stress-ng ]; then cd stress-ng && git clean -fdx && git reset --hard; else echo "Skipping stress-ng (not present)"; fi
	@if [ -d sysstat ]; then cd sysstat && git clean -fdx && git reset --hard; else echo "Skipping sysstat (not present)"; fi
	@if [ -d tsc ]; then cd tsc && rm -f tsc; else echo "Skipping tsc (not present)"; fi
	@if [ -d linux_turbostat/tools/power/x86/turbostat ]; then cd linux_turbostat/tools/power/x86/turbostat && make clean; else echo "Skipping turbostat (not present)"; fi

#not used in build but required in oss archive file because some of the tools are statically linked
glibc-2.19.tar.bz2:
	wget http://ftp.gnu.org/gnu/glibc/glibc-2.19.tar.bz2
zlib.tar.gz:
	wget https://github.com/madler/zlib/archive/refs/heads/master.tar.gz -O zlib.tar.gz
libcrypt.tar.gz:
	wget https://github.com/gpg/libgcrypt/archive/refs/heads/master.tar.gz -O libcrypt.tar.gz
libs: glibc-2.19.tar.bz2 zlib.tar.gz libcrypt.tar.gz

oss-source: reset libs
	@dirs="async-profiler cpuid dmidecode ethtool fio ipmitool lshw lspci msr-tools perf-archive pcm spectre-meltdown-checker sshpass stress-ng sysstat linux_turbostat/tools/power/x86/turbostat"; \
	existing_dirs=$$(for d in $$dirs; do [ -d $$d ] && echo $$d; done); \
	echo "Packaging the following directories: $$existing_dirs"; \
	tar --exclude-vcs -czf oss_source.tgz $$existing_dirs glibc-2.19.tar.bz2 zlib.tar.gz libcrypt.tar.gz; \
	md5sum oss_source.tgz > oss_source.tgz.md5
