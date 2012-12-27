class Build < ActiveRecord::Base
  attr_accessible :finished_at, :started_at, :status

  validates_presence_of :commit
  validates_presence_of :branch

  belongs_to :commit
  belongs_to :branch
  has_many :steps

  # Returns a list of {id => <id>, value => <value>}
  def self.summary(branch_id)

    query = joins(:commit)
           .select('builds.*, commits.digest')
           .where('builds.branch_id = ?', branch_id)

    strftime = lambda { |d| d.strftime('%Y.%m.%d-%H:%M:%S') }
    query.inject([]) do |memo, build|
      memo << {:id => build.id, :value => [
        strftime.(build.started_at),
        strftime.(build.finished_at),
        build.digest[0..14]
      ]}
    end # return
  end

  # Builds listing with commit (optionally for a particular branch)
  def self.listing(branch_id = nil)
    builds = self.order('finished_at desc')
    unless branch_id.nil? # builds for the branch with the id 'branch_id'
      builds = builds.where('branch_id = ?', branch_id)
    end
    builds = builds.joins(:commit).select('builds.*, '\
      'commits.digest as commit_digest, '\
      'commits.url as commit_url, '\
      'commits.timestamp as commit_timestamp'
    ) # return
  end

end
