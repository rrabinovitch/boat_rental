class Dock
  attr_reader :name, :max_rental_time, :rental_log

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = {}
  end

  def rent(boat, renter)
    @rental_log[boat] = renter
  end

  def charge(boat)
    charge = {}

    if boat.hours_rented <= @max_rental_time
      charge[:card_number] = @rental_log[boat].credit_card_number
      charge[:amount] = (boat.price_per_hour * boat.hours_rented)
      charge
    else
      ###
      require "pry"; binding.pry
    end

  end
end
