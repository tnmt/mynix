# Store the result of the hostname command in the HOST variable
HOST := $(shell hostname)

# Define the apply target
apply:
    # Use the HOST variable to execute the nixos-rebuild command
    sudo nixos-rebuild switch --flake .#${HOST}

.PHONY: apply
