require_relative '../../lib/date_query_calculator.rb'

class Filter < ApplicationRecord
  extend DateQueryCalculator
  belongs_to :user
  has_one :currency, as: :currencyable
  accepts_nested_attributes_for :currency, update_only: true

  JSON_SCHEMA = "#{Rails.root}/app/models/schemas/filter/data.json"

  DEFAULT_PARAMS = {
      data: {
          rubric_names: '',
          amount: { start: 0, finish: '' },
          duration: date_to_s(Date.today - 29.day..Date.today),
      },
      currency_attributes: { name: 0 }
  }

  before_create :build_currency
  before_save :build_duration

  validates :data, presence: true, json: { schema: JSON_SCHEMA }
  validates :currency, presence: true
  validate :verify_amount_finish
  validate :verify_date_range

  def self.check_expenses(user_id)
    current_filter = User.find(user_id).filter
    data_filter = current_filter.data
    default_query = "user_id = #{user_id}"
    Expense.order(created_at: :desc, updated_at: :desc, id: :desc).
            where("#{default_query}
                   #{rubrics_query(data_filter)}
                   #{amount_range_query(data_filter)}
                   #{duration_query(Filter.check_duration_range(data_filter['duration']))}")
  end

  def self.filterable?(expense)
    current_filter = User.find(expense['user_id']).filter
    data_filter = current_filter.data
    query_expense_id = "id = #{expense['id']}"
    resp = Expense.where("#{query_expense_id}
                  #{rubrics_query(data_filter)}
                  #{amount_range_query(data_filter)}
                  #{duration_query(Filter.check_duration_range(data_filter['duration']))}")
    true ? resp.present? : false
  end

  private

  def self.rubrics_query(current_user_filters)
    if current_user_filters['rubric_names'].present?
      array_for_sql = current_user_filters['rubric_names'].split(',').map { |x| "'#{x}'" }.join(', ')
      array_for_sql.insert(0, '(')
      array_for_sql += ')'
      " AND expense_type IN #{array_for_sql}"
    else
      ''
    end
  end

  def self.amount_range_query(current_user_filters)
    if current_user_filters['amount']['finish'].present?
      " AND amount >= '#{current_user_filters['amount']['start'].to_f}'
        AND amount <= '#{current_user_filters['amount']['finish']}'"
    else
      " AND amount >= '#{current_user_filters['amount']['start'].to_f}'"
    end
  end

  def self.duration_query(filter)
    " AND created_at >= '#{filter.first}'
      AND created_at <= '#{filter.last}'"
  end

  def build_duration
    data[:duration] = Filter.check_duration_type(data['duration'], '-')
  end

  def build_currency
    self.currency = Currency.new(currencyable_type: self.class)
  end

  def verify_amount_finish
    return true if data['amount']['finish'].blank?
    amount_start = data['amount']['start']
    amount_finish = data['amount']['finish'].to_f
    self.errors.add(:data, 'invalid amount_range') if amount_finish < amount_start
  end

  def verify_date_range
    current_date = Filter.check_duration_type(data['duration'], '-')

    if current_date.is_a?(Hash)
      verify_custom_range(current_date)
    elsif current_date.is_a?(Symbol)
      verify_given_string_date(current_date)
    else
      self.errors.add(:data, 'invalid date range')
    end
  end

  def verify_custom_range(current_date)
    date_start = Date.today - 100.year
    date_end = Date.today.end_of_day
    date_range = date_start...date_end

    begin
      duration_start = current_date[:custom_range].first
      duration_end = current_date[:custom_range].end

      if duration_start > duration_end ||
          date_range.exclude?(duration_start) ||
          date_range.exclude?(duration_end.beginning_of_day)

        self.errors.add(:data, 'invalid date range')
      end
    rescue
      self.errors.add(:data, 'invalid date range')
    end
  end

  def verify_given_string_date(current_date)
    self.errors.add(:data, 'invalid date range') if DateQueryCalculator::DATE_RANGES.keys.exclude?(current_date)
  end
end