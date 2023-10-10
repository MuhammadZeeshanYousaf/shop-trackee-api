module HelperMethods

  def abbreviated_number(number)
    return '0' if number == 0

    abs_number = number.abs  # Work with the absolute value

    if abs_number >= 1_000_000_000
      "#{(abs_number / 1_000_000_000.0).round(1)}B"
    elsif abs_number >= 1_000_000
      "#{(abs_number / 1_000_000.0).round(1)}M"
    elsif abs_number >= 1_000
      "#{(abs_number / 1_000.0).round(1)}K"
    else
      number.to_s
    end
  end

end
