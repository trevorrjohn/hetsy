require 'spec_helper'

describe "templates/new" do
  before(:each) do
    assign(:template, stub_model(Template,
      :title => "MyString"
    ).as_new_record)
  end

  it "renders new template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => templates_path, :method => "post" do
      assert_select "input#template_title", :name => "template[title]"
    end
  end
end
