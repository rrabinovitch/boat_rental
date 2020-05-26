require 'minitest/autorun'
require 'minitest/pride'
require './lib/boat'
require './lib/renter'
require './lib/dock'

class DockTest < Minitest::Test
  def setup
    @dock = Dock.new("The Rowing Dock", 3)

    @kayak_1 = Boat.new(:kayak, 20)
    @kayak_2 = Boat.new(:kayak, 20)
    @sup_1 = Boat.new(:standup_paddle_board, 15)

    @patrick = Renter.new("Patrick Star", "4242424242424242")
    @eugene = Renter.new("Eugene Crabs", "1313131313131313")
  end

  def test_it_exists
    assert_instance_of Dock, @dock
  end

  def test_it_has_name_and_max_rental_time
    assert_equal "The Rowing Dock", @dock.name
    assert_equal 3, @dock.max_rental_time
  end

  def test_it_starts_with_empty_rental_log
    assert_empty @dock.rental_log
  end

  def test_it_can_rent_boat
    # rent - this method takes a Boat and a Renter as arguments. Calling this method signifies that the Boat has been rented by the Renter.
    # how to test that method worked in its own test?
    # => maybe assert @dock.rent(@kayak_1, @patrick) just to confirm it works? but that seems redundant if in the next test we've confirmed that it works
    # or is only way to test rental log like below?
  end

  def test_it_can_list_rental_log
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)

    expected_rental_log = {@kayak_1 => @patrick,
                          @kayak_2 => @patrick,
                          @sup_1 => @eugene}

    assert_equal expected_rental_log, @dock.rental_log
  end

  def test_it_can_charge_for_rentals
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)

    expected_rental_log = {@kayak_1 => @patrick,
                          @kayak_2 => @patrick,
                          @sup_1 => @eugene}

  end
end
