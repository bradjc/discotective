#!/bin/sh
#
# This file was automatically generated.
#
# It can be overwritten by nios2-flash-programmer-generate or nios2-flash-programmer-gui.
#

#
# Converting Binary File: C:\discotective\software\discotective\binary_check1.bin to: "..\flash/binary_check1_cfi_flash_0.flash"
#
bin/bin2flash --input="C:/discotective/software/discotective/binary_check1.bin" --output="../flash/binary_check1_cfi_flash_0.flash" --location=0x0 --verbose 

#
# Programming File: "..\flash/binary_check1_cfi_flash_0.flash" To Device: cfi_flash_0
#
bin/nios2-flash-programmer "../flash/binary_check1_cfi_flash_0.flash" --base=0x400000 --sidp=0x1111468 --id=0x1C4 --timestamp=1301991580 --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program --verbose 

#
# Converting Binary File: C:\discotective\software\discotective\good_image2.bin to: "..\flash/good_image2_cfi_flash_0.flash"
#
bin/bin2flash --input="C:/discotective/software/discotective/good_image2.bin" --output="../flash/good_image2_cfi_flash_0.flash" --location=0xA0000 --verbose 

#
# Programming File: "..\flash/good_image2_cfi_flash_0.flash" To Device: cfi_flash_0
#
bin/nios2-flash-programmer "../flash/good_image2_cfi_flash_0.flash" --base=0x400000 --sidp=0x1111468 --id=0x1C4 --timestamp=1301991580 --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program --verbose 

#
# Converting Binary File: C:\discotective\software\discotective\good_image4.bin to: "..\flash/good_image4_cfi_flash_0.flash"
#
bin/bin2flash --input="C:/discotective/software/discotective/good_image4.bin" --output="../flash/good_image4_cfi_flash_0.flash" --location=0x140000 --verbose 

#
# Programming File: "..\flash/good_image4_cfi_flash_0.flash" To Device: cfi_flash_0
#
bin/nios2-flash-programmer "../flash/good_image4_cfi_flash_0.flash" --base=0x400000 --sidp=0x1111468 --id=0x1C4 --timestamp=1301991580 --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program --verbose 

