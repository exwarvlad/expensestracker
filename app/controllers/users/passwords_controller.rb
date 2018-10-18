# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  prepend_before_action :check_captcha, only: [:create]

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.any?
      error_dup = resource.errors.dup
      error_dup.each { |k| resource.errors[(k.to_s + '_').to_sym] << resource.errors.delete(k).first }
    else
      true
    end

    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      set_minimum_password_length
      respond_with resource
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  private

  def check_captcha
    unless verify_recaptcha(model: resource)
      self.resource = resource_class.new
      resource.validate # Look for any other validation errors besides Recaptcha
      resource.errors[:email_].push resource.errors.delete(:email).first
      resource.errors.delete('password')
      resource.errors.add(:base, 'reCAPTCHA verification failed, please try again.')
      respond_with_navigational(resource) { render :new }
    end
  end
end
