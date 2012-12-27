class Action < ActiveRecord::Base
  attr_accessible :description, :finished_at, :name, :started_at, :status

  validates :name,        presence: true,
                          uniqueness: {scope: :step_id},
                          format: {with: /\A\w.+\Z/, message: 'only words are allowed'}
  validates :description, length: {minimum: 8},
                          allow_nil: true
  validates :status,      inclusion: {in: %w(fatal non_fatal succeeded), message: "must be included in [fatal, non_fatal, succeeded]"},
                          allow_nil: true
  validates :started_at,  presence: true, unless: 'finished_at.nil?'
  validates :finished_at, presence: true, unless: 'status.nil?'
  validates :status,      presence: true, unless: 'finished_at.nil?'

  validate :started_minor_than_finished
  def started_minor_than_finished
    unless started_at.blank? || finished_at.blank? || (started_at < finished_at)
      errors.add(:started_at, 'must be less than finished_at')
    end
  end

  validates_presence_of :step

  belongs_to :step
  has_many :outputs

  # Returns a list of {id => <id>, value => <value>}
  def self.summary(step_id)

    query = where('actions.step_id = ?', step_id)

    query.inject([]) do |memo, action|
      memo << {:id => action.id, :value => action.name}
    end
  end

end
