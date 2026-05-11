{
	inputs = {
		flake-parts.url = "github:hercules-ci/flake-parts";

		import-tree.url = "github:vic/import-tree";

		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
		
		hyprland.url = "github:hyprwm/Hyprland/?tag=v0.55.0";

		fsel.url = "github:Mjoyufull/fsel/?tag=3.4.1";
	};

	outputs = { ... }@inputs: let
		systems = [ "x86_64-linux" ];
	in inputs.flake-parts.lib.mkFlake
		{ inherit inputs; }
		{
			imports = [
				({ ... }: {
					perSystem = { system, ... }: {
						_module.args.pkgs = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
					};
				})

				(inputs.import-tree ./modules)
			];

			inherit systems;
		};


}
