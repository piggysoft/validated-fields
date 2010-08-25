require "spec_helper"

describe ValidatedFields::Helpers do
 
  before(:each) do
    @user       = User.new
    @controller = UsersController.new
    @builder    = ActionView::Helpers::FormBuilder.new(:user, @user, @controller, {}, nil)
  end

  it "should add 'validated' class if there's no class in options" do
    @builder.text_field(:name, :validate => true).should match(/class="validated"/)
  end
  
  it "should add 'validated' class if the 'class' option already has a value assigned" do
    @builder.text_field(:name, :validate => true, :class => 'foobar').should match(/class="foobar validated"/)
  end
  
  it "should not add any options if the :validate option isn't provided" do
    input = @builder.text_field(:name)
    
    input.should_not match(/required="required"/)
    input.should_not match(/data-required-error-msg="Name is required"/)
    input.should_not match(/validate="false"/)
    input.should_not match(/class="validated"/)
  end
  
  it "should add options if the :if Proc returns true" do
    @user.name = "Joe"
    input = @builder.text_field(:last_name, :validate => true)
    
    input.should match(/required="required"/)
    input.should match(/class="validated"/)
  end
  
  it "should not add any options if the :if Proc returns false" do
    input = @builder.text_field(:last_name, :validate => true)
    
    input.should_not match(/required="required"/)
    input.should_not match(/class="validated"/)
  end
  
  it "should add options if the method assigned to :if returns true" do
    @user.last_name = "Doe"
    input = @builder.text_field(:maiden_name, :validate => true)
    
    input.should match(/required="required"/)
    input.should match(/class="validated"/)
  end
  
  it "should not add any options if the method assigned to :if returns false" do
    input = @builder.text_field(:maiden_name, :validate => true)
    
    input.should_not match(/required="required"/)
    input.should_not match(/class="validated"/)
  end
  
  it "should add data-validates with validator names" do
    input = @builder.text_field(:name, :validate => true)
    input.should match(/dupa/)
  end
end