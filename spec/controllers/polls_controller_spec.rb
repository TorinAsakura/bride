require 'spec_helper'

describe PollsController do
	let(:poll) {create(:poll)}
	context "when no need user auth" do
		it "#index" do
    get :index, subdomain: ""
  	expect(response).to be_success
	  end

	  it "#show" do
	  	get :show, format: 'js', id: poll.id, subdomain: ""
	  	expect(response).to be_success
	  end
	end
  
  context "when need user auth" do
  	let(:client) {build(:user_client)}
  	before do
  		#sign_in(client)
  	end
  end
end
