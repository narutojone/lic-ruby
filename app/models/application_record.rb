class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.html_string(attribute)
    define_method "#{attribute}=" do |value|
      stripped_of_html_tags = ActionController::Base.helpers.sanitize(value.to_s, Sanitize::Config::ALL_DISALLOWED)

      sanitized_value =
        if stripped_of_html_tags.blank?
          stripped_of_html_tags
        else
          ActionController::Base.helpers.sanitize(value.to_s, Sanitize::Config::WHITELIST)
        end

      write_attribute(attribute, sanitized_value)
    end
  end
end
