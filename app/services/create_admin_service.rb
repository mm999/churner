class CreateAdminService
  def call
    user = User.find_or_create_by!(email: Figaro.env.admin_email) do |user|
        user.password = Figaro.env.admin_password
        user.password_confirmation = Figaro.env.admin_password
        user.admin!
      end
  end
end
