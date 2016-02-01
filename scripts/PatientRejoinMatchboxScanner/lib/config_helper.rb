class ConfigHelper
  def self.get_prop(config, resource_key, prop_key, default_value)
    if !config.nil? && config.has_key?(resource_key) && config[resource_key].has_key?(prop_key)
      return config[resource_key][prop_key]
    end
    return default_value
  end
end