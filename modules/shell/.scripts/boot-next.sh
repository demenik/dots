cleanup() {
  efibootmgr &>/dev/null
  exit 1
}
trap cleanup SIGINT

if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root to modify EFI variables."
  exit 1
fi

if [ -z "$1" ]; then
  echo "Usage: $0 <search-term>"
  echo "Example: $0 windows"
  echo "Available boot entries:"
  efibootmgr | grep "Boot[0-9]"
  exit 1
fi

SEARCH_TERM="$1"
ENTRY_LINE=$(efibootmgr | grep -i "$SEARCH_TERM" | grep "Boot[0-9]" | head -n 1)

if [ -z "$ENTRY_LINE" ]; then
  echo "Error: No boot entry found matching '$SEARCH_TERM'."
  echo "Available boot entries:"
  efibootmgr | grep "Boot[0-9]"
  exit 1
fi

BOOT_ID=$(echo "$ENTRY_LINE" | awk '{print $1}' | sed 's/Boot//' | sed 's/\*//')
ENTRY_NAME=$(echo "$ENTRY_LINE" | sed 's/^Boot[0-9A-F]*\*\s*//' | sed -E 's/\s+HD\(.*//' | sed -E 's/\s+PciRoot\(.*//')
echo "Found entry: '$ENTRY_NAME' (ID: $BOOT_ID)"

if efibootmgr -n "$BOOT_ID" &>/dev/null; then
  echo "Booting into $ENTRY_NAME in 3 seconds..."
  echo "Press Ctrl+C to CANCEL."
  sleep 3
  reboot now
else
  echo "Error: Failed to set BootNext via efibootmgr."
  exit 1
fi
