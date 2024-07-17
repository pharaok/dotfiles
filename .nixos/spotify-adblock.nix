(
  self: super: let
    spotify-adblock = super.rustPlatform.buildRustPackage rec {
      pname = "spotify-adblock";
      version = "1.0.3";
      src = super.fetchFromGitHub {
        owner = "abba23";
        repo = "spotify-adblock";
        rev = "v${version}";
        hash = "sha256-UzpHAHpQx2MlmBNKm2turjeVmgp5zXKWm3nZbEo0mYE=";
      };
      cargoHash = "sha256-wPV+ZY34OMbBrjmhvwjljbwmcUiPdWNHFU3ac7aVbIQ=";

      pacthPhase = ''
        substituteInPlace src/lib.rs \
          --replace 'config.toml' $out/etc/spotify-adblock/config.toml
      '';

      buildPhase = ''
        make
      '';
      installPhase = ''
        mkdir -p $out/lib
        install -D --mode=644 --strip target/release/libspotifyadblock.so $out/lib

        mkdir -p $out/etc/spotify-adblock
        install -D --mode=644 config.toml $out/etc/spotify-adblock
      '';
    };
  in {
    spotify-adblock = super.spotify.overrideAttrs (
      old: {
        postInstall =
          (old.postInstall or "")
          + ''
            ln -s ${spotify-adblock}/lib/libspotifyadblock.so $libdir
            sed -i "s:^Name=Spotify.*:Name=Spotify-adblock:" "$out/share/spotify/spotify.desktop"
            wrapProgram $out/bin/spotify \
              --set LD_PRELOAD "${spotify-adblock}/lib/libspotifyadblock.so"
          '';
      }
    );
  }
)
