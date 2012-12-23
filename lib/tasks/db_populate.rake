require 'singleton'


module DbPopulate

  def self.randomize(&block)
    res = Array(yield)
    num = res.length
    res[rand(num)] # return
  end

  class IncrementingDateTime
    include Singleton

    def initialize; @datetime = DateTime.now end
    def inc; @datetime += 1 end
  end
  def self.get_datetime
    IncrementingDateTime.instance.inc
  end

  class Next
    include Singleton

    def initialize; @items = {} end

    def get(*args)
      if @items.has_key?(args)
        value = args[@items[args]]
        # update the latest fetched index of args
        @items[args] = (@items[args] + 1) % args.length
      else
        value = args[0]
        @items[args] = 1 % args.length
      end
      value # return
    end
  end
  def self.next(*args)
    Next.instance.get(*args)
  end

  def self.url_rand(suffix = nil, required = false)
    DbPopulate.randomize do
      urls = %w(com net org).collect do |d|
        url = "http://example.#{d}"
        url << "/#{suffix}" if suffix
      end
      unless required
        urls << nil
      end
    end
  end

end

namespace :db do
  desc 'Erase and fill the database'
  task :populate => :environment do

    [ Tag, PlainOutput, FileOutput, TaggedOutput, Output, Action,
      Step, VersionManager, Build, Commit, Branch, Dependency, Project
    ].each(&:delete_all) # remove old records from the database
    system('clear')
    puts ">>> Populating the #{Rails.env} database"

    # { informations used to create records
    TASKS = OpenStruct.new( # assuming only ruby&rake actions
      data: {
        'Compile' => ['Install dependencies', 'Compile source code', 'Generate documents', 'Compile data', 'Compile extensions'],
        'Test Unit' => ['Perform unit tests'],
        'Test Integration' => ['Perform integration tests'],
        'Analysis Static' => ['Ruby -wc', 'Flog', 'Flay', 'Cane'],
        'Analysis Dynamic' => ['Perf-Tools performance analysis'],
        'Artifacts Creation' => ['Create the gem'],
        'Artifacts Deployment' => ['Deploy the gem'],
        'Products Creation' => ['Create the final product (as zip)'],
        'Products Deployment' => ['Deploy the final product', 'Check deployment location is accessible']
      }
    )
    TASKS.names = TASKS.data.each_key.to_a

    def n_of model
      { projects: 8,
        dependencies: 2,
        branches: 2,
        commits: 2,
        builds: 1,
        version_managers: 6,
        steps: 10
      }[model]
    end
    # }

    puts '>> Generating version managers'
    n_of(:version_managers).times do |version_manager|
      version_manager = VersionManager.create!(
        version: DbPopulate.next('rbx', '1.8.7', '1.9.2', '1.9.3-p0', '1.9.3'),
        kind: DbPopulate.next('rvm', 'pik')
      )
    end

    puts '>> Generating projects'
    n_of(:projects).times do |prj_idx|
      prj = Project.create!(
        name: Faker::Lorem.sentence(1)[0...24],
        description: Faker::Lorem.paragraph(rand(4)+1),
        website: DbPopulate.url_rand("projects/#{prj_idx}")
      )

      puts ">> Generating dependencies for project #{prj.id}"
      n_of(:dependencies).times do |dep_idx|
        dep = prj.dependencies.create!(
          url: DbPopulate.url_rand("projects/#{prj_idx}/dependencies/#{dep_idx}"),
          name: DbPopulate.next(*Faker::Lorem.words(n_of(:dependencies))),
          stage: DbPopulate.randomize { %w(development test production) }
        )
      end

      puts ">> Generating branches for project #{prj.id}"
      n_of(:branches).times do |branch_idx|
        branch = prj.branches.create!(name: DbPopulate.next('main', "dev_issue_0"))

        puts '>> Generating commits'
        n_of(:commits).times do |commit_idx|
          commit = Commit.create!(
            timestamp: DateTime.now,
            digest: Digest::SHA256.hexdigest("rumor_for_#{prj_idx}.#{branch_idx}.#{commit_idx}"),
            url: DbPopulate.url_rand("projects/#{prj_idx}/branches/#{branch_idx}/commits/#{commit_idx}", true)
          )

          puts ">> Generating builds for branch #{branch.id}, commit #{commit.id}"
          n_of(:builds).times do |build_idx|
            build = Build.new
            build.started_at = DbPopulate.get_datetime
            build.finished_at = DbPopulate.get_datetime
            build.status = DbPopulate.randomize { %w(fatal non_fatal succeeded) }
            build.commit = commit
            build.branch = branch
            build.save!

            puts ">> Generating steps for build #{build.id}"
            n_of(:steps).times do |step_idx|
              step = Step.new
              step.name = DbPopulate.next(*TASKS.names)
              step.version_manager = VersionManager.all[rand(VersionManager.count)]
              step.build = build
              step.save!

              puts ">> Generating actions for step #{step.id}"
              TASKS.data[step.name].length.times do |action_idx|
                started_at = DbPopulate.get_datetime
                finished_at = DbPopulate.get_datetime
                action = step.actions.create! do |r|
                  r.name = DbPopulate.next(*TASKS.data[step.name])
                  r.description = Faker::Lorem.paragraph(rand(6)+1)
                  r.status, r.started_at, r.finished_at = if step.name =~ /product.+deploy/i
                    DbPopulate.randomize { [
                      ['succeeded', started_at, finished_at],
                      ['non_fatal', started_at, finished_at],
                      ['fatal', started_at, finished_at],
                      [nil, started_at, nil],
                      [nil, nil, nil]
                    ] }
                  else
                    ['succeeded', started_at, finished_at]
                  end
                end
              end
            end
          end
        end
      end
    end

    puts '<<< Done :)'
  end
end
