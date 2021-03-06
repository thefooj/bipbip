require 'monit'

module Bipbip

  class Plugin::Monit < Plugin

    # See https://bitbucket.org/tildeslash/monit/src/d60968cf7972cc902e5b6e2961d44456e1d9b736/src/monit.h?at=master#monit.h-145
    STATE_FAILED = '1'

    # See https://bitbucket.org/tildeslash/monit/src/d60968cf7972cc902e5b6e2961d44456e1d9b736/src/monit.h?at=master#monit.h-135
    MONITOR_NOT = '0'

    def metrics_schema
      [
          {:name => 'Running', :type => 'gauge', :unit => 'Boolean'},
          {:name => 'All_Services_ok', :type => 'gauge', :unit => 'Boolean'},
      ]
    end

    def monitor
      status =  ::Monit::Status.new({
        :host => 'localhost',
        :port => 2812,
        :ssl => false,
        :auth => false,
        :username => nil,
        :password => nil,
      }.merge(config))

      data = Hash.new(0)

      begin
        data['Running'] = status.get ? 1 : 0
        data['All_Services_ok'] = status.services.any? { |service|
          service.monitor == MONITOR_NOT || service.status == STATE_FAILED } ? 0 : 1
      rescue
        data['Running'] = 0
        data['All_Services_ok'] = 0
      end
      data
    end
  end
end
