cmd_/home/robert/chaos_calmer/build_dir/toolchain-mipsel_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/linux-dev//include/linux/byteorder/.install := bash scripts/headers_install.sh /home/robert/chaos_calmer/build_dir/toolchain-mipsel_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/linux-dev//include/linux/byteorder ./include/uapi/linux/byteorder big_endian.h little_endian.h; bash scripts/headers_install.sh /home/robert/chaos_calmer/build_dir/toolchain-mipsel_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/linux-dev//include/linux/byteorder ./include/linux/byteorder ; bash scripts/headers_install.sh /home/robert/chaos_calmer/build_dir/toolchain-mipsel_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/linux-dev//include/linux/byteorder ./include/generated/uapi/linux/byteorder ; for F in ; do echo "\#include <asm-generic/$$F>" > /home/robert/chaos_calmer/build_dir/toolchain-mipsel_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/linux-dev//include/linux/byteorder/$$F; done; touch /home/robert/chaos_calmer/build_dir/toolchain-mipsel_mips32_gcc-4.8-linaro_uClibc-0.9.33.2/linux-dev//include/linux/byteorder/.install
