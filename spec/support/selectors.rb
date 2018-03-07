module Selectors
  Capybara.add_selector(:linkhref) do
    xpath {|href| ".//a[@href='#{href}']"}
  end
  Capybara.add_selector(:link_data_form_url) do
    xpath {|href| ".//a[@data-form-url='#{href}']"}
  end
end
