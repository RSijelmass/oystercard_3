require_relative 'fare'
require_relative 'station'
require_relative 'journey'

class Oystercard

  attr_reader :balance, :journeys
  MAX_BALANCE = 90

  def initialize
    @balance = 0
    @journeys = []
  end

  def top_up(amount)
    check_maximum_balance(amount)
    @balance += amount
  end

  def in_journey?
    return false if @journeys.empty?
    @journeys[-1].entry_station != :no_station && @journeys[-1].exit_station == :no_station
  end

  def touch_in(station)
    check_minimum_balance
    @journeys << Journey.new.start_journey(station)
    self
  end

  def touch_out(exit_station)
    @journeys[-1].end_journey(exit_station)
    deduct_fare(@journeys[-1].calculate_fare)
    self
  end

  private

  def deduct_fare(fare)
    @balance -= fare
  end

  def check_minimum_balance
    fail "Balance below minimum" if @balance < Fare::MIN_FARE
  end

  def check_maximum_balance(amount)
    fail "Cannot top_up above #{MAX_BALANCE}" if amount + @balance > MAX_BALANCE
  end

end
