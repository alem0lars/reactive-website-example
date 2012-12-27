ActiveAdmin::Dashboards.build do

  section "Recent Projects" do
    table_for Project.listing.limit(6) do |project|
      column :name
      column :website
      column :total_branches
      column :total_builds
    end
    strong { link_to 'View All Projects', admin_projects_path }
  end

end
