require 'gearman/server'
class GearmanServer < Gearman::Server
end

module Bipbip

  class Plugin::Gearman < Plugin

    def metrics_schema
      [
          {:name => 'jobs_queued_total', :type => 'gauge', :unit => 'Jobs'},
      ]
    end

    def monitor
      gearman = GearmanServer.new(config['hostname'] + ':' + config['port'].to_s)
      stats = gearman.status

      jobs_queued_total = 0
      stats.each do |function_name, data|
        data.each do |queue, stats|
          jobs_queued_total += queue.to_i
        end
      end

      {:jobs_queued_total => jobs_queued_total}
    end
  end
end
