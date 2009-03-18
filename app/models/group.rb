class Group < ActiveRecord::Base
  has_many :events
  has_many :locations, :through => :events
  
  validates_presence_of :name
  
  define_index do
    indexes :name, :as => :name, :sortable => true
    
    set_property :delta => true
  end
end
