# frozen_string_literal: true

module NumbersHelper
  def formatted_currency(decimal)
    number_with_delimiter(RoundService.call(decimal:))
  end
end
