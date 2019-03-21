#!/bin/bash
#set -e

###########################################################################
# defuale configs.
###########################################################################
mode="r"
cmd="dmake"
ver="fullmask"
prj="p20"
sign="false"
ddr2=
SFBL=./bare_spl
SIGN=./sign
SFBL_FLAG=
flash="0"
pcba="0"
use_mti="0"
nand="0"
patch_file="board/siflower/sfa18_common/irom_patch_default.txt"

show_help() {
	echo "Usage: $0"
	echo "    prj=p10[b/m/flash]|p20[b]|wrt|evb|86v|ac|x10|p10h"
	echo "    ver=mpw0|mpw1|fullmask"
	echo "    mode=r|d"
	echo "    [cmd=dmake|distclean|clean|make]"
	echo "    [ddr=m15t1g1664a|nt5cc128m16ip]"
	echo "    [ddr2=em68b16cwqh]"
	echo "    [sign=true|false]"
	echo "    [odt=0] #disable ODT"
	echo "    [pcba=0|1]"
	echo "    [use_mti=0|1]"
	echo "    [patch_file=board/siflower/sfa18_common/irom_patch_default.txt]"
	echo "    [nand=0|1]"
	exit 0
}

add_sfbl_flag() {
	SFBL_FLAG="$SFBL_FLAG"" $@"
}

get_ddr_size() {
	local size

	case $ddr2 in
		em68b16cwqh) #64MB
			size=0x4000000;;
		hy5ps1g1631c)
			size=0x8000000;;
	esac

	# default 128MB
	[ -z $size ] && size=0x8000000

	echo $size
}

for args in $@
do
	case $args in
		prj=*)
			prj=${args##*prj=}
			;;
		mode=*)
			mode=${args##*mode=}
			;;
		cmd=*)
			cmd=${args##*cmd=}
			;;
		ver=*)
			ver=${args##*ver=}
			;;
		ddr2=*)
			ddr2=${args##*ddr2=}
			;;
		ddr=*)
			ddr=${args##*ddr=}
			;;
		sign=*)
			sign=${args##*sign=}
			;;
		odt=*)
			add_sfbl_flag $args
			;;
		flash=*)
			flash=${args##*flash=}
			;;
		pcba=*)
			pcba=${args##*pcba=}
			;;
		soft_ecc=*)
			soft_ecc=${args##*soft_ecc=}
			;;
		use_mti=*)
			use_mti=${args##*use_mti=}
			;;
		patch_file=*)
			patch_file=${args##*patch_file=}
			;;
		nand=*)
			nand=${args##*nand=}
			;;
		*)
			show_help
			exit 1
			;;
	esac
done

# Choose prefix of defconfig
case $prj in
	p20* | evb | wrt)
		DEFCONFIG="sfa18_"$ver"_p20b"
		;;
	p10b | p10)
		DEFCONFIG="sfa18_"$ver"_p10b"
		[ -z $ddr2 ] && ddr2=em68b16cwqh
		;;
	p10flash)
		DEFCONFIG="sfa18_"$ver"_p10b_flash"
		[ -z $ddr2 ] && ddr2=em68b16cwqh
		;;
	86v)
		DEFCONFIG="sfa18_"$ver"_86v"
		[ -z $ddr2 ] && ddr2=em68b16cwqh
		;;
	p10m*)
		DEFCONFIG="sfa18_"$ver"_p10m"
		[[ "$prj" == *hy ]] && ddr2=hy5ps1g1631c
		[ -z $ddr2 ] && ddr2=em68b16cwqh
		add_sfbl_flag rgmii=1
		;;
	x10)
		DEFCONFIG="sfa18_"$ver"_x10"
		[ -z $ddr2 ] && ddr2=hy5ps1g1631c
		add_sfbl_flag rgmii=1
		;;
	p10h)
		DEFCONFIG="sfa18_"$ver"_p10h"
		[ -z $ddr2 ] && ddr2=em68b16cwqh
		add_sfbl_flag rgmii=1
		;;
	a28)
		DEFCONFIG="sfa28"
		;;
	ac)
		DEFCONFIG="sfa18_"$ver"_ac"
		add_sfbl_flag rgmii=1
		add_sfbl_flag poe=1
		;;
	*)
		echo "unsupport prj $prj"
		show_help
		exit 1
		;;
esac

# Special settings of evb
[ "$prj" = "evb" ] && add_sfbl_flag skip=1

add_sfbl_flag ddr=$ddr ddr2=$ddr2 ${ver}=1


# Add suffix of defconfig
if [[ "$flash" = "1" ]] || [[ "$prj" = "p10flash" ]] || [[ "$prj" = "86v" ]]; then
	if [[ "$flash" = "1" ]]; then
		DEFCONFIG=${DEFCONFIG}_flash
	fi
	add_sfbl_flag small=1
	#enable security boot make the size of
	#spl is bigger than 32k, so disable it.
	sign="false"
	spl_max_size=32K
