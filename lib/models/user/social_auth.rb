module Models
  module User
    module SocialAuth
      extend ActiveSupport::Concern

      def connected_to?(provider)
        social_account_for(provider).present?
      end

      def social_account_for(provider)
        provider_class = SocialAccount.class_by_provider(provider)
        # force preload with one query
        social_accounts.to_a.detect { |a| a.is_a?(provider_class) }
      end
    end
  end
end
