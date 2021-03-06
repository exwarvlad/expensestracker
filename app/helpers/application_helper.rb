module ApplicationHelper
  def show_amount_page(expenses)
    content_tag :tr, class: 'amount_from_page' do
      content_tag :td do
        "Amount per page: #{number_to_currency(current_user.currency_convert.convert_with_pick(expenses))}"
      end
    end
  end

  def modal_name
    if action_name == 'new' || action_name == 'create'
      'new'
    elsif action_name == 'edit' || action_name == 'update'
      'edit'
    else
      'modal'
    end
  end

  def devise_password_confirm
    if current_user.provider.present?
      "(we need your current password or #{current_user.provider} authenticated to confirm your changes)"
    else
      '(we need your current password to confirm your changes)'
    end
  end
end
