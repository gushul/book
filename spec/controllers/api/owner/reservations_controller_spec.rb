# encoding: utf-8

require 'spec_helper'

describe Api::Owner::ReservationsController do
 
  before :each do
      request.env["HTTP_ACCEPT"] = 'application/json'
  end
  
  it 'get list of owner reservations' do
    post :index, 
         :owner => {:email => "owner1@mail.com", :password => "secret12" }
    
    expect(response).to be_success    # test for the 200 status-code
    body = JSON.parse(response.body)
    body.should have(3).items         # owner1 has 3 reservation that belongs to restaurant he own after seed
  end

  it 'create reservation' do
    post :create, 
         :owner => {:email => "owner1@mail.com", :password => "secret12" }, 
         :reservation => {:restaurant_id => "1", 
                          :date          => "2013-12-07 18:00:00", 
                          :start_time    => "2013-08-17 16:00:00", 
                          :end_time      => "2013-08-17 17:30:00", 
                          :party_size    => "5", 
                          :active        => "false",
                          :name          => "Alex",
                          :email         => "alex.cruz@gmail.com",
                          :phone         => "0321654784"}
                          
    expect(response).to be_success      # test for the 200 status-code
    json = JSON.parse(response.body)
    expect(json['owner_id']).to eq(Owner.find_by_email("owner1@mail.com").id)
  end

   it 'update reservation' do
    post :update, 
         :owner => {:email => "owner1@mail.com", :password => "secret12" }, 
         :reservation => {:id            => "1",
                          :restaurant_id => "1", 
                          :date          => "2013-12-07 10:00:00", 
                          :start_time    => "2013-08-17 15:00:00", 
                          :end_time      => "2013-08-17 16:00:00", 
                          :party_size    => "3", 
                          :active        => "true",
                          :name          => "Alex Cruz",
                          :email         => "alex.cruz@gmail.com",
                          :phone         => "0989654784"}

    expect(response).to be_success      # test for the 200 status-code
    json = JSON.parse(response.body)
    expect(json['party_size']).to eq(3)
    expect(json['active']).to eq(true)
    expect(json['phone']).to eq("0989654784")
  end

end
