require 'rails/generators/generated_attribute'

class UserSession < Authlogic::Session::Base
  def to_key
    #new_record? ? ['a'] : [ self.send(self.class.primary_key) ]
    self.keys.to_a
  end
end
