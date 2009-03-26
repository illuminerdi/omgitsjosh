require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "picture has a title" do
    picture = Picture.new
    picture.content_type = "image/jpg"
    picture.data = pictures(:one).data
    
    assert ! picture.valid?
    assert picture.errors.on(:name)
  end
  
  test "picture has a content-type" do
    picture = Picture.new
    picture.name = "josh3.jpg"
    picture.data = pictures(:one).data 
    
    assert ! picture.valid?
    assert picture.errors.on(:content_type)
  end
  
  test "picture has data" do
    picture = Picture.new
    picture.name = "josh3.jpg"
    picture.content_type = "image/jpg" 
    
    assert ! picture.valid?
    assert picture.errors.on(:data)
  end
end
