# encoding: utf-8

require 'spec_helper'

describe Api::Owner::ReservationsController do
 
  before :each do
      request.env["HTTP_ACCEPT"] = 'application/json'
  end
  
  it 'get list of owner reservations' do
    post :create, 
         :owner => {:email => "owner1@mail.com", :password => "secret12" }
    
    expect(response).to be_success    # test for the 200 status-code
    body = JSON.parse(response.body)
    body.should have(1).items         # owner1 has 1 reservation that belongs to him after seed
  end

end
