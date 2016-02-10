# 004
def self.digits(n)
  (Math.log(n)/Math.log(10) + 1).floor
end

require 'Primesieve'
# Borrowed from 032
class Prime
  attr_accessor :prime_cache
  attr_accessor :is_prime_cache
  attr_accessor :prime_factors_cache
  attr_accessor :digit_replacement_cycle_length_cache
  attr_accessor :prime_pair_used
  attr_accessor :prime_pair_cache

  def initialize(prime_cache_init = 1000, enable_is_prime_caching = true)
    @prime_cache = [2]
    @is_prime_cache = { 2 => true } if enable_is_prime_caching
    try_increase_prime_cache(prime_cache_init)

    @prime_factors_cache = []

    @digit_replacement_cycle_length_cache = {}

    @prime_pair_used = {}
    @prime_pair_cache = []
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
      !@is_prime_cache[n].nil? && @is_prime_cache[n]
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

  def prime_pairs(n, d = digits(n))
    return [0,0] unless prime?(n)

    prime_pair_count = 0
    prime_pair_cache_index = 0

    first_number = 10 ** (d - 1)
    reverse = 10
    while (first_number > 1)
      f1 = (n / first_number)
      f2 = (n % first_number)
      reverse_n = f2 * reverse + f1
      if (@prime_pair_used[reverse_n].nil? && @prime_pair_used[n].nil?)
        if (prime?(f1) && prime?(f2) && prime?(reverse_n))
          @prime_pair_used[reverse_n] = true
          @prime_pair_used[n] = true
          try_add_prime_pair(f1, f2)
          try_add_prime_pair(f2, f1)
          [f1, f2].each do |f|
            if (@prime_pair_cache[f].size > prime_pair_count)
              prime_pair_count = @prime_pair_cache[f].size
              prime_pair_cache_index = f
            end
          end
        end
      end
      reverse *= 10
      first_number /= 10
    end
    return [prime_pair_count, @prime_pair_cache[prime_pair_cache_index]]
  end

  def try_add_prime_pair(f1, f)
    @prime_pair_cache[f1] ||= []
    if @prime_pair_cache[f1].all? do |a|
        prime?((a.to_s + f.to_s).to_i) && prime?((f.to_s + a.to_s).to_i)
      end
      @prime_pair_cache[f1] << f  if !@prime_pair_cache[f1].include?(f)
      @prime_pair_cache[f1] << f1 if !@prime_pair_cache[f1].include?(f1)
    end
  end

end

class Fixnum
 N_BYTES = [42].pack('i').size
 N_BITS = N_BYTES * 8
 MAX = 2 ** (N_BITS - 2) - 1
 MIN = -MAX - 1
end

# Inefficient, but works
p = Prime.new
n = 10
lowest_score = Fixnum::MAX
while true
  prime_pair_count, prime_pairs = p.prime_pairs(n, digits(n))

  if (prime_pair_count >= 4)
    prime_pair_sum = prime_pairs.inject(&:+)
    if (prime_pair_sum < lowest_score)
      lowest_score = prime_pair_sum
    end
  end
  n+=1
  # Could use heuristic for better stopping measure
  break if n > 1_000_000
end

puts lowest_score
