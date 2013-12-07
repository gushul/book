# encoding: utf-8

require 'spec_helper'

describe Api::RestaurantsController do

  before :each do
      request.env["HTTP_ACCEPT"] = 'application/json'
  end

  it 'get list of restaurants' do
    get :index

    expect(response).to be_success    # test for the 200 status-code
    body = JSON.parse(response.body)
    body.should have(5).items         # 5 restaurants after seeding
  end

  it 'get particular restaurant' do
    get :show, :id => 1
    
    expect(response).to be_success    # test for the 200 status-code
    json = JSON.parse(response.body)
    expect(json['id']).to eq(1)
  end

end
