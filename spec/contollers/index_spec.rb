require 'spec_helper'
require 'rake'

describe "not logged in" do
  context "GET root path" do
    it "renders the index.erb" do
      get "/"
      expect(last_response).to be_ok
    end
  end

  context "POST /sessions" do
    let(:params) {{username: "what", password: "what"}}
    it "logs in with valid params" do
      more_params = {user: {username: "what", password: "what", name: "what", email: "what@example.com"}}
      User.create(more_params)
        post '/sessions', params
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path_info).to eq("/")
    end

    let(:invalid_params) {{username: "allison", password: "incorrect"}}
      it "doesn't log in with invalid params" do
        post '/sessions'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path_info).to eq("/users/new")
    end
  end

  context "GET /users/new'" do
    it "renders the sign_up.erb" do
      get "/"
      expect(last_response).to be_ok
    end
  end

  context "POST /users" do
    let(:valid_params) {{user: {username: "what", password: "what", name: "what", email: "what@example.com"}}}
    it "creates a user with valid params" do
      expect {
        post '/users', valid_params
      }.to change {User.count}.by(1)
      expect(last_response).to be_redirect
    end
  end

  context "GET /tags" do
    it "renders Not Logged In! in tracking.erb" do
      get "/tags"
      expect(last_response.body).to include "Not Logged In!"
    end
  end

  context "GET tags/:tagsearch" do
    it "renders the tag.erb with Not Logged In message" do
      get "/tags/cats"
      expect(last_response.body).to include "Not Logged In!"
    end
  end

  context "GET /images" do
    it "it shows random images" do
      get "/images"
      expect(last_response).to be_ok
    end
  end
end



describe "logged in" do
  context "GET /oauth/connect" do
    it "redirects a bunch" do
      more_params = {user: {username: "what", password: "what", name: "what", email: "what@example.com"}}
      User.create(more_params)
      params = {username: "what", password: "what"}
      post "/sessions", params
      get "/oauth/connect"
      expect(last_response).to be_redirect
    end
  end

  context "DELETE /sessions/:id" do
    it "redirects logout to index when logged in" do
      more_params = {user: {username: "nonsense", password: "nonsense", name: "nonsense", email: "nonsense@example.com"}}
      User.create(more_params)
      params = {username: "nonsense", password: "nonsense"}
      post "/sessions", params
      delete "/sessions/#{User.last.id}"
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path_info).to eq("/")
    end
  end

  context "GET /tags" do
    it "renders tracking.erb when user has no following tags" do
      more_params = {user: {username: "nonsense", password: "nonsense", name: "nonsense", email: "nonsense@example.com"}}
      User.create(more_params)
      params = {username: "nonsense", password: "nonsense"}
      post "/sessions", params
      get "/tags"
      expect(last_response.body).to include "You have no tracked tags!  Go search for something"
    end

    it "renders tracking.erb when user has following tags" do
      more_params = {user: {username: "nonsense", password: "nonsense", name: "nonsense", email: "nonsense@example.com"}}
      User.create(more_params)
      params = {username: "nonsense", password: "nonsense"}
      post "/sessions", params
      post "/users/#{User.last.id}/tag/cats"
      get "/tags"
      expect(last_response.body).to include "cats"
    end
  end

  context "GET /tags/:tagsearch" do
    it "renders tag.erb" do
      more_params = {user: {username: "nonsense", password: "nonsense", name: "nonsense", email: "nonsense@example.com"}}
      User.create(more_params)
      params = {username: "nonsense", password: "nonsense"}
      post "/sessions", params
      get "/tags/cats"
      expect(last_response.body).to include "cats"
    end
  end

  # context "POST /users/:id/tags/:name" do
  #   it "??? ajax" do
  #     more_params = {user: {username: "nonsense", password: "nonsense", name: "nonsense", email: "nonsense@example.com"}}
  #     User.create(more_params)
  #     params = {username: "nonsense", password: "nonsense"}
  #     post "/sessions", params
  #     get "/tags/cats"
  #     expect(last_response.body).to include "cats"
  #   end
  # end


end