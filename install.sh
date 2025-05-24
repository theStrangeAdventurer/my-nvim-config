#!/bin/sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


# Check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

echo "${GREEN}Installing LSP servers...${NC}"

OS="$(uname -s)"

# Installing clangd
if [ "$OS" = "Darwin" ]; then
  echo "${GREEN}Detected macOS${NC}"
  if ! command_exists brew; then
    echo "${RED}Error: Homebrew required. Install from https://brew.sh/${NC}"
    exit 1
  fi
  brew install llvm

elif [ "$OS" = "Linux" ]; then
	if ! command_exists apt; then
		echo "Install clangd using the instructions here: https://clangd.llvm.org/installation"
	else
		sudo apt install clangd
	fi
else
  echo "${RED}Error: Unsupported OS: $OS${NC}"
  exit 1
fi

if [ "$OS" = "Darwin" ]; then
  echo "${GREEN}Detected macOS${NC}"
  brew install lua-language-server

elif [ "$OS" = "Linux" ]; then
  echo "${GREEN}Detected Linux${NC}"
  echo "${YELLOW}Installing from source${NC}"
	# Create installation directory
	INSTALL_DIR="$HOME/.lua-ls"
	mkdir -p "$INSTALL_DIR"
	cd "$INSTALL_DIR"

	# Download latest release
	echo "${YELLOW}Downloading latest release...${NC}"
	LATEST_URL=$(curl -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | grep "browser_download_url.*linux-x64.tar.gz" | cut -d '"' -f 4)
	curl -L "$LATEST_URL" | tar xz

	# Create symlink
	echo "${YELLOW}Creating symlink...${NC}"
	sudo ln -sf "$INSTALL_DIR/bin/lua-language-server" /usr/local/bin/lua-language-server

	# Verify installation
	if command -v lua-language-server >/dev/null; then
		echo "${GREEN}Success! Version: $(lua-language-server --version)${NC}"
		echo "Installed to: $INSTALL_DIR"
		echo "Symlink created: /usr/local/bin/lua-language-server"
	else
		echo "${RED}Installation failed${NC}"
		exit 1
	fi
else
  echo "${RED}Error: Unsupported OS: $OS${NC}"
  exit 1
fi

if command_exists lua-language-server; then
  echo "${GREEN}Success!: $(which lua-language-server)${NC}"
else
  echo "${RED}Error: Installation failed${NC}"
  exit 1
fi

npm i -g typescript-language-server
# https://github.com/hrsh7th/vscode-langservers-extracted
npm i -g vscode-langservers-extracted
npm i -g vscode-json-languageserver
npm i -g bash-language-server

echo "${GREEN}Installation complete${NC}"

