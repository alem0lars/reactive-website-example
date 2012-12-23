require 'uri'


class Dependency < ActiveRecord::Base
  attr_accessible :name, :stage, :url

  validates :name,  presence: true,
                    uniqueness: {scope: :project_id},
                    format: {with: /\A\w.+\Z/, message: 'only words are allowed'}
  validates :url,   format: {with: URI::regexp(%w(http https)), message: 'must be a valid http(s) url'},
                    allow_nil: true
  validates :stage, format: {with: /\A\w.+\Z/, message: 'only words are allowed'},
                    allow_nil: true

  validates_presence_of :project

  belongs_to :project

  # Dependencies listing (optionally for a particular project)
  def self.listing(prj_id = nil)
    deps = self.order('name asc')
    if prj_id.nil? # all dependencies
      deps.joins(:project).select('dependencies.*, '\
        'projects.name as project_name, '\
        'projects.website as project_website, '\
        'projects.description as project_description'
      )
    else # dependencies for the project with id 'prj_id'
      deps.where('project_id = ?', prj_id)
    end # return
  end
end
