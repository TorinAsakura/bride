ActsAsTaggableOn.remove_unused_tags = false
ActsAsTaggableOn.force_lowercase = true

class ActsAsTaggableOn::Tagging
  #for id's mass assigment
  def tag= tag
      self.context = 'colors' if tag.color
    super
  end
end

class ActsAsTaggableOn::Tag
  COLORS = {
      "#ff0000" => 'red',
      "#ad0000" => 'vinous',
      "#ffa600" => 'orange',
      "#ffff00" => 'yellow',
      "#00ff00" => 'green',
      "#0a7a20" => 'dark_green',
      "#2bd6cb" => 'turquoise',
      "#8fcbfc" => 'blue',
      "#0000ff" => 'sapfire',
      "#ffbdc8" => 'pink',
      "#8c00ff" => 'purple',
      "#ffffff" => 'white',
      "#dedec7" => 'beige',
      "#9c4e00" => 'chocolate',
      "#000000" => 'black',
      "#b3b3b3" => 'silver',
      "#c7ae0c" => 'gold'
  }

  attr_accessible :accepted, :color, :red, :green, :blue, :color_slug

  scope :color, -> { where("color IS NOT NULL") }
  scope :text, -> { where("color IS NULL") }
  scope :accepted,  -> { where(accepted: true) }
  scope :usual, -> {where(' accepted IS NOT true AND color IS NULL')}

  validate :color_not_accepted

  validate :custom_uniq_validate

  #custom logic
  def self.like this_one
    tags = accepted.where("name LIKE ?", "%#{this_one}%")
    if tags
      unless tags.map(&:name).include?(this_one)
        tags<<ActsAsTaggableOn::Tag.new(name:this_one)
      end
    end
    tags
  end

  def count
    self.taggings.count
  end

  def self.search(name)
    name ? named_like(name) : scoped
  end

  def self.frequency_filter n
    having('count(*) >= ?',n).select('tags.*,count(*) as sqlcount').joins(:taggings).group('tags.id').order("sqlcount desc")
  end

  #monkey path original class
  def validates_name_uniqueness?
    false
  end

  def self.named_any(list)
    text.where(list.map { |tag| sanitize_sql(["name = #{binary}?", tag.to_s.mb_chars]) }.join(" OR "))
  end

  #color logic
  def save
    if self.color
      rgb = self.color.match(/#(?<R>..)(?<G>..)(?<B>..)/)
      self.red = rgb[:R].hex
      self.green = rgb[:G].hex
      self.blue = rgb[:B].hex
      self.color_slug = COLORS[self.color]
    end
    super
  end

  def self.with_colors_like color
    ret = []
    rgb = color.match(/#(?<R>..)(?<G>..)(?<B>..)/)
    self.color.each do |ct|
      delta = Math.sqrt( (ct.red - rgb[:R].hex)**2+(ct.green - rgb[:G].hex)**2+(ct.blue - rgb[:B].hex)**2 )
      ret<< ct if delta < 100
    end
    return ret
  end

  def add_to object
    if self.color && ActsAsTaggableOn::Tagging.where(:tag_id => id, :context => 'colors', :taggable_id => object.id).empty?
      object.color_taggings.create!(:tag_id => id, :context => 'colors', :taggable => object)
    end
  end


  #not color logic
  def accept!
    self.accepted = true
  end
  def disaccept!
    self.accepted = false
  end


  private

  def color_not_accepted
    errors.add(:color, "Color tag can't be accepted") if self.color && self.accepted
  end

  def custom_uniq_validate
    scope = color ? ActsAsTaggableOn::Tag.color : ActsAsTaggableOn::Tag.text
    errors.add(:name, :taken) unless scope.where(name: self.name).where('id != ?',id).empty?
  end

end