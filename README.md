# ValidatedFields

ValidatedFields is a set of helpers for unobtrusive frontend validations using HTML5 attributes, Rails 3 validators and JavaScript.

It overrides the default rails form helpers and uses Validator reflection to gather validation rules declared in model classes.

**This plugin is in early stages of development.**

## Usage

Here's a basic example, just to give you an idea what the plugin does:

    class User < ActiveRecord::Base
      validates :name, :presence => true, :message => 'Name is required'
    end
    
    <%= form_for @user do |f| %>
      <%= f.text_field :name, :validate => true %>
    <% end %>
    
The text field would look like this:

    <input class="validated" data-validates="presence" data-error-presence="Name is required" id="user_name" name="user[name]" required="required" type="text" />
    
Once we have those custom attributes, we can easily validate the field using JavaScript. The gem comes with a simple and extendable JS validator:

    rails generate validated_fields:javascript
    
The command above will install `validated-fields.js` file in your `public/javascripts/` directory. All you need to do in order to use the built-in validators is to include the .js file and implement validation callbacks:

    $(document).ready(function() {
		ValidatedFields.initialize(
		    // function called when validation fails
		    function(element, errorMsg) {
		        element.css('border', '1px red solid');
			    element.next('span.error').html(errorMsg);
		    },
		    
		    // function called when validation succeeds
		    function(element) {
		        element.css('border', '1px green solid');
		        element.next('span.error').html('');
		    }
		);
	});


### Installation

Add the following line to your Gemfile and run `bundle install`:

    gem 'validated_fields', :git => 'http://github.com/pch/validated-fields.git'

### Standard validation

By default validated_field supports the following built-in validators:

* presence
* format
* length
* numericality

### Custom validator classes 

If you'd like use your own validators, you'll need to create a module with `prepare_options` method:

    class EmailValidator < ActiveModel::EachValidator
      EMAIL_REGEX = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
    
      def validate_each(record, attribute, value)
        record.errors[attribute] << (options[:message] || "invalid email format") unless value =~ EMAIL_REGEX
      end
    end
    
    class User
      validates :email, :email => true
    end
    
    module ValidatedField
      module Validators
        module EmailValidator
          def self.prepare_options(validator, options)
            options[:pattern] = EmailValidator.EMAIL_REGEX.inspect
            options["data-error-email"] = validator.options[:message] if validator.options[:message].present?
            options
          end
        end
      end
    end

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

### Copyright

* Piotr Chmolowski
* Peder Linder
* Kim Moumen
