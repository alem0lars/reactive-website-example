require 'uri'


class Commit < ActiveRecord::Base
  attr_accessible :digest, :timestamp, :url

  validates :digest,    presence: true
  validates :url,       format: {with: URI::regexp(%w(http https)), message: 'must be a valid http(s) url'},
                        allow_nil: true
  validates :timestamp, presence: true

  has_many :builds
end
