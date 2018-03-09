module ApplicationHelper
  def dashboard_widget_call_center_name(data)
    "Unknown"
  end

  def color_based_on_number(number, number_to_compare, value_if_true, value_if_false)
    number == number_to_compare ? value_if_true : value_if_false
  end
end
