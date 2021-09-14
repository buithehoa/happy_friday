# frozen_string_literal: true

module Extensions
  module Float
    def round_up_to_quarter
      (self * 4).ceil / 4.0
    end
  end
end
