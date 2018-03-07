#------------------------------------------------------------------------------
module DefaultCondition
  def add_default_condition(attribute_name, predicate_name, value)
    default_condition = build_condition(attributes:0, values: 0)
    default_condition.build_attribute(attribute_name)
    default_condition.predicate_name = predicate_name
    default_condition.build_value(value)

    return self
  end
end

#------------------------------------------------------------------------------
module Ransack
  class Search
    prepend DefaultCondition

    def sanitized_scope_args(args)
      args
    end
  end
end

#------------------------------------------------------------------------------
# Custom predicates

Ransack.configure do |config|
  config.add_predicate 'today',
    arel_predicate: 'between',
    formatter: proc { |v|
      current_time = Time.now.in_time_zone
      current_time.at_beginning_of_day..current_time.at_end_of_day
    },
    validator: proc { |v| v.present? },
    compounds: true,
    type: :string

  config.add_predicate 'yesterday',
    arel_predicate: 'between',
    formatter: proc { |v|
      yesterday = Time.now.in_time_zone - 1.day
      yesterday.at_beginning_of_day..yesterday.at_end_of_day
    },
    validator: proc { |v| v.present? },
    compounds: true,
    type: :string

  config.add_predicate 'tomorrow',
    arel_predicate: 'between',
    formatter: proc { |v|
      tomorrow = Time.now.in_time_zone + 1.day
      tomorrow.at_beginning_of_day..tomorrow.at_end_of_day
    },
    validator: proc { |v| v.present? },
    compounds: true,
    type: :string

  config.add_predicate 'this_week',
    arel_predicate: 'between',
    formatter: proc { |v|
      this_week = Time.now.in_time_zone
      this_week.at_beginning_of_week..this_week.at_end_of_week
    },
    validator: proc { |v| v.present? },
    compounds: true,
    type: :string

  config.add_predicate 'last_week',
    arel_predicate: 'between',
    formatter: proc { |v|
      last_week = Time.now.in_time_zone - 1.week
      last_week.at_beginning_of_week..last_week.at_end_of_week
    },
    validator: proc { |v| v.present? },
    compounds: true,
    type: :string

  config.add_predicate 'next_week',
    arel_predicate: 'between',
    formatter: proc { |v|
      next_week = Time.now.in_time_zone + 1.week
      next_week.at_beginning_of_week..next_week.at_end_of_week
    },
    validator: proc { |v| v.present? },
    compounds: true,
    type: :string

  config.add_predicate 'this_month',
    arel_predicate: 'between',
    formatter: proc { |v|
      this_month = Time.now.in_time_zone
      this_month.at_beginning_of_month..this_month.at_end_of_month
    },
    validator: proc { |v| v.present? },
    compounds: true,
    type: :string

  config.add_predicate 'last_month',
    arel_predicate: 'between',
    formatter: proc { |v|
      last_month = Time.now.in_time_zone - 1.month
      last_month.at_beginning_of_month..last_month.at_end_of_month
    },
    validator: proc { |v| v.present? },
    compounds: true,
    type: :string

  config.add_predicate 'in_the_past',
    arel_predicate: 'lt',
    formatter: proc { |v| Time.now },
    validator: proc { |v| v.present? },
    compounds: true,
    type: :string

  config.add_predicate 'end_of_day_lteq',
    arel_predicate: 'lteq',
    formatter: proc { |v| v.to_date.end_of_day },
    validator: proc { |v| v.present? },
    type: :string

  config.hide_sort_order_indicators = true
end
