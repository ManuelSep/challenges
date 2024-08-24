
require 'rails_helper'
# Create
RSpec.describe "Api::V1::Changes", type: :request do
  describe "POST /api/v1/changes" do
    let(:valid_params) do
      {
        user_id: 1,
        old: { name: "Bruce Norries" },
        new: { name: "Bruce Willis" }
      }
    end

    let(:invalid_user_id_params) do
      {
        user_id: -1,
        old: { name: "Bruce Norries" },
        new: { name: "Bruce Willis" }
      }
    end

    let(:empty_data_params) do
      {
        user_id: 1,
        old: {},
        new: {}
      }
    end

    it "tracks changes successfully with valid data" do
      post "/api/v1/changes", params: valid_params
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['message']).to eq('Changes tracked successfully')
    end

    it "returns error for invalid user_id" do
      post "/api/v1/changes", params: invalid_user_id_params
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('user_id must be a positive integer')
    end

    it "returns error when both old and new data are empty" do
      post "/api/v1/changes", params: empty_data_params
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']).to eq('Both old and new data cannot be empty')
    end

    it "returns error for unexpected issues" do
      allow(Changes::Tracker).to receive(:call).and_raise(StandardError)
      post "/api/v1/changes", params: valid_params
      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)['error']).to eq('An unexpected error occurred')
    end
  end
end

# Index
RSpec.describe "Api::V1::Changes", type: :request do
  describe "GET /api/v1/changes" do
    before do
      # Create test changes
      Change.create!(user_id: 1, field: "name", old_value: "Bruce Norries", new_value: "Bruce Willis", changed_at: "2024-08-10")
      Change.create!(user_id: 1, field: "name", old_value: "Bruce Willis", new_value: "Bruce Wayne", changed_at: "2024-08-20")
      Change.create!(user_id: 2, field: "address", old_value: "Old Address", new_value: "New Address", changed_at: "2024-08-15")
    end

    let(:valid_params) do
      {
        start_date: "2024-08-01T00:00:00Z",
        end_date: "2024-08-31T23:59:59Z"
      }
    end

    let(:field_param) do
      {
        start_date: "2024-08-01T00:00:00Z",
        end_date: "2024-08-31T23:59:59Z",
        field: "name"
      }
    end

    let(:invalid_date_params) do
      {
        start_date: "invalid_date",
        end_date: "2024-08-31T23:59:59Z"
      }
    end

    it "retrieves changes within the specified date range" do
      get "/api/v1/changes", params: valid_params
      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.count).to eq(2)
      expect(parsed_response.first['field']).to eq('name')
    end

    it "retrieves changes for a specific field within the date range" do
      get "/api/v1/changes", params: field_param
      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.count).to eq(1)
      expect(parsed_response.first['field']).to eq('name')
    end

    it "returns error for invalid date format" do
      get "/api/v1/changes", params: invalid_date_params
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']).to eq('Invalid date format')
    end

    it "returns error for unexpected issues" do
      allow(Changes::Filter).to receive(:call).and_raise(StandardError)
      get "/api/v1/changes", params: valid_params
      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)['error']).to eq('An unexpected error occurred')
    end
  end
end
