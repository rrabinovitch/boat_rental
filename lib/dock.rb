class Dock
  attr_reader :name, :max_rental_time, :rental_log, :revenue

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = {}
    @revenue = 0
  end

  def rent(boat, renter)
    @rental_log[boat] = renter
  end

  def charge(boat)
    charge = {}
    charge[:card_number] = @rental_log[boat].credit_card_number

    if boat.hours_rented <= @max_rental_time
      charge[:amount] = (boat.price_per_hour * boat.hours_rented)
    elsif boat.hours_rented > @max_rental_time
      charge[:amount] = (boat.price_per_hour * @max_rental_time)
    end

    charge
  end

  def log_hour
    @rental_log.each_key do |boat|
      boat.add_hour
    end
  end

  def return(boat)
    @revenue += charge(boat)[:amount]
  end
end
