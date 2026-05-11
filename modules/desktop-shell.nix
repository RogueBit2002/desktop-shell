{ self, inputs, ... }: {
	perSystem = { config, pkgs, system, ... }: {
		apps.desktop-shell = { type = "app"; program = config.packages.desktop-shell; };
		
		packages.desktop-shell = pkgs.callPackage
			({ kitty, uwsm, hyprland, xwayland }: let
				
				lua-wrapper = pkgs.writeText "desktop-shell.lua" ''
dofile("${./hyprland-config/init.lua}")
				'';

				binary = pkgs.writeShellApplication {
					name = "desktop-shell";
					runtimeInputs = [
						hyprland
						xwayland
						uwsm
						kitty
						pkgs.waybar
						inputs.fsel.packages.${system}.default
					];

					text = "exec start-hyprland -- --config ${lua-wrapper}";
				};

				session = pkgs.writeTextFile {
					name = "desktop-shell-session";
					destination = "/share/wayland-sessions/desktop-shell.desktop";
					text = ''
[Desktop Entry]
Name=TUI Desktop Environment (Hyprland)
Comment=Hyprland based tui desktop environment
Exec=${pkgs.lib.getExe binary}
Type=Application
DesktopNames=Hyprland
Keywords=tiling;wayland;compositor;
'';
				};

			in pkgs.symlinkJoin {
				name = "desktop-shell";
				paths = [ binary session ];

				meta.mainProgram = "desktop-shell";
			})
			{ hyprland = inputs.hyprland.packages.${system}.default; };
	};
}
