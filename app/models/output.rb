class Output < ActiveRecord::Base
  attr_accessible :type

  validates :type,          presence: true
  validates :name,          format: {with: /\A\w.+\Z/, message: 'only words are allowed'},
                            allow_nil: true
  validates :content,       length: {minimum: 8},
                            allow_nil: true
  validates :content_kind,  format: {with: /\A\w.+\Z/, message: 'only words are allowed'},
                            allow_nil: true

  belongs_to :action
  has_many :tags
end
