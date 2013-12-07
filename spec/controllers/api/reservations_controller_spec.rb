require 'spec_helper'

describe Api::ReservationsController do

  it 'get list of user reservations' do
    post :index, 
         :user => {:email => "user1@mail.com", :password => "secret12" }
    
    expect(response).to be_success  # test for the 200 status-code
    # json = JSON.parse(response.body)
    # expect(json['restaurant'].length).to eq(5) # check to make sure the right amount of messages are returned
    body = JSON.parse(response.body)
    body.should have(2).items       # user1 has 2 reservations
  end

end
