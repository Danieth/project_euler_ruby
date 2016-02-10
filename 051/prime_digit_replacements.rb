require 'Primesieve'
# Borrowed from 032
class Prime
  attr_accessor :prime_cache
  attr_accessor :is_prime_cache
  attr_accessor :prime_factors_cache
  attr_accessor :digit_replacement_cycle_length_cache

  def initialize(prime_cache_init = 1000, enable_is_prime_caching = true)
    @prime_cache = Primesieve.generate_primes(0, [prime_cache_init, 1000].max)
    @is_prime_cache = {} if enable_is_prime_caching
    @prime_factors_cache = []
    @digit_replacement_cycle_length_cache = {}
  end

  # def prime_factors(n)
  #   start_n = n
  #   @prime_factors_cache[n] ||= [].tap do |factors|
  #     max = Math.sqrt(n).floor
  #     try_increase_prime_cache(max)
  #     return @prime_factors_cache[start_n] = [n] if prime?(n)

  #     @prime_cache.each do |prime|
  #       break if prime > max

  #       while n % prime == 0
  #         factors << prime
  #         n /= prime
  #         if (@prime_factors_cache[n])
  #           return @prime_factors_cache[start_n] = factors.concat(@prime_factors_cache[n])
  #         end
  #       end
  #     end
  #     factors << n
  #   end
  # end

  def digit_replacement_cycle(n)
    return 0 unless prime?(n)
    s = n.to_s
    s.chars.uniq.map do |d|
      digit_replacement_cycle_length(s.gsub(d, "*"))
    end.max
  end

  def digit_replacement_cycle_length(s)
    r = s.start_with?("*") ? (1..9) : (0..9)
    @digit_replacement_cycle_length_cache[s] ||= r.count do |i|
      prime?(s.gsub("*", i.to_s).to_i)
    end
  end

  def prime?(n)
    try_increase_prime_cache(n)
    if @is_prime_cache
      !@is_prime_cache[n].nil?
    else
      (@prime_cache).bsearch { |prime| prime >= n } == n
    end
  end

  def try_increase_prime_cache(n)
    if n > @prime_cache.last
      new_primes = Primesieve.generate_primes(@prime_cache.last + 1, n)
      if @is_prime_cache
        new_primes.each do |prime|
          @is_prime_cache[prime] = true
        end
      end
      @prime_cache.concat new_primes
    end
  end
end

p = Prime.new(0, true)
n = 100
while true
  if (p.digit_replacement_cycle(n += 1) >= 8)
    puts n
    break
  end
end
