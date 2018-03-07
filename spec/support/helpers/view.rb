module Helpers
  module View
    class PolicyMock
      attr_accessor :permitted_attributes

      def initialize(*permissions)
        @permitted_attributes = []
        add_permissions(permissions)
      end

      def allow(*permissions)
        add_permissions(permissions)
      end

      def method_missing(m, *args, &block)
        if m.to_s =~ /\?$/
          false
        else
          super
        end
      end

      private

      def add_permissions(permissions)
        permissions.each do |permission|
          define_singleton_method permission do
            true
          end
        end
      end
    end

  end
end
