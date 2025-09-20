module Errors
  class Base < StandardError
    attr_reader :http_status
  end

  class Unauthorized < Base
    def initialize(msg = "unauthorized")
      @http_status = 401
      super(msg)
    end
  end

  class MustWakeFirst < Base
    def initialize(msg = "must wake first")
      @http_status = 400
      super(msg)
    end
  end

  class MustSleepFirst < Base
    def initialize(msg = "must sleep first")
      @http_status = 400
      super(msg)
    end
  end

  class InvalidOrdering < Base
    def initialize(msg = "invalid ordering")
      @http_status = 400
      super(msg)
    end
  end

  class MissingUserGuidToFollow < Base
    def initialize(msg = "missing user guid to follow")
      @http_status = 400
      super(msg)
    end
  end

  class MissingUserGuidToUnfollow < Base
    def initialize(msg = "missing user guid to unfollow")
      @http_status = 400
      super(msg)
    end
  end

  class CannotFollowSelf < Base
    def initialize(msg = "cannot follow self")
      @http_status = 400
      super(msg)
    end
  end

  class CannotUnfollowSelf < Base
    def initialize(msg = "cannot unfollow self")
      @http_status = 400
      super(msg)
    end
  end

  class MissingLoginCredentials < Base
    def initialize(msg = "missing login credentials")
      @http_status = 400
      super(msg)
    end
  end

  class UserNotFound < Base
    def initialize(msg = "user not found")
      @http_status = 404
      super(msg)
    end
  end
end
