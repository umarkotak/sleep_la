module JsonHelpers
  def json
    @json ||= JSON.parse(response.body)
  end
end

RSpec.configure { |c| c.include JsonHelpers, type: :request }
