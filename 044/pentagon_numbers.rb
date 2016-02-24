class Pentagonal
  include Enumerable

  attr_accessor :pentagonal_number_cache
  def initialize
    @pentagonal_number_cache = [0,1]
  end

  def each &block
    # Skip 0
    i = 0
    loop do
      block.call(pentagonal_number(i += 1))
    end
  end

  def pentagonal_number(n)
    @pentagonal_number_cache[n] ||= (pentagonal_number(n-1) + (3*n - 2))
  end

  def is_pentagonal?(k)
    m1 = (24 * k + 1) ** 0.5
    m1.to_i == m1 && (m1.to_i + 1) % 6 == 0
  end
end

p = Pentagonal.new()
smaller_pentagonal_numbers = []
p.each do |pentagonal_number|
  smaller_pentagonal_numbers.each do |smaller_pentagonal_number|
    if p.is_pentagonal?(pentagonal_number + smaller_pentagonal_number) && p.is_pentagonal?(pentagonal_number - smaller_pentagonal_number)
      puts pentagonal_number - smaller_pentagonal_number
      exit(0)
    end
  end
  smaller_pentagonal_numbers << pentagonal_number
end
