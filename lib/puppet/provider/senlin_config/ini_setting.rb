Puppet::Type.type(:senlin_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/senlin/senlin.conf'
  end

end
