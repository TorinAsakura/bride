module Admin::PursePaymentsHelper

  def purse_payments_scopes(purse, scopes, active)
    links = []
    scopes.each do |scope|
      links << link_to_unless(scope[:scope].eql?(active), "#{scope[:name]} (#{scope[:count]})", purse ? admin_purse_purse_payments_path(purse, scope: scope[:scope]) : admin_purse_payments_path(scope: scope[:scope]))
    end
    links.join(' | ').html_safe
  end
end