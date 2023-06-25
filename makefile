.PHONY: all clean

# Disable a bunch of unneeded implicit rules
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules

all: random-pairs

NAME = $(shell swift package describe --type json | jq -r '.name')
SWIFT_BUILD_FLAGS = --configuration release
SOURCES = $(shell find Sources -type f -name "*.swift" | sed 's: :\\ :g')
BINARY = $(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)/$(NAME)
random-pairs: Package.swift Package.resolved $(SOURCES)
	swift build $(SWIFT_BUILD_FLAGS)
	ln -Ffsv "$(BINARY)" random-pairs
	touch "$(BINARY)"

COMPLETIONS_DIR = .build/completions
completions: random-pairs
	mkdir -p "$(COMPLETIONS_DIR)"
	"$(BINARY)" --generate-completion-script zsh > "$(COMPLETIONS_DIR)/zsh"
	sed -i '' 's/--excluding:excluding:/--excluding:*:excluding:/g' "$(COMPLETIONS_DIR)/zsh"
	cp "$(COMPLETIONS_DIR)/zsh" "$(ZSH)/completions/_$(NAME)"

readme: random-pairs
	perl -i -0pe "s/## Details\n\`\`\`(.|\n)*?\`\`\`/## Details\n\`\`\`\n$$("$(BINARY)" help)\n\`\`\`/g" README.md

clean: 
	rm -rf .build
	rm -f random-pairs
