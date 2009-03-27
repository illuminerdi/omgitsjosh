class Comment < ActiveRecord::Base
  validates_presence_of :body
  
  belongs_to :picture
  
  validates_length_of :body, :maximum => 60
end
