class VersionManager < ActiveRecord::Base
  attr_accessible :kind, :version

  validates :kind,    presence: true,
                      format: {with: /\A\w.+\Z/, message: 'only words are allowed'}
  validates :version, presence: true,
                      format: {with: /\A\w.+\Z/, message: 'only words are allowed'}

  has_many :steps
end
