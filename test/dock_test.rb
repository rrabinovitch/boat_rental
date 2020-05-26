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

    rental_log = {@kayak_1 => @patrick,
                    @kayak_2 => @patrick,
                    @sup_1 => @eugene}

    assert_equal rental_log, @dock.rental_log
  end

  def test_it_can_charge_for_rentals
    # three boats are rented to three respective renters
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)
    # do these ^ two need to be included in this test?
    # they're part of the interaction pattern but aren't actually relevant to testing this assertion

    # two hours of rental time are added to one of patrick's rentals
    @kayak_1.add_hour
    @kayak_1.add_hour

    kayak_1_charge = {:card_number => "4242424242424242",
                      :amount => 40}

    # uses patrick's cc number
    # calculates how much he should be charged for boat rental,
      # up to dock's max rental time

    assert_equal kayak_1_charge, @dock.charge(@kayak_1)
  end

  def test_it_doesnt_charge_for_more_hours_than_max_rental_time
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    # do these ^ two need to be included in this test?
    # they're part of the interaction pattern but aren't actually relevant to testing this assertion
    @dock.rent(@sup_1, @eugene)

    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour

    sup_1_charge = {:card_number => "1313131313131313",
                      :amount => 45}

    assert_equal sup_1_charge, @dock.charge(@sup_1)
  end
end
