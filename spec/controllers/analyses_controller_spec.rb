require "rails_helper"

describe "get /analyses", type: :request do
  let!(:user1) { User.create(created_at: 2.weeks.ago) }
  let!(:user2) { User.create(created_at: 2.days.ago) }

  let!(:order1) { Order.create(user: user1, created_at: 2.weeks.ago, order_number: 1) }
  let!(:order2) { Order.create(user: user1, created_at: 9.days.ago, order_number: 2) }

  it 'renders valid content' do
    get "/analyses"
    expect(response.status).to eq(200)
    expect(response.body).to include("1 users")
    expect(response.body).to include("1 orderers. 100%")
    expect(response.body).to include("1 1st orderers. 100%")
  end
end
