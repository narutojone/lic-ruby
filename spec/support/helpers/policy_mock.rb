module Helpers
  class PolicyMock
    attr_accessor :permitted_attributes

    def initialize(*permissions)
      @forbidden_attributes = []
      forbid_permissions(permissions)
    end

    def forbid(*permissions)
      forbid_permissions(permissions)
    end

    def method_missing(m, *args, &block)
      if m.to_s =~ /\?$/
        true
      else
        super
      end
    end

    private

    def forbid_permissions(permissions)
      permissions.each do |permission|
        define_singleton_method permission do
          false
        end
      end
    end
  end
end
