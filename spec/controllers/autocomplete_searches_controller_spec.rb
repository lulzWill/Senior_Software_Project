require 'rails_helper'

RSpec.describe AutocompleteSearchesController, type: :controller do

  describe "GET #Index" do
    it "returns http success" do
      get :Index
      expect(response).to have_http_status(:success)
    end
  end

end
