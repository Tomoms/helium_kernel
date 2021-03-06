#!/bin/bash
setenv () {
	export ARCH=arm
	export SUBARCH=arm
	export CROSS_COMPILE=/run/media/tfonda/LinuxData/android/lineage-17.1/prebuilts/gcc/linux-x86/arm/arm32-gcc/bin/arm-eabi-
}

checkenv () {
	if [[ $ARCH != "arm" ]] || [[ $SUBARCH != "arm" ]] || [[ $CROSS_COMPILE != "/run/media/tfonda/LinuxData/android/lineage-17.1/prebuilts/gcc/linux-x86/arm/arm32-gcc/bin/arm-eabi-" ]]; then
		echo "Environment variables are unset!"
		return 1
	fi
	echo "All good!"
}

fullclean () {
	setenv
	if ! checkenv; then
		echo "Aborting!"
		return 1
	fi
	echo "Performing a full clean..."
	make mrproper
}

clean () {
	setenv
	if ! checkenv; then
		echo "Aborting!"
		return 1
	fi
	echo "Cleaning..."
	make clean
}

mkcfg () {
	setenv
	if ! checkenv; then
		echo "Aborting!"
		return 1
	fi
	if [ -f ".config" ]; then
		echo ".config exists, running make oldconfig"
		make oldconfig
	else
		echo ".config not found"
		make viskan_huashan_defconfig
	fi
}

editcfg () {
	setenv
	if ! checkenv; then
		echo "Aborting!"
		return 1
	fi
	if [ -f ".config" ]; then
		echo ".config exists"
		make nconfig
	else
		echo ".config not found, run mkcfg first!"
		return 1
	fi
}

savecfg () {
	setenv
	if ! checkenv; then
		echo "Aborting!"
		return 1
	fi
	make savedefconfig
	mv defconfig arch/arm/configs/viskan_huashan_defconfig
}

build () {
	setenv
	if ! checkenv; then
		echo "Aborting!"
		return 1
	fi
	if [ -z "$1" ]; then
		echo "No number of jobs has been passed"
		return 1
	fi
	echo "Running make..."
	make -j$1
}

mkzip () {
	if [ -z "$1" ]; then
		echo "Name of zip file is missing!"
		return 1
	fi
	cp arch/arm/boot/zImage ../AnyKernel3/
	(cd ../AnyKernel3 && zip -r ../$1 *)
}
