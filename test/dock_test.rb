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
    @sup_2 = Boat.new(:standup_paddle_board, 15)
    @canoe = Boat.new(:canoe, 25)


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

  def test_rental_log_is_updated_when_boat_rented
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

  def test_it_can_log_an_hour_for_all_rented_boats
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)

    @dock.log_hour

    assert_equal 1, @kayak_1.hours_rented
    assert_equal 1, @kayak_2.hours_rented

    @dock.rent(@canoe, @patrick)

    @dock.log_hour

    assert_equal 2, @kayak_1.hours_rented
    assert_equal 2, @kayak_2.hours_rented
    assert_equal 1, @canoe.hours_rented
  end

  def test_it_has_no_revenue_before_boats_are_returned
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)

    @dock.log_hour

    assert_equal 1, @kayak_1.hours_rented
    assert_equal 1, @kayak_2.hours_rented

    @dock.rent(@canoe, @patrick)

    @dock.log_hour
    assert_equal 0, @dock.revenue
  end

  def test_it_can_calculate_total_revenue_generated_after_boats_returned
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour

    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)

    assert_equal 105, @dock.revenue
  end

  def test_revenue_doesnt_account_for_more_than_max_hours_allow
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour

    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)

    @dock.rent(@sup_1, @eugene)
    @dock.rent(@sup_2, @eugene)

    @dock.log_hour
    @dock.log_hour
    @dock.log_hour

    @dock.log_hour
    @dock.log_hour

    @dock.return(@sup_1)
    @dock.return(@sup_2)

    assert_equal 195, @dock.revenue
  end
end


# shoudl the charge not happen til after a boat has been returned?
  # if so, then the above charge test should be reconfigured accordingly
