module ApplicationHelper
  def show_amount_page(expenses)
    content_tag :tr, class: 'amount_from_page' do
      content_tag :td do
        "Amount per page: #{number_to_currency(current_user.currency_convert.convert_with_pick(expenses))}"
      end
    end
  end
end
