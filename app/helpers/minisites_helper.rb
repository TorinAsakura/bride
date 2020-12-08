module MinisitesHelper

  def minisite_access?(site, session_code=nil)
    site.blank? && return
    session_code ||= session["site_code_#{site.id}"]
    !site.privacy? || site.code.eql?(session_code) || user_signed_in? && (site.client.user.is?(current_user))
  end
end
