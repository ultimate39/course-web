set :application, 'course-web'
set :repo_url, 'git@github.com:ultimate39/course-web.git'
set :scm, :git
set :branch, "master"
set :user, "deploy"
set :use_sudo, false
set :rails_env, "production"
set :deploy_via, :copy
set :keep_realeases, 5
set :deploy_to, '/home/deploy/workspace/rails/course-web'
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :stages, %w(testing staging production) 
set :default_stage, 'staging'
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

