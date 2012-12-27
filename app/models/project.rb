require 'uri'


class Project < ActiveRecord::Base
  include PgSearch

  attr_accessible :description, :name, :website

  validates :name,        presence: true,
                          format: {with: /\A\w.+\Z/, message: 'can contain only words'}
  validates :description, presence: true,
                          length: {minimum: 8}
  validates :website,     uniqueness: true,
                          format: {with: URI::regexp(%w(http https)), message: 'must be a valid http(s) url'},
                          allow_nil: true

  has_many :dependencies
  has_many :branches

  pg_search_scope :full_search,
    against: {
      name:         'A',
      website:      'B',
      description:  'D'
    },
    associated_against: {
      dependencies: [:name, :url]
    },
    using: {
      tsearch: {
        prefix: true, dictionary: 'english', normalization: 5
      }
    },
    ignoring: :accents

  def self.with_totals
    select('projects.id, projects.name, projects.description, projects.website, '\
           'projects.total as total_branches, with_total_builds.total as total_builds')
      .from(Arel.sql("(#{Project.with_total_builds.to_sql}) as with_total_builds, "\
                     "(#{Project.with_total_branches.to_sql}) as projects"))
      .where('projects.id = with_total_builds.id')
  end

  def self.with_total_builds
    select('projects.*, count(projects.id) as total')
      .joins('left outer join branches on branches.project_id = projects.id')
      .joins('left outer join builds on builds.branch_id = branches.id')
      .group('projects.id')
  end

  def self.with_total_branches
    select('projects.*, count(projects.id) as total')
      .joins('left outer join branches on branches.project_id = projects.id')
      .group('projects.id')
  end

  # Builds Yin-Yang for the current project
  def self.builds_yinyang(prj_id)
    { yin: Build.joins(:branch)
           .where('status != ? AND branches.project_id = ?', 'succeeded', prj_id)
           .count(),
      yang: Build.joins(:branch)
            .where('status = ? AND branches.project_id = ?', 'succeeded', prj_id)
            .count()
    } # return
  end

  def self.builds_history_by_date(prj_id)
    builds_history = {}

    Build.joins(:branch).where('branches.project_id = ?', prj_id)
         .order('finished_at asc').each do |build|
      date = "#{build.finished_at.year}-#{build.finished_at.month}-#{build.finished_at.day}"
      unless builds_history.has_key?(date)
        builds_history[date] = {'fatal' => 0, 'non_fatal' => 0, 'succeeded' => 0}
      end
      builds_history[date][build.status] += 1
    end

    builds_history # return
  end

  # Projects listing
  def self.listing
    self.with_totals.order('total_builds desc, projects.id asc')
  end
end
