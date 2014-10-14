class Post < ActiveRecord::Base
  belongs_to :user

  after_create :to_facebook

  def to_facebook
    if self.post_on_facebook == true
      self.user.facebook.put_wall_post("#{self.body}") #these methods are on the users controller
    end
  end

end
