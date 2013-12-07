require 'spec_helper'

describe Api::ReservationsController do
  
  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
  end
  
  it 'get list of user reservations' do
    post :index, 
         :user => {:email => "user1@mail.com", :password => "secret12" }
    
    expect(response).to be_success    # test for the 200 status-code
    body = JSON.parse(response.body)
    body.should have(2).items         # user1 has 2 reservations
  end

  it 'create reservation' do
    post :create, 
         :user => {:email => "user1@mail.com", :password => "secret12" }, 
         :reservation => {:restaurant_id => "1", 
                          :date          => "2013-12-07 18:00:00", 
                          :start_time    => "2013-08-17 16:00:00", 
                          :end_time      => "2013-08-17 17:30:00", 
                          :party_size    => "5", 
                          :active        => "false"}
    
    expect(response).to be_success      # test for the 200 status-code
    json = JSON.parse(response.body)
    expect(json['user_id']).to eq(User.find_by_email("user1@mail.com").id)
  end

   it 'update reservation' do
    post :update, 
         :user => {:email => "user1@mail.com", :password => "secret12" }, 
         :reservation => {:id            => "1",
                          :restaurant_id => "1", 
                          :date          => "2013-12-07 10:00:00", 
                          :start_time    => "2013-08-17 15:00:00", 
                          :end_time      => "2013-08-17 16:00:00", 
                          :party_size    => "3", 
                          :active        => "true"}

    expect(response).to be_success      # test for the 200 status-code
    json = JSON.parse(response.body)
    expect(json['party_size']).to eq(3)
    expect(json['active']).to eq(true)
  end

end
