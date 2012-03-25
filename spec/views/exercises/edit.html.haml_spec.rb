require 'spec_helper'

describe "exercises/edit" do
  before(:each) do
    @exercise = assign(:exercise, stub_model(Exercise,
      :title => "MyString",
      :value => 1.5
    ))
  end

  it "renders the edit exercise form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => exercises_path(@exercise), :method => "post" do
      assert_select "input#exercise_title", :name => "exercise[title]"
      assert_select "input#exercise_value", :name => "exercise[value]"
    end
  end
end
