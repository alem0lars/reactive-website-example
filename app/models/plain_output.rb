class PlainOutput < Output
  attr_accessible :content_kind

  validates :content,       presence: true,
                            uniqueness: {scope: :content_kind}
  validates :content_kind,  presence: true

  validate :absence_of_name
  def absence_of_name
    errors.add('a PlainOutput cannot have a name') unless name.nil?
  end
end
