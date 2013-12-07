require 'spec_helper'

describe Api::RestaurantsController do

  it 'get list of restaurants' do
    get :index
    expect(response).to be_success    # test for the 200 status-code
    body = JSON.parse(response.body)
    body.should have(5).items         # 5 restaurants after seeding
  end

end
