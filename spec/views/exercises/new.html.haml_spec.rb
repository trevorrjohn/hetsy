require 'spec_helper'

describe "exercises/new" do
  before(:each) do
    assign(:exercise, stub_model(Exercise,
      :title => "MyString",
      :value => 1.5
    ).as_new_record)
  end

  it "renders new exercise form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => exercises_path, :method => "post" do
      assert_select "input#exercise_title", :name => "exercise[title]"
      assert_select "input#exercise_value", :name => "exercise[value]"
    end
  end
end
