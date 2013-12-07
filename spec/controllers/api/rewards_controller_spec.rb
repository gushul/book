require 'spec_helper'

describe Api::RewardsController do
  
  before :each do
      request.env["HTTP_ACCEPT"] = 'application/json'
  end
  
  it 'get list of rewards' do
    get :create,
        :user => {:email => "user1@mail.com", :password => "secret12" }

    expect(response).to be_success    # test for the 200 status-code
    body = JSON.parse(response.body)
    body.should have(2).items         # 2 rewards belongs to user1mail.com after seeding
  end


end
