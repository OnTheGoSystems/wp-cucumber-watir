# Module providing networking tools for the Docker interaction
module DockerNetworking
  def port_settings_hash(ports)
    settings_hash = {}
    if $config_loader.use_standard_ports?
      settings_hash[:PortBindings] = {}
      ports.each do |port|
        settings_hash[:PortBindings][port.to_s + '/tcp'] = [
          { HostPort: port.to_s }
        ]
      end
    else
      settings_hash[:PublishAllPorts] = true
    end

    settings_hash
  end

  def nginx_domains
    [WP_DEFAULT_DOMAIN]
  end
end
