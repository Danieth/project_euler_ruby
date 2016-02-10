# Brute Force
def self.brute_force_sum_of_multiples(multiples, max = 1000)
    (1...max).select {|n| multiples.any?{ |multiple| n % multiple == 0 } }.inject(&:+)
end

# Much faster with preprocessing
class SumOfMultiples
  attr_accessor :multiples
  attr_accessor :multiples_to_subtract
  # Proved by induction that this method will produce the correct results.
  # Initialize time is directly related to the number of unique multiples without other multiple divisors.
  def initialize(*multiples)
    @multiples = multiples.sort.uniq
    @multiples_to_subtract = []
    remove_duplicate_multiples
    find_new_combinations
  end

  # sum_of_multiples method
  def sum_of_multiples(max = 1000)
    return 0                                       if max <= 0 || @multiples.empty?
    return -1                                      if @multiples.include?(0)
    return sum_of_multiple(@multiples[0], max - 1) if @multiples.size == 1
    return sum_of_multiple(1, max - 1)             if @multiples.include?(1)

    sum_multiples = ->(multiples) {
      return 0 if multiples.empty?
      multiples.map do |multiple|
        sum_of_multiple(multiple, max - 1)
      end.inject(&:+)
    }
    sum_multiples.call(@multiples) - sum_multiples.call(@multiples_to_subtract)
  end

  private

  # Sum from n = 1 to max where (n % multiple == 0)
  # Sum = multiple * (max / multiple) * (max / multiple + 1) / 2
  def sum_of_multiple(multiple, max = 999)
    max /= multiple
    (multiple * max * (max + 1)) / 2
  end

  # Remove non-prime multiples that have divisors
  def remove_duplicate_multiples
    return if @multiples.include?(1)
    @multiples.reject! do |multiple|
      @multiples.any? do |other_multiple|
        next if multiple == other_multiple
        multiple % other_multiple == 0
      end
    end
  end

  # Find all combinations of the multiples
  # If even size add to multiples_in_common, for subtraction
  # If odd size add to new_multiples, for addition
  def find_new_combinations
    return if @multiples.include?(1)
    (2..@multiples.size).each do |len|
      @multiples.combination(len).each do |combination|
        array = (len % 2 == 0) ? @multiples_to_subtract : @multiples
        array << product(combination)
      end
    end
  end

  def product(array)
    return 0 if array.empty?
    product = array[0]
    for i in 1...array.size do
      product *= array[i]
    end
    product
  end
end

puts SumOfMultiples.new(3, 5).sum_of_multiples(ARGV[0] || 1_000)
