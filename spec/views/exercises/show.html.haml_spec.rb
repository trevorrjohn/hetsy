require 'spec_helper'

describe "exercises/show" do
  before(:each) do
    @exercise = assign(:exercise, stub_model(Exercise,
      :title => "Title",
      :value => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/1.5/)
  end
end
