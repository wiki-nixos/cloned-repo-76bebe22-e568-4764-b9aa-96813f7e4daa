{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    # Configure Caddy
    services.caddy = {
      # Enable the Caddy web server
      enable = true;

      # Define a simple virtual host
      virtualHosts = {
        "kolyma.uz" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:8440 {
              header_up Host {host}
              header_up X-Real-IP {remote}
              header_up Upgrade {http_upgrade}
              header_up Connection {>Connection}
            }
          '';
        };

        "www.kolyma.uz" = {
          extraConfig = ''
            redir https://kolyma.uz
          '';
        };

        "ns2.kolyma.uz" = {
          extraConfig = ''
            redir https://kolyma.uz
          '';
        };

        "git.kolyma.uz" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:8450 {
              header_up Host {host}
              header_up X-Real-IP {remote}
              header_up Upgrade {http_upgrade}
              header_up Connection {>Connection}
            }
          '';
        };
      };
    };

    # Ensure the firewall allows HTTP and HTTPS traffic
    networking.firewall.allowedTCPPorts = [80 443];
  };
}
