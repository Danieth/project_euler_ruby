class DigitFactorials
  attr_accessor :cache
  attr_accessor :digit_factorial_cache

  def initialize
    @cache = [1,1]
    @digit_factorial_cache = [1,1,2,6]
  end

  def factorial(n)
    return 0 if n < 0
    @cache[n] ||= factorial(n-1) * n
  end

  def digit_factorial(n)
    # Dynamic Programming
    @digit_factorial_cache[n] ||= (n < 10) ? factorial(n) : (factorial(n % 10) + digit_factorial(n / 10))
  end
end

df = DigitFactorials.new

sum_of_digit_factorials = 0

(10..df.factorial(10)).each do |n|
  sum_of_digit_factorials += n if df.digit_factorial(n) == n
end

puts sum_of_digit_factorials
