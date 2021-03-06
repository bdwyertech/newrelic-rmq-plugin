# Encoding: UTF-8
# rubocop: disable LineLength
#
# Gem Name:: newrelic-rmq-plugin
# NewRelicRMQPlugin:: Util
#
# Copyright (C) 2016 Brian Dwyer - Intelligent Digital Services
#
# All rights reserved - Do Not Redistribute
#

require 'json'

module NewRelicRMQPlugin
  # => Utility Methods
  module Util
    module_function

    ########################
    # =>    File I/O    <= #
    ########################

    # => Define JSON Parser
    def parse_json(file = nil, symbolize = true)
      return unless file && ::File.exist?(file.to_s)
      begin
        ::JSON.parse(::File.read(file.to_s), symbolize_names: symbolize)
      rescue JSON::ParserError
        return
      end
    end

    # => Define JSON Writer
    def write_json(file, object)
      return unless file && object
      begin
        File.open(file, 'w') { |f| f.write(JSON.pretty_generate(object)) }
      end
    end

    # => Check if a string is an existing file, and return it's content
    def filestring(file, size = 8192)
      return unless file
      return file unless file.is_a?(String) && File.file?(file) && File.size(file) <= size
      File.read(file)
    end

    #############################
    # =>    Serialization    <= #
    #############################

    def serialize(response)
      # => Serialize Object into JSON Array
      JSON.pretty_generate(response.map(&:name).sort_by(&:downcase))
    end

    def serialize_csv(csv)
      # => Serialize a CSV String into an Array
      return unless csv && csv.is_a?(String)
      csv.split(',')
    end
  end
end
