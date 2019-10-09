class RepositoriesController < ApplicationController
  def index
    @repositories = current_user.repositories
  end

  def show
    @repository = Repository.find(params[:id])
    if @repository.user == current_user
      render :show
    else
      redirect_to root_path, notice: 'you can only view your own repos!'
    end
  end

  def create
    @repo = Repository.new(url: params[:repository][:url], user: current_user)
    if @repo.save
      remote_repo = GithubRemoteRepository.new(@repo)
      remote_repo.create_issues
      remote_repo.create_webhook
    end
    respond_to do |f|
      f.js
      f.html { head :no_content && nil }
    end
  end
end
