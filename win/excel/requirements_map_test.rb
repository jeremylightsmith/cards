require File.dirname(__FILE__) + '/../test_helper'
require 'requirements_map'

class RequirementsMapTest < Test::Unit::TestCase
    def test_building_activities
        map = RequirementsMap.new

        activity = map.add('1.0.0', 'clean', '', Card::ACTIVITY, nil)
        task = activity.add('1.1.0', 'room', '', Card::TASK, nil)
        task.add('1.1.1', 'make the bed', '', Card::REQUIREMENT, nil)
        task.add('1.1.2', 'vacuum', '', Card::REQUIREMENT, nil)
        task = activity.add('1.2.0', 'kitchen', '', Card::TASK, nil)
        task.add('1.2.1', 'wash dishes', '', Card::REQUIREMENT, nil)
        activity = map.add('2.0.0', 'read', '', Card::ACTIVITY, nil)
        task = activity.add('2.1.0', 'a good book', '', Card::TASK, nil)

        assert_equal(
%{1.0.0 - clean
  1.1.0 - room
    1.1.1 - make the bed
    1.1.2 - vacuum
  1.2.0 - kitchen
    1.2.1 - wash dishes
2.0.0 - read
  2.1.0 - a good book
},
                map.dump);
    end

    def test_find_by_id
        map = RequirementsMap.new
        activity = map.add('1.0.0', 'clean', '', Card::ACTIVITY, nil)
        task = activity.add('1.1.0', 'room', '', Card::TASK, nil)
        task.add('1.1.1', 'make the bed', '', Card::REQUIREMENT, nil)
        task.add('1.1.2', 'vacuum', '', Card::REQUIREMENT, nil)

        assert_equal('clean', map.find_by_id('1.0.0').name)
        assert_equal('make the bed', map.find_by_id('1.1.1').name)
        assert_equal('vacuum', map.find_by_id('1.1.2').name)
        assert_equal(nil, map.find_by_id('1.1.3'))
    end

    def test_bounding_box
        map = RequirementsMap.new
        card1 = map.add(nil, nil, nil, nil, nil)
        card1.x, card1.y, card1.width, card1.height = [2, 3, 2, 0.5]

        assert_equal(Rectangle.new(2, 3, 4, 2.5), map.bounding_box)

        card2 = card1.add(nil, nil, nil, nil, nil)
        card2.x, card2.y, card2.width, card2.height = [4, 1, 2, 1]

        assert_equal(Rectangle.new(2, 3, 6, 0), map.bounding_box)
    end

    def test_visit
        map = RequirementsMap.new
        map.add("1", nil, nil, nil, nil).
            add("2", nil, nil, nil, nil).
            add('3', nil, nil, nil, nil)
        map.add('4', nil, nil, nil, nil)

        log = ''
        map.visit {|card| log += card.id}

        assert_equal('1234', log)
    end

    def test_integrate_with_excel
        map = RequirementsMap.new
        map.load_from_excel(File.dirname(__FILE__) + '/../examples/art.xls')

        #puts "dump = " + map.dump
        task = map.activities[0].children[0]
        assert_equal('Review Compensation Forecast by template', task.name)
        assert_equal(Card::TASK, task.type)
    end
end