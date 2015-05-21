class Attachment < ActiveRecord::Base
  default_scope { order(created_at: :asc) }

  belongs_to :attachable, polymorphic: true

  validates :file, presence: true

  mount_uploader :file, FileUploader

  def url
    file.url
  end
end
