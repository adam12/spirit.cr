require "./spirit/*"

module Spirit
  def self.config_folder
    File.join(ENV["HOME"], ".spirit")
  end

  def self.ensure_config_folder_exists
    Dir.mkdir_p(config_folder, 0o700)
  end

  ensure_config_folder_exists
end
