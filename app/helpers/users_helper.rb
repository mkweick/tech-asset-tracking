module UsersHelper
  
  def user_btn(user)
    user.new_record? ? "Create User" : "Update Profile"
  end
end