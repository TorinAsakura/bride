# encoding: utf-8
class FirmPageImage < Image
  mount_uploader :image, FirmPageImageUploader
  belongs_to :firm_page
  validates :image, presence: true
end
