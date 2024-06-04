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
        
        "ns1.kolyma.uz" = {
          serverAliases = [
            "http://5.9.66.12" 
            "http://[2a01:4f8:161:714c::]"
          ];
          extraConfig = ''
            redir https://kolyma.uz
          '';
        };
      };
    };

    # Ensure the firewall allows HTTP and HTTPS traffic
    networking.firewall.allowedTCPPorts = [80 443];
  };
}
