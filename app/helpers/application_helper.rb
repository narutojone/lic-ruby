module ApplicationHelper
  def dashboard_widget_call_center_name(data)
    "Unknown"
  end

  def color_based_on_number(number, number_to_compare, value_if_true, value_if_false)
    number == number_to_compare ? value_if_true : value_if_false
  end

  def active_when(section)
    controller_name == section.try(:downcase) ? "active" : nil
  end

  def alert_type_of(message_type)
    case message_type.to_s
    when "alert"
      "danger"
    when "notice"
      "info"
    else
      message_type
    end
  end

  def settings_icon_for(title: , icon: , url: )
    render partial: "common/setting_icon", locals: {title: title, icon: icon, url: url}
  end
end
