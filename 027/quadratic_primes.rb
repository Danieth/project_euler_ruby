require 'primesieve'
class PrimeCache
  attr_accessor :cache
  def initialize()
    @cache = [2]
  end

  def is_prime?(n)
    try_increase_cache(n)
    @cache.bsearch { |prime| prime >= n } == n
  end

  def try_increase_cache(n)
    if n > @cache.last
      @cache.concat Primesieve.generate_primes(@cache.last, n)
    end
  end

  def primes_under(n)
    try_increase_cache(n)
    @cache.each do |prime|
      return if prime > n
      yield prime
    end
  end
end


pc = PrimeCache.new
max_n = 0
product_coefficients_of_max_n = 0

pc.primes_under(1000) do |b|
  (-1000..1000).each do |a|
    n = 1
    while pc.is_prime?(n ** 2 + n * a + b)
      n += 1
    end
    if n > max_n
      max_n = n
      product_coefficients_of_max_n = a * b
    end
  end
end

# puts max_n
puts product_coefficients_of_max_n
