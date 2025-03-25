{ pkgs, ... }:
{
  environment.systemPackages = (with pkgs; [
    easyeffects
    (writeShellScriptBin "initialize-sinks" ''
        #!/bin/bash
      # Wait for PipeWire and Easy Effects to start
      sleep 5

      # Start Easy Effects if not already running
      if ! pgrep easyeffects > /dev/null; then
        easyeffects --gapplication-service &
        sleep 5 # Wait for Easy Effects to initialize
      fi

      # Wait for the Easy Effects sink to be available
      while ! pw-cli list-objects | grep -q easyeffects_sink; do
        sleep 1
      done

      # Link game-sink to Easy Effects sink
      pw-link game-sink easyeffects_sink

      # Link default-sink to Easy Effects sink
      pw-link default-sink easyeffects_sink
      '')

  ]);


    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
       # Add custom WirePlumber configuration
      extraConfig.pipewire = {
        "91-null-sinks" = {
          "context.objects" = [
            {
              factory = "adapter";
              args = {
                "factory.name"     = "support.null-audio-sink";
                "node.name"        = "game-sink";
                "node.description" = "Game Sink";
                "media.class"      = "Audio/Sink";
                "audio.position"   = "FL,FR";
              };
            }
            {
              factory = "adapter";
              args = {
                "factory.name"     = "support.null-audio-sink";
                "node.name"        = "default-sink";
                "node.description" = "Default Sink";
                "media.class"      = "Audio/Sink";
                "audio.position"   = "FL,FR";
              };
            }
          ];
        };
      };
    };
}
