def self.decimal_expansion(numerator, denominator)
  numerator *= 10
  while true
    if numerator < denominator
      yield 0, numerator, numerator == 0
    else
      yield (numerator / denominator), numerator = numerator % denominator, numerator == 0
    end
    break if numerator == 0
    numerator *= 10
  end
end

max_length = 0
index_of_max_length = 0

(2..(ARGV[0] || 999).to_i).each do |denominator|

  digit_remainders = []

  decimal_expansion(1, denominator) do |digit, remainder, no_cycle|
    if no_cycle || digit_remainders.include?([digit, remainder])
      length = (no_cycle) ? 0 : (digit_remainders.length - digit_remainders.find_index { |digit_remainder| digit_remainder == [digit, remainder] })
      if length > max_length
        max_length = length
        index_of_max_length = denominator
      end
      break
    end
    digit_remainders << [digit, remainder]
  end
end

puts max_length
puts index_of_max_length
