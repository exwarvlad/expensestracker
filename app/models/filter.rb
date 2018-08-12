class Filter < ApplicationRecord

  DEFAULT_PARAMS = {
      'rubric_names' => '',
      'amount' => { 'start' => '', 'finish' => '' }
  }

  def self.check_expenses(user_id)
    current_user_filters = Filter.find { |f| f.user_id == user_id }.filter
    default_query = "user_id = #{user_id}"
    Expense.where("#{default_query}#{rubrics_query(current_user_filters)}#{amount_range_query(current_user_filters)}")
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
end
