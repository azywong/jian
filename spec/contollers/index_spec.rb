require 'spec_helper'

describe "index controller" do
  context "root path" do
    it "renders the index.erb" do
      get "/"
      expect(last_response.body).to include "jian"
    end
  end
end