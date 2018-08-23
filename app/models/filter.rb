class Filter < ApplicationRecord
  belongs_to :user
  has_one :currency, as: :currencyable

  accepts_nested_attributes_for :currency, update_only: true

  JSON_SCHEMA = "#{Rails.root}/app/models/schemas/filter/data.json"

  DEFAULT_DATA_PARAMS = {
      rubric_names: '',
      amount: { start: '', finish: '' },
      duration: 'last_30_day'
  }

  before_create :build_currency
  before_update :build_duration

  validates :data, presence: true, json: { schema: JSON_SCHEMA }
  validate :amount_range

  def build_currencyable(params)
    self.currencyable = currencyable_type.constantize.new(params)
  end

  def self.check_expenses(user_id)
    current_filter = User.find(user_id).filter
    data_filter = current_filter.data
    default_query = "user_id = #{user_id}"
    Expense.where("#{default_query}
                   #{rubrics_query(data_filter)}
                   #{amount_range_query(data_filter)}
                   #{duration_query(Filter.check_duration_range(data_filter['duration']))}")
  end

  private

  extend ActiveSupport::Concern::DateQueryCalculator

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
      AND created_at <= '#{filter.last.end_of_day}'"
  end

  def build_duration
    data[:duration] = Filter.check_duration_type(data['duration'], '-')
  end

  def build_currency
    self.currency = Currency.new(currencyable_type: self.class)
  end

  def amount_range
    valid_is_it = true
    start_amount = data['amount']['start'].to_f
    finish_amount = data['amount']['finish']
    if start_amount < 0
      valid_is_it = false
    elsif finish_amount.present?
      valid_is_it = false if finish_amount.to_f < 0 || finish_amount.to_f < start_amount
    end
    errors[:base] << 'asd' unless valid_is_it
  end
end