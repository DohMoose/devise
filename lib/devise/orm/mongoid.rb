 module Devise
   module Orm
     module Mongoid
       module InstanceMethods
         def save(options={})
           if options == false
             super(:validate => false)
           else
             super
           end
         end
       end

       def self.included_modules_hook(klass)
         klass.send :extend,  self
         klass.send :include, InstanceMethods
         yield

         klass.devise_modules.each do |mod|
           klass.send(mod) if klass.respond_to?(mod)
         end
       end

       include Devise::Schema

       # Tell how to apply schema methods. This automatically converts DateTime
       # to Time, since MongoMapper does not recognize the former.
       def apply_schema(name, type, options={})
         return unless Devise.apply_schema
         type = Time if type == DateTime
         field name,options.merge(:type=>type)
       end
     end
   end
 end


Mongoid::Document::ClassMethods.class_eval do
  include Devise::Models
  include Devise::Orm::Mongoid
end
