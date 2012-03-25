require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example", email: "foo@bar.com",
                            password: "foobar", password_confirmation: "foobar") }
  subject { @user }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :remember_token }
  it { should respond_to :password_confirmation }

  it { should be_valid }

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "validations" do

    it { should validate_presence_of :name }
    it { should validate_presence_of :email }

    context "invalid / blank name" do
      before { @user.name = "   " }
      it { should_not be_valid }
    end

    context "blank email" do
      before { @user.email = "   " }
      it { should_not be_valid }
    end

    context "name is too long" do
      before { @user.name = "a" * 51 }
      it { should_not be_valid }
    end

    context "invalid email format" do
      invalid_email_addresses = %w[ user@foo,com userfoo.com user@com
                                    user_at_foo.com ]
      invalid_email_addresses.each do |invalid_email|
        before { @user.email = invalid_email }
        it { should_not be_valid }
      end
    end

    context "valid email formats" do
      valid_addresses = %w[ user@foo.com A_USER@f.b.org frst.lst@foo.jp
                            a+b@baz.cn ]
      valid_addresses.each do |valid_email|
        before { @user.email = valid_email }
        it { should be_valid }
      end
    end

    context "multiple email addresses" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end

      it { should_not be_valid }
    end

    context "blank passwords" do
      before { @user.password = @user.password_confirmation = "  " }
      it { should_not be_valid }
    end

    context "different passwords" do
      before { @user.password_confirmation = "mismatch" }
      it { should_not be_valid }
    end

    context "nil password_confirmation" do
      before { @user.password_confirmation = nil }
      it { should_not be_valid }
    end

    context "has short password" do
      before { @user.password = @user.password_confirmation = "a" * 5 }
      it { should_not be_valid }
    end
  end
end
