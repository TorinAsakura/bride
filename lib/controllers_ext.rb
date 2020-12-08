module ControllersExt
  module FirmPrivate

    private 

    def set_public_variables
      @firm ||= Firm.includes(:user).find_by_slug(request.subdomain(Subdomain.position)) ||
              Firm.includes(:user).find(params[:id])
      user  = @firm.user

      @partners, @clients = user.grouped_friends
      @clients  = @clients.sample(8) if @clients
      @partners = @partners.sample(8) if @partners
      @firm_pages = @firm.firm_pages.visible

      awaiting  = user.friendships_awaiting_acceptance.map(&:user)
      @firms_requests, @clients_requests = user.grouped_friends(awaiting)

      @latest_album = @firm.albums.reorder(:updated_at).first

      @banner   = @firm.banner_album
      @albums   = user.albums.ordered.includes(:cover)
      @photos   = user.photos.ordered.includes(:album).page(params[:page])

      @search_type = params[:search_type] || 'all'

      my_posts = Post.includes(:user, :illustration).where('journal_id = ?', user.id).reorder('posts.created_at asc')
      starred_posts = Post.includes(:user, :favorites, :illustration).where('favorites.user_id = ?', user.id).order('favorites.created_at asc')
      all_posts = Post.includes(:user, :favorites, :illustration).where('journal_id = ? OR favorites.user_id = ?', user.id, user.id).reorder('posts.created_at asc').order('favorites.created_at asc')

      posts = case @search_type
                when 'my' then my_posts
                when 'starred' then starred_posts
                else all_posts
              end

      posts = posts.search(params[:posts_search]) if params[:posts_search]

      @posts = Kaminari.paginate_array(posts.reverse).page(params[:page]).per(Post.default_per_page)

      videos = if params[:videos_search]
        MediaContent.search(params[:videos_search]).reorder('media_contents.created_at')
      else
        MediaContent.includes(:favorites).where(multimedia_type: 'User', video: true).where('media_contents.multimedia_id = ? OR favorites.user_id = ?', user.id, user.id).reorder('media_contents.created_at').order('favorites.created_at')
      end

      @videos = Kaminari.paginate_array(videos.reverse).page(params[:page]).per(MediaContent.default_per_page)

      @firm_services = @firm.firm_services.visible

      @bonus_services = Bonus::Service.list.ordered if !!current_firm && current_firm.dealer?
    end
  end

end
