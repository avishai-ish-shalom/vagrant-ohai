module VagrantPlugins
  module Ohai
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :enable
      attr_accessor :primary_nic
      attr_accessor :plugins_dir

      def initialize
        @enable = UNSET_VALUE
        @primary_nic = UNSET_VALUE
        @plugins_dir = UNSET_VALUE
      end
      def finalize!
        @enable = true if @enable == UNSET_VALUE
        @primary_nic = nil if @primary_nic == UNSET_VALUE
        @plugins_dir = nil if @plugins_dir == UNSET_VALUE
      end

      def validate(machine)
        case @primary_nic
        when /eth[0-9]+/
            {}
        when /enp[0-9]+s[0-9]+/
            {}
        when nil
            {}
        else
            {"primary_nic" => ["primary_nic must match eth[0-9]+"]}
        end
        case @enable
        when TrueClass, FalseClass
          {}
        else
          {"enable" => ["enable must be true or false"] }
        end
        case @plugins_dir
        when nil
          {}
        else
          if !File.directory?(@plugins_dir.to_s) or @plugins_dir.to_s !~ /^\//
            {"plugins_dir" => ["plugins_dir must be an absolute path to a folder"]}
          else
            {}
          end
        end
      end

    end
  end
end
