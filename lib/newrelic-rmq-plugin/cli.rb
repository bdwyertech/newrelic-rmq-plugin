# Encoding: UTF-8
# rubocop: disable LineLength, AbcSize
#
# Gem Name:: newrelic-rmq-plugin
# NewRelicRMQPlugin:: CLI
#
# Copyright (C) 2016 Brian Dwyer - Intelligent Digital Services
#
# All rights reserved - Do Not Redistribute
#

require 'mixlib/cli'
require 'newrelic-rmq-plugin/agent'
require 'newrelic-rmq-plugin/config'
require 'newrelic-rmq-plugin/util'

module NewRelicRMQPlugin
  #
  # => NewRelic Launcher
  #
  module CLI
    module_function

    #
    # => Options Parser
    #
    class Options
      # => Mix-In the CLI Option Parser
      include Mixlib::CLI

      option :nr_config_file,
             short: '-nr CONFIG',
             long: '--nr-cfg-file CONFIG',
             description: "NewRelic Configuration File (Default: #{Config.nr_config_file})"
    end

    # => Launch the Application
    def run(argv = ARGV)
      # => Parse CLI Configuration
      cli = Options.new
      cli.parse_options(argv)

      # => Parse JSON Config File (If Specified and Exists)
      json_config = Util.parse_json_config(cli.config[:config_file] || Config.config_file)

      # => Grab the Default Values
      default = Config.options

      # => Merge Configuration (CLI Wins)
      config = [default, json_config, cli.config].compact.reduce(:merge)

      # => Apply Configuration
      Config.setup do |cfg|
        cfg.nr_config_file = config[:nr_config_file]
      end

      # => Load up the NewRelic Configuration
      NewRelic::Plugin::Config.config_file = Config.nr_config_file

      # => Launch the Plugin
      NewRelic::Plugin::Run.setup_and_run
    end
  end
end
