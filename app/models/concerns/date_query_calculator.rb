# calculate type date and daterange query for calendar of filter
module DateQueryCalculator
  DATE_RANGES = {
      today: Date.today..Date.today.end_of_day,
      yesterday: Date.yesterday..(Date.yesterday).end_of_day,
      last_7_day: Date.today - 6.day..(Date.today - 1.day).end_of_day,
      last_30_day: Date.today - 29.day..Date.today.end_of_day,
      this_month: Date.today.beginning_of_month..Date.today.end_of_day,
      last_month: Date.today.prev_month.beginning_of_month..Date.today.prev_month.end_of_month.end_of_day
  }

  def check_duration_type(duration, separator)
    ranges = duration.split(separator).first(2)
    current_date_range = Date.parse(ranges.first)..Date.parse(ranges.last).end_of_day
    dd = DATE_RANGES.find { |k, v| v == current_date_range }
    dd.present? ? dd.first : {custom_range: current_date_range}
  rescue
    false
  end

  def check_duration_range(duration)
    if duration.is_a?(Hash)
      ranges = duration.values.first.split('..').first(2)
      Date.parse(ranges.first)..Date.parse(ranges.last).end_of_day
    else
      duration = duration.to_sym
      DATE_RANGES.find { |k, v| k == duration }.last
    end
  end
end