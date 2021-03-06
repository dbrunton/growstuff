require 'spec_helper'

describe "crops/index" do
  before(:each) do
  assign(:crops, [
    FactoryGirl.create(:tomato),
    FactoryGirl.create(:maize)
  ])
  end

  it "renders a list of crops" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "a", :text => "Maize"
    assert_select "a", :text => "Tomato"
  end

  it "counts the number of crops" do
    render
    rendered.should contain "Displaying 2 crops"
  end

  context "logged out" do
    it "doesn't show the new crop link if logged out" do
      render
      rendered.should_not contain "New Crop"
    end
  end

  context "logged in" do

    before(:each) do
      @member = FactoryGirl.create(:member)
      sign_in @member
      render
    end

    it "links to the add new form if logged in" do
      rendered.should contain "New Crop"
    end
  end
end
