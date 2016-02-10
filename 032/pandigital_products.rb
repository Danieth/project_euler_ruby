require 'Primesieve'
# Borrowed some from 003 & 27
class PrimeFactor
  attr_accessor :prime_cache
  attr_accessor :prime_factors_cache
  def initialize(cache_init = 1000)
    @prime_cache = [2]
    try_increase_prime_cache(cache_init)
    @prime_factors_cache = []
  end

  def prime_factors(n)
    start_n = n
    @prime_factors_cache[n] ||= [].tap do |factors|
      max = Math.sqrt(n).floor
      try_increase_prime_cache(max)
      if (@prime_cache).bsearch { |prime| prime >= n } == n
        return @prime_factors_cache[start_n] = [n]
      end

      @prime_cache.each do |prime|
        break if prime > max

        while n % prime == 0
          factors << prime
          n /= prime
          if (@prime_factors_cache[n])
            return @prime_factors_cache[start_n] = factors.concat(@prime_factors_cache[n])
          end
        end
      end
      factors << n
    end
  end

  def try_increase_prime_cache(n)
    if n > @primes_cache.last
      @prime_cache.concat Primesieve.generate_primes(@prime_cache.last + 1, n)
    end
  end
end

# 004
def self.digits(n)
  (Math.log(n)/Math.log(10) + 1).floor
end

def self.pandigital_string?(n)
  n.to_s.length == 9 && is_partially_pandigital?(n)
end

def self.is_partially_pandigital?(n)
  characters = n.to_s.chars
  characters.uniq & characters == characters && !characters.include?("0")
end

def self.contains_elements?(p, s)
  s.uniq.all? { |e| p.count(e) >= s.count(e) }
end

def self.is_pandigital_product?(n, pf = PrimeFactor.new, valid_multiplicands = (1...5000).select { |n| is_partially_pandigital?(n) })
  factors = pf.prime_factors(n)
  valid_multiplicands.any? do |multiplicand|
    if is_partially_pandigital?("#{multiplicand}#{n}") && contains_elements?(factors, pf.prime_factors(multiplicand))
      if pandigital_string?("#{multiplicand}#{n / multiplicand}#{n}")
        puts "#{multiplicand} #{n / multiplicand} #{n}"
        true
      end
    end
  end
end


pf = PrimeFactor.new
vm = (1...5000).select { |n| is_partially_pandigital?(n) }
sum_of_pandigital_products = 0
(1..9999).each do |n|
  if is_partially_pandigital?(n) && is_pandigital_product?(n, pf, vm)
    sum_of_pandigital_products += n
  end
end

puts sum_of_pandigital_products
