require "vagrant-ohai/version"
require "vagrant/plugin"

raise RuntimeError, "vagrant-ohai will only work with Vagrant 1.2.3 and above!" if Vagrant::VERSION <= "1.2.3"

module VagrantPlugins
  module Ohai
    class Plugin < Vagrant.plugin("2")
      name "vagrant-ohai"
      description <<-DESC
      This plugin ensures ipaddress and cloud attributes in Chef
      correspond to Vagrant's private network
      DESC

      action_hook(:install_ohai_plugin, Plugin::ALL_ACTIONS) do |hook|
        require_relative 'action_install_ohai_plugin'
        require_relative 'action_configure_chef'
        hook.after(Vagrant::Action::Builtin::Provision, ActionInstallOhaiPlugin)
        hook.before(Vagrant::Action::Builtin::Provision, ActionConfigureChef)
      end

      config(:ohai) do
        require_relative "config"
        Config
      end
    end
  end
end