else
	spl_max_size=128K
fi

if [[ "$pcba" = "1" ]]; then
	DEFCONFIG=${DEFCONFIG}_pcba
fi


if [[ "$prj" = "86v" ]]; then
	add_sfbl_flag odt=0
fi

[ "$sign" = "true" ] && add_sfbl_flag "security_boot=1"

DEFCONFIG=${DEFCONFIG}_defconfig

led_no=$(grep -rn "SFA18_LED_ID" configs/${DEFCONFIG} | cut -d "=" -f2)
if [ $led_no ]; then
	add_sfbl_flag led_no=$led_no
fi

if [ "$soft_ecc" = "1" ]; then
	export SOFT_ECC=1
	echo "Identify using soft-ecc in img header!!!"
fi
case $cmd in
	distclean | clean)
		echo "siflower make $cmd starting...."
		make $cmd
		make clean -C $SFBL
		make clean -C $SIGN
		rm -rf sfax8
		exit 0
		;;
	make)
		need_clean=0
		;;
	*)
		need_clean=1
		;;
esac

if [ $need_clean -ne 0 ] ; then
	echo "siflower distclean then make uboot starting...."
	make clean -C $SFBL
	make clean -C $SIGN
	make distclean
else
	echo "siflower make uboot starting...."
fi

if [[ "$use_mti" = "1" ]]; then
toolchain=mips-mti-linux-gnu-
add_sfbl_flag use_mti=1
else
PWD=`pwd`
toolchain=$PWD/toolchain/mips/bin/mipsel-openwrt-linux-uclibc-
STAGING_DIR=$PWD
export STAGING_DIR
fi

add_sfbl_flag irom_patch=$patch_file
add_sfbl_flag spi_nand=$nand

echo "prj=$prj"
echo "mode=$mode"
echo "cmd=$cmd"
echo "DEFCONFIG=$DEFCONFIG"
echo "SFBL_FLAG=$SFBL_FLAG"
echo "toolchain=$toolchain"

# compile bare_spl
make -C $SFBL $SFBL_FLAG
cp -f $SFBL/irom_spl.img ./u-boot-spl.img

# compile uboot
make $DEFCONFIG

[ "$mode" == "d" ] && sed -i 's/.*CONFIG_OF_EMBED.*/CONFIG_OF_EMBED=y/g' .config
[ "$prj" != "evb" ] && sed -i 's/.*CONFIG_SYS_EXTRA_OPTIONS.*/CONFIG_SYS_EXTRA_OPTIONS="SPI_BOOT"/g' .config
# Modify memory size
[ "$ddr2" = "em68b16cwqh" -o "$ddr2" = "hy5ps1g1631c" ] && sed -i "s/.*CONFIG_SYS_MEM_SIZE.*/CONFIG_SYS_MEM_SIZE=`get_ddr_size`/g" .config

make CROSS_COMPILE=$toolchain -j8
#make CROSS_COMPILE=mipsel-openwrt-linux-uclibc- -j8

if [ "$sign" == "true" ] ;then
	make sign -C $SIGN
	make verify -C $SIGN

	$SIGN/sign $SIGN/private.key ./u-boot.bin $SIGN/sign.bin
	$SIGN/verify $SIGN/pub.key ./u-boot.bin $SIGN/sign.bin $SIGN/pubkey.bin
	cat ./u-boot.bin $SIGN/sign.bin $SIGN/pubkey.bin > ./u-boot-sign.bin
	./tools/mkimage -A mips -T firmware -C none -O u-boot -a 0xa0000000 -e 0xa0000000 -n "U-Boot 2016.07-rc2-00014-signed" -d ./u-boot-sign.bin ./u-boot-sign.img
fi

rm -rf sfax8
mkdir sfax8

cp ./u-boot-spl.img sfax8
if [ "$sign" == "false" ]; then
cp ./u-boot.img sfax8/
else
cp ./u-boot-sign.img sfax8/u-boot.img
fi

# build up uboot_full.img
dd if=/dev/zero of=./sfax8/zero.bin bs=$spl_max_size count=1
cat ./sfax8/u-boot-spl.img ./sfax8/zero.bin > ./sfax8/spl_tmp.img
dd if=./sfax8/spl_tmp.img of=./sfax8/spl_full.img bs=$spl_max_size count=1
cat ./sfax8/spl_full.img ./sfax8/u-boot.img > ./sfax8/uboot_full.img
rm -rf ./sfax8/zero.bin ./sfax8/spl_tmp.img ./sfax8/spl_full.img

cp ./sfax8/uboot_full.img ./sfax8/$prj.img
