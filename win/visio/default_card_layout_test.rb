require File.dirname(__FILE__) + '/../test_helper'
require 'default_card_layout'
require 'requirements_map'

class DefaultCardLayoutTest < Test::Unit::TestCase
    def setup
        @map = RequirementsMap.new
        @activity = @map.add('1.0.0', 'clean', '', Card::ACTIVITY, nil)
        @task = @activity.add('1.1.0', 'room', '', Card::TASK, nil)
        @req1 = @task.add('1.1.1', 'make the bed', '', Card::REQUIREMENT, nil)
        @req2 = @task.add('1.1.2', 'vacuum', '', Card::REQUIREMENT, nil)
        @req3 = @task.add('1.1.3', 'vacuum', '', Card::REQUIREMENT, nil)
        @req4 = @task.add('1.1.4', 'vacuum', '', Card::REQUIREMENT, nil)
        @req5 = @task.add('1.1.5', 'vacuum', '', Card::REQUIREMENT, nil)
        @task2 = @activity.add('1.2.0', 'room', '', Card::TASK, nil)
    end

    def test_simple_layout
        DefaultCardLayout.new.layout(@map)

        assert_equal([0, 0], @activity.location)
        assert_equal([0, -1.8], @task.location)
        assert_equal([0, -1.8 * 2], @req1.location)
        assert_equal([0, -1.8 * 3], @req2.location)
        assert_equal([2.2, -1.8 * 2], @req5.location)
        assert_equal([2.2 * 2, -1.8], @task2.location)
    end

    def test_layout_respects_sizes
        @req1.height = 20

        DefaultCardLayout.new.layout(@map)

        assert_equal([0, -1.8], @task.location)
        assert_equal([0, -1.8 * 2], @req1.location)
        assert_equal([0, -1.8 * 2 - 20.2], @req2.location)
    end
end