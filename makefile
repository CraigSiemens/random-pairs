.PHONY: all clean

# Disable a bunch of unneeded implicit rules
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules

all: random-pairs

NAME = $(shell swift package describe --type json | jq -r '.name')
SWIFT_BUILD_FLAGS = --disable-sandbox --configuration release
SOURCES = $(shell find Sources -type f -name "*.swift" | sed 's: :\\ :g')
BINARY = $(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)/$(NAME)
random-pairs: Package.swift Package.resolved $(SOURCES)
	swift build $(SWIFT_BUILD_FLAGS)
	ln -Ffsv "$(BINARY)" random-pairs
	touch "$(BINARY)"

COMPLETIONS_DIR = .build/completions
completions: random-pairs
	mkdir -p "$(COMPLETIONS_DIR)"

	# Workaround for https://github.com/apple/swift-argument-parser/issues/564
	"$(BINARY)" --generate-completion-script zsh > "$(COMPLETIONS_DIR)/zsh"
	sed -i '' 's/--excluding:excluding:/--excluding:*:excluding:/g' "$(COMPLETIONS_DIR)/zsh"
	cp "$(COMPLETIONS_DIR)/zsh" "$(ZSH)/completions/_$(NAME)"

	"$(BINARY)" --generate-completion-script bash > "$(COMPLETIONS_DIR)/bash"
	"$(BINARY)" --generate-completion-script fish > "$(COMPLETIONS_DIR)/fish"

readme: random-pairs
	perl -i -0pe "s/## Details\n\`\`\`(.|\n)*?\`\`\`/## Details\n\`\`\`\n$$("$(BINARY)" help)\n\`\`\`/g" README.md

clean: 
	rm -rf .build
	rm -f random-pairs

MAIN_BRANCH=main
push-version:
ifneq ($(strip $(shell git status --untracked-files=no --porcelain 2>/dev/null)),)
	$(error git state is not clean)
endif
ifneq ($(strip $(shell git branch --show-current)),$(MAIN_BRANCH))
	$(error not on branch $(MAIN_BRANCH))
endif
	$(eval NEW_VERSION := $(filter-out $@,$(MAKECMDGOALS)))
	echo "let version = \"$(NEW_VERSION)\"" > Sources/RandomPairs/Utilities/Version.swift
	make readme
	git commit -a -m "Release $(NEW_VERSION)"
	git tag -a $(NEW_VERSION) -m "Release $(NEW_VERSION)"
	git push origin $(MAIN_BRANCH)
	git push origin $(NEW_VERSION)
	gh release create $(NEW_VERSION) --generate-notes
%:
	@:
