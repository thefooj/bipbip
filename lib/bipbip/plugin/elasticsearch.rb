require 'elasticsearch'
class ElasticsearchClient < Elasticsearch::Transport::Client
end

module Bipbip

  class Plugin::Elasticsearch < Plugin

    def metrics_schema
      [
          {:name => 'search_query_total', :type => 'counter', :unit => 'Queries'},
          {:name => 'search_query_time', :type => 'counter', :unit => 'Seconds'},
          {:name => 'search_fetch_total', :type => 'counter', :unit => 'Fetches'},
          {:name => 'search_fetch_time', :type => 'counter', :unit => 'Seconds'},

          {:name => 'get_total', :type => 'counter', :unit => 'Gets'},
          {:name => 'get_time', :type => 'counter', :unit => 'Seconds'},
          {:name => 'get_exists_total', :type => 'counter', :unit => 'Exists'},
          {:name => 'get_exists_time', :type => 'counter', :unit => 'Seconds'},
          {:name => 'get_missing_total', :type => 'counter', :unit => 'Missing'},
          {:name => 'get_missing_time', :type => 'counter', :unit => 'Seconds'},

          {:name => 'indexing_index_total', :type => 'counter', :unit => 'Indexes'},
          {:name => 'indexing_index_time', :type => 'counter', :unit => 'Seconds'},
          {:name => 'indexing_delete_total', :type => 'counter', :unit => 'Deletes'},
          {:name => 'indexing_delete_time', :type => 'counter', :unit => 'Seconds'},

          {:name => 'cache_filter_size', :type => 'gauge', :unit => 'b'},
          {:name => 'cache_filter_evictions', :type => 'gauge', :unit => 'b'},
          {:name => 'cache_field_size', :type => 'gauge', :unit => 'b'},
          {:name => 'cache_field_evictions', :type => 'gauge', :unit => 'b'},
      ]
    end

    def monitor
      @stats = nil
      {
          'search_query_total' => stats_sum(['indices', 'search', 'query_total']),
          'search_query_time' => stats_sum(['indices', 'search', 'query_time_in_millis'])/1000,
          'search_fetch_total' => stats_sum(['indices', 'search', 'fetch_total']),
          'search_fetch_time' => stats_sum(['indices', 'search', 'fetch_time_in_millis'])/1000,

          'get_total' => stats_sum(['indices', 'get', 'total']),
          'get_time' => stats_sum(['indices', 'get', 'time_in_millis'])/1000,
          'get_exists_total' => stats_sum(['indices', 'get', 'exists_total']),
          'get_exists_time' => stats_sum(['indices', 'get', 'exists_time_in_millis'])/1000,
          'get_missing_total' => stats_sum(['indices', 'get', 'missing_total']),
          'get_missing_time' => stats_sum(['indices', 'get', 'missing_time_in_millis'])/1000,

          'indexing_index_total' => stats_sum(['indices', 'indexing', 'index_total']),
          'indexing_index_time' => stats_sum(['indices', 'indexing', 'index_time_in_millis'])/1000,
          'indexing_delete_total' => stats_sum(['indices', 'indexing', 'delete_total']),
          'indexing_delete_time' => stats_sum(['indices', 'indexing', 'delete_time_in_millis'])/1000,

          'cache_filter_size' => stats_sum(['indices', 'filter_cache', 'memory_size_in_bytes']),
          'cache_filter_evictions' => stats_sum(['indices', 'filter_cache', 'evictions']),
          'cache_field_size' => stats_sum(['indices', 'fielddata', 'memory_size_in_bytes']),
          'cache_field_evictions' => stats_sum(['indices', 'fielddata', 'evictions']),
      }
    end

    private

    def connection
      ElasticsearchClient.new({:host => [config['hostname'], config['port']].join(':')})
    end

    def nodes_stats
      connection.nodes.stats
    end

    def stats_sum(keys)
      @stats ||= nodes_stats

      sum = 0
      nodes_stats['nodes'].each do |node, status|
        sum += keys.inject(status) { |h, k| (h.is_a?(Hash) and !h[k].nil?) ? h[k] : 0 }
      end

      sum
    end

  end
end
