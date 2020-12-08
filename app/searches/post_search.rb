# encoding: utf-8
class PostSearch < Searchlight::Search
  search_on Post

  searches :fragment, :community_id, :post_category_ids, :journal_id, :show_type

  def search_fragment
    f = "%#{fragment}%"
    search.where('posts.title ILIKE ? OR posts.body ILIKE ?', f, f)
  end

  def search_community_id
    search.where('posts.journal_type = \'Community\' AND posts.journal_id = ?', community_id)
  end

  def search_post_category_ids
    search.where('posts.category_id IN (?)', post_category_ids.split(','))
  end

  def search_journal_id
  end

  def search_show_type
    case show_type
    when 'starred' then search.user_favorites(journal_id)
    when 'my' then search.user_created(journal_id) 
    else search.user_owns(journal_id)
    end
  end
end
