{
  flake.nixosModules.syncthing = { ... }: {
    services.syncthing = {
      enable = true;
      user = "aapeli"; 
      dataDir = "/home/aapeli/Sync/";
      configDir = "/home/aapeli/.config/syncthing";
      openDefaultPorts = false;

      overrideDevices = true;
      overrideFolders = true;


      settings = {
        options = {
          relaysEnabled = false;
          natEnabled = false;
          localAnnounceEnabled = true;
          globalAnnounceEnabled = false;
        };
        devices = {
          "pi-master" = {
            id = "EE4XKR7-TK4RONZ-7HE7UKV-N2SVIJM-AJA2KYY-RJ3ZWOP-TFPS7XB-QD7MQAQ";
            addresses = [ "tcp://raspis-tail37fde4.ts.net:22000" ];
          };
          # "pöytäkone" = {
          #   id = "5UE5SJC-UI3E5T3-U2ASH2P-IJUHK7L-N2ZTCLD-UD22HEW-S4U3NH6-GTOWKQ4";
          #   addresses = [ "tcp://aapeli-pc.tail37fde4.ts.net:22000" ];
          # };
        };
        folders = {
          "sync" = {
            id = "syncs";
            path = "/home/aapeli/sync";
            devices = [ "pi-master" ];
          };
        }
        ;
      };
    };
  };
}
