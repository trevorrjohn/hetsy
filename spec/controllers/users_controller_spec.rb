require 'spec_helper'
require 'sessions_helper'

describe UsersController do
  describe "#index" do
    it "should have a index page" do
      admin = create(:admin)
      sign_in admin
      get "index"
      assigns(:users).should be
    end
  end

  describe "#show" do

    it "should have a show page" do
      user = create(:user)
      signin user
      get "show", id: user.id
      assigns(:user).should eq(user)
    end

    it "should redirect to root path" do
      get "show", id: 5
      assigns(:user).should_not be
      assert_redirected_to root_path
    end
  end

  describe "#new" do
    it "should have a new page" do
      get "new"
      assigns(:user).should be
    end
  end

  describe "#create" do

    it "should create a new user" do
      user = User.new(name: "Example User", email: "user@example.com",
                      password: "example", password_confirmation: "example")
      post :create, user: { name: user.name, email: user.email,
                            password: user.password,
                            password_confirmation: user.password_confirmation }
      assert_redirected_to user_path(User.last)
      User.count.should == 1
    end

    it "should not create a new user" do
      user = User.new(name: "Example User", email: "user@example.com",
                      password: "ample", password_confirmation: "example")
      post :create, user: { name: user.name, email: user.email,
                            password: user.password,
                            password_confirmation: user.password_confirmation }
      response.should render_template :new
    end
  end

  describe "#edit" do

    it "should have a edit page" do
      user = create(:user)
      get "edit", id: user.id
      assigns(:user).should eq(user)
    end

    it "should redirect to home" do
      get "edit"
      assert_redirected_to root_path
    end
  end

  describe "#update" do
    context "valid params" do
      it "should update the user" do
        user = create(:user)
        post :update, id: user.id, user: { name: "new name", email: user.email,
                                           password: user.password,
                                           password_confirmation: user.password_confirmation }
        User.last.name.should == "new name"
        response.should render_template "show"
      end
    end
  end

  describe "#destroy" do
    it "should destroy the user" do
      user = create(:user)
      delete :destroy, id:user.id
      User.count.should == 0
    end
  end

end
