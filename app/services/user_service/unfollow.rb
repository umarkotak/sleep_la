module UserService
  class Unfollow < BaseService
    def initialize(user, params = {})
      @user = user
      @params = params.permit(:user_guid)
    end

    def call
      validate
      execute_logic
      @result
    end

    private

    def validate
      raise ConstErr::UNAUTHORIZED if @user.blank?

      raise ConstErr::MISSING_USER_GUID_TO_UNFOLLOW if @params[:user_guid].blank?
    end

    def execute_logic
      target_user = User.find_by!(guid: @params[:user_guid])

      raise ConstErr::CANNOT_UNFOLLOW_SELF if target_user.id == @user.id

      UserFollow.where(
        from_user_id: @user.id,
        to_user_id: target_user.id
      ).delete_all

      @result = nil
    end
  end
end
