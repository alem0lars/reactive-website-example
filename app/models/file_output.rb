class FileOutput < Output
  attr_accessible :content, :content_kind, :name

  validates :content,       presence: true
  validates :content_kind,  presence: true
end
