
# Customs
alias h="history"

# Find location of largest files (GBs only)
alias chksize="sudo du -h -d 1 / | grep '[0-9]\+G'"

# ReMount the sandisk /usr/src
alias src="sh ~/App/remount_src.sh"

# Mount SDcard (ExFat)
alias exfat="sudo mount.exfat-fuse /dev/mmcblk2p1 /mnt/exfat && xdg-open /mnt/exfat"
