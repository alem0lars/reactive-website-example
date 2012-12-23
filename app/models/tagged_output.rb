class TaggedOutput < Output
  attr_accessible :name

  validates :name,  presence: true,
                    format: {with: /\A\w.+\Z/, message: 'only words are allowed'}

  validate :absence_of_content_and_kind
  def absence_of_content_and_kind
    unless content.nil? || content_kind.nil?
      errors.add('content and content_kind are not valid in a TaggedOutput')
    end
  end

  has_many :tags
end
