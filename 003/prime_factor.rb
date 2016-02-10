require 'primesieve'
n = 600_851_475_143

class PrimeFactor
  def self.prime_factors(n)
    [].tap do |factors|
      Primesieve.generate_primes(2, (n**0.5).floor).each do |prime|
        while n % prime == 0
          factors << prime
          n /= prime
        end
      end
    end
  end
end

puts PrimeFactor.prime_factors(n).last
