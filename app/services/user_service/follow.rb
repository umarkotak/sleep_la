module UserService
  class Follow < BaseService
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
      raise Errors::Unauthorized if @user.blank?

      raise Errors::MissingUserGuidToFollow if @params[:user_guid].blank?
    end

    def execute_logic
      target_user = User.find_by(guid: @params[:user_guid])

      raise Errors::UserNotFound if target_user.blank?

      raise Errors::CannotFollowSelf if target_user.id == @user.id

      UserFollow.find_or_create_by!(
        from_user_id: @user.id,
        to_user_id: target_user.id
      )

      @result = nil
    end
  end
end
