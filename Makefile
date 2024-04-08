# Store the result of the hostname command in the HOST variable
HOST := $(shell hostname)

# Define the apply target
apply:
	@echo "Running nixos-rebuild switch --flake .#${HOST}"
	@sudo nixos-rebuild switch --flake .#${HOST}

.PHONY: apply
