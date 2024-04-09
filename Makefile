# Store the result of the hostname command in the HOST variable
HOST := $(shell hostname)

# Define the apply target
apply:
	@echo "Running nixos-rebuild switch --flake .#${HOST}"
	@sudo nixos-rebuild switch --flake .#${HOST}

# Define the make work target
work_apply:
	@echo "Running make darwin_apply HOST=work"
	@make darwin_apply HOST=work

# Define the make goldmoon target
goldmoon_apply:
	@echo "Running make darwin_apply HOST=goldmoon"
	@make darwin_apply HOST=goldmoon

# Define the make darwin target
darwin_apply:
	@echo "Running nix build .#darwinConfigurations.${HOST}.system --extra-experimental-features 'nix-command flakes' --debug"
	@echo "Running ./result/sw/bin/darwin-rebuild switch --flake '.#${HOST}'"
	@nix build .#darwinConfigurations.${HOST}.system --extra-experimental-features 'nix-command flakes' --debug
	@./result/sw/bin/darwin-rebuild switch --flake ".#${HOST}"

.PHONY: apply work_apply goldmoon_apply darwin_apply
