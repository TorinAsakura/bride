class Bonus::CertificatesController < ApplicationController
  respond_to :js

  def assign
    if true || verify_recaptcha
      @certificate = ::Bonus::Certificate.number(params[:bonus_certificate][:number]).first
      if @certificate.present?
        @certificate.firm = current_firm

        if @certificate.valid?
          @certificate.complete!
          @text = 'Сертификат активирован'
        else
          @error = @certificate.errors.full_messages.join('<br/>')
        end
      else
        @error = 'Промо-код не найден'
      end
    else
      @error = 'Код CAPTCHA введен неверно'
    end
    flash.delete(:recaptcha_error)
    respond_with(@certificate) do |format|
      format.js
    end
  end
end