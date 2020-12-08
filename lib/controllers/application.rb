module Controllers
  module Application

    private
    def current_client
      current_user.try(:client)
    end

    def current_firm
      current_user.try(:firm)
    end
  end
end