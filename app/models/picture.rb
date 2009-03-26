class Picture < ActiveRecord::Base
  validates_presence_of :name, :content_type, :data
end
