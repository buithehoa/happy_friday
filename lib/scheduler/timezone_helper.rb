# frozen_string_literal: true

module TimezoneHelper
  # Returns a string representation of a timezone_offset.
  # Examples:
  #   0 => '00:00'
  #   3 => '+03:00'
  # -12 => '-12:00'
  def timezone_offset_str(timezone_offset)
    str = "#{timezone_offset.to_s.rjust(2, '0')}:00"

    if timezone_offset > 0
      "+#{str}"
    elsif timezone_offset < 0
      "#{str}"
    else
      'UTC'
    end
  end
end
