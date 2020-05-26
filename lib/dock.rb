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
    charge[:card_number] = @rental_log[boat].credit_card_number

    if boat.hours_rented <= @max_rental_time
      charge[:amount] = (boat.price_per_hour * boat.hours_rented)
      charge
    else
      charge[:amount] = (boat.price_per_hour * @max_rental_time)
      charge
    end
    # is there a way to make this method more concise?
  end
end
