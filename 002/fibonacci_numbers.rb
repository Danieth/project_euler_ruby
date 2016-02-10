class Fibonacci
  include Enumerable

  attr_accessor :cache
  def initialize(cache = [0, 1, 1])
    @cache = cache.dup
  end

  # F(2 * n)     = F(n) * (2 * F(n + 1) - F(n))
  # F(2 * n + 1) = F(n+1) ^ 2 + F(n) ^ 2
  def fibonacci(n)
    return 0 if (n < 0)
    return @cache[n] ||=
      if (n % 2 == 0)
        fibonacci(n / 2) * (2 * fibonacci(n / 2 + 1) - fibonacci(n / 2))
      else
        fibonacci(n / 2 + 1) * fibonacci(n / 2 + 1) + fibonacci(n / 2) * fibonacci(n / 2)
      end
  end

  def each &block
    n = 0
    loop do
      block.call(fibonacci(n += 1))
    end
  end
end

limit = (ARGV[0] || 4_000_000).to_i
puts Fibonacci.new.take_while { |f| f < limit }.select { |f| f % 2 == 0 }.inject(&:+)
