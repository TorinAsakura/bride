class Payment::InterkassaDepositDecorator < Draper::Decorator
  delegate_all

  def pay_form_params
    {
        pm_no: object.token,
        desc:  object.name,
        cur:   'RUB',
        ia_u:  h.result_payment_interkassa_deposits_url,
        ia_m:  'POST',
        suc_u: h.success_payment_interkassa_deposits_url,
        suc_m: 'GET',
        pnd_u: h.pending_payment_interkassa_deposits_url,
        pnd_m: 'GET',
        fal_u: h.fail_payment_interkassa_deposits_url,
        fal_m: 'GET'
    }
  end
end
