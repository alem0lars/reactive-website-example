class Tag < ActiveRecord::Base
  attr_accessible :name

  validates :name,  presence: true,
                    uniqueness: {scope: :tagged_output_id},
                    format: {with: /\A\w.+\Z/, message: 'only words are allowed'}

  validates_presence_of :tagged_output
  validates_presence_of :output

  belongs_to :tagged_output
  belongs_to :output
end
