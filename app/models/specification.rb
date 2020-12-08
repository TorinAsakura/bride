# == Schema Information
#
# Table name: specifications
#
#  id         :integer          not null, primary key
#  sphere_id  :integer
#  name       :string(255)
#  title      :string(255)
#  unit       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  value      :string(255)
#  icon_id    :integer
#

class Specification < ActiveRecord::Base
  belongs_to :sphere
  belongs_to :icon
  attr_accessible :icon_id, :name, :title, :unit, :value

  #mount_uploader :icon, IconUploader

end
