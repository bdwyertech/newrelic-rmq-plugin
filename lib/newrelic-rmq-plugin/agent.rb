# Encoding: UTF-8
# rubocop: disable LineLength
#
# Gem Name:: newrelic-rmq-plugin
# NewRelicRMQPlugin:: Agent
#
# Copyright (C) 2016 Brian Dwyer - Intelligent Digital Services
#
# All rights reserved - Do Not Redistribute
#

require 'rubygems'
require 'bundler/setup'
require 'newrelic_plugin'
require 'rabbitmq_manager'
require 'uri'
require 'newrelic-rmq-plugin/version'

module NewRelicRMQPlugin
  # => NewRelic RabbitMQ Collector Agent
  module Agent
    # => Import the NewRelic Agent Base
    class Agent < NewRelic::Plugin::Agent::Base
      agent_guid 'com.bdwyertech.newrelic.plugin.rabbitmq'
      agent_version NewRelicRMQPlugin::VERSION
      agent_config_options :management_api_url, :server_name, :verify_ssl
      agent_human_labels('RabbitMQ') { server_name }

      def poll_cycle
        # => Collect Per-Queue Metrics
        per_queue

        # => Collect Global Metrics
        global_metrics

        # => Grab Environment Information
        env_status
      end

      private

      #
      # => Collectors
      #

      # => Global Metrics
      def global_metrics # rubocop: disable AbcSize
        report_metric 'Global Queue Size/Total', 'Queued Messages', rmq_manager.overview['queue_totals']['messages'] || 0
        report_metric 'Global Queue Size/Ready', 'Queued Messages', rmq_manager.overview['queue_totals']['messages_ready'] || 0
        report_metric 'Global Queue Size/Unacked', 'Queued Messages', rmq_manager.overview['queue_totals']['messages_unacknowledged'] || 0

        report_metric 'Global Message Rate/Deliver', 'messages/sec', rate_for('deliver')
        report_metric 'Global Message Rate/Acknowledge', 'messages/sec', rate_for('ack')
        report_metric 'Global Message Rate/Return', 'messages/sec', rate_for('return_unroutable')

        rmq_manager.overview['object_totals'].each do |obj|
          report_metric "Global Object Totals/#{obj[0].capitalize}", nil, obj[1]
        end
      end

      # => Per-Queue Metrics
      def per_queue # rubocop: disable AbcSize
        rmq_manager.queues.each do |queue|
          queue_name = queue['name'].split('queue.').last

          report_metric "Queue Size/#{queue_name}/Total", 'Queued Messages', queue['messages']
          report_metric "Queue Size/#{queue_name}/Ready", 'Queued Messages', queue['messages_ready']
          report_metric "Queue Size/#{queue_name}/Unacked", 'Queued Messages', queue['messages_unacknowledged']

          report_metric "Message Rate/#{queue_name}/Deliver", 'messages/sec', per_queue_rate_for('deliver', queue)
          report_metric "Message Rate/#{queue_name}/Acknowledge", 'messages/sec', per_queue_rate_for('ack', queue)
          report_metric "Message Rate/#{queue_name}/Return", 'messages/sec', per_queue_rate_for('return_unroutable', queue)
        end
      end

      # => RabbitMQ Configuration Status
      def env_status
        report_metric 'Status/Version', nil, rmq_manager.overview['rabbitmq_version']
        report_metric 'Status/Cluster Name', nil, rmq_manager.overview['cluster_name']
        report_metric 'Status/Erlang Version', nil, rmq_manager.overview['erlang_version']
      end

      #
      # => Helper Methods
      #
      def per_queue_rate_for(type, queue)
        msg_stats = queue['message_stats']

        if msg_stats.is_a?(Hash)
          details = msg_stats["#{type}_details"]
          details ? details['rate'] : 0
        else
          0
        end
      end

      def rate_for(type)
        msg_stats = rmq_manager.overview['message_stats']

        if msg_stats.is_a?(Hash)
          details = msg_stats["#{type}_details"]
          details ? details['rate'] : 0
        else
          0
        end
      end

      # => Define the RabbitMQ Connection
      def rmq_manager
        @rmq_manager ||= ::RabbitMQManager.new(management_api_url, verify: verify_ssl)
      end
    end

    # => Register the Agent
    NewRelic::Plugin::Setup.install_agent :rabbitmq, self
  end
end
