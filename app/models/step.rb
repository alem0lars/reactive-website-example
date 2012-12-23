class Step < ActiveRecord::Base
  attr_accessible :name

  validates :name,  presence: true,
                    format: {with: /\A\w.+\Z/, message: 'only words are allowed'}

  validates_presence_of :build

  belongs_to :build
  belongs_to :version_manager
  has_many :actions

  # Returns a list of {id => <id>, value => <value>}
  def self.summary(build_id)

    query = where('steps.build_id = ?', build_id)

    query.inject([]) do |memo, step|
      memo << {:id => step.id, :value => step.name}
    end
  end

end
