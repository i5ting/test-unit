module Test
  module Unit
    module Collector
      def initialize
        @filters = []
      end

      def filter=(filters)
        @filters = case(filters)
          when Proc
            [filters]
          when Array
            filters
        end
      end

      def add_suite(destination, suite, options={})
        to_delete = suite.tests.find_all {|t| !include?(t)}
        to_delete.each {|t| suite.delete(t)}
        unless suite.empty?
          if options[:prepend]
            destination.prepend(suite)
          else
            destination << suite
          end
        end
      end

      def include?(test)
        return true if(@filters.empty?)
        @filters.each do |filter|
          return false if filter[test] == false
        end
        true
      end

      def sort(suites)
        suites.sort_by {|suite| suite.name || suite.to_s}
      end
    end
  end
end
