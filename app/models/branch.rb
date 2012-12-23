class Branch < ActiveRecord::Base
  attr_accessible :name

  validates :name,  presence: true,
                    uniqueness: {scope: :project_id},
                    format: {with: /\A\w.+\Z/, message: 'only words are allowed'}

  validates_presence_of :project

  belongs_to :project
  has_many :builds

  # Returns a list of {id => <id>, value => <value>}
  def self.summary(prj_id)

    query = where('branches.project_id = ?', prj_id)

    query.inject([]) do |memo, branch|
      memo << {:id => branch.id, :value => branch.name}
    end # return
  end

  # Branches listing with builds (optionally for a particular project)
  def self.listing(prj_id = nil)
    branches = self.order('branches.name asc')
    unless prj_id.nil? # branches for the project with id 'prj_id'
      branches = branches.where('project_id = ?', prj_id)
    end
    def branches.builds(branch_id)
      Build.listing(branch_id)
          .page(nil).per(Settings.branches.builds.listing.pages)
    end
    branches # return
  end

  # Fetch the builds for the current branch
  def self.builds(branch_id)
    Build.where('branch_id = ?', branch_id)
      .joins(:commit)
      .select('builds.*, commits.digest as commit_digest, '\
      'commits.url as commit_url, commits.timestamp as commit_timestamp') # return
  end

  # Builds Yin-Yang for the current branch
  def self.builds_yinyang(branch_id)
    { yin: Build.where('status != ? AND branch_id = ?', 'succeeded', branch_id).count(),
      yang: Build.where('status = ? AND branch_id = ?', 'succeeded', branch_id).count()
    } # return
  end

end
