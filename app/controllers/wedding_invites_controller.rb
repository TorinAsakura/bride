# encoding: utf-8
class WeddingInvitesController < BaseWeddingController
  before_filter :find_invite, only: [:confirm, :reject]

  def confirm
    inviter_client = @invite.client
    if @invite.couple.is? current_client
      current_client.destroy_wedding if current_client.has_wedding?
      current_client.site.destroy if current_client.has_site?

      inviter_client.create_couple_with current_client
      current_client.invited.destroy_all
      current_client.wedding_invite.destroy if current_client.wedding_invite.present?
    end
    redirect_to :back
  end

  def reject
    @invite.destroy if @invite.present?
    redirect_to :back
  end

  private
  def find_invite
    client = Client.find(params[:client_id])
    @invite = client.invited.find_by_id(params[:id])
  end
end
