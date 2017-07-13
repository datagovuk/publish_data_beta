class DatasetsController < ApplicationController
  before_action :authenticate_user!

  def show
    @dataset = current_dataset
  end

  def new
    @dataset = Dataset.new
  end

  def edit
    @dataset = current_dataset
  end

  def create
    @dataset = Dataset.new(params.require(:dataset).permit(:id, :title, :summary, :description))
    @dataset.creator_id = current_user.id
    @dataset.organisation = current_user.primary_organisation

    if @dataset.save
      redirect_to new_licence_path(@dataset)
    else
      render 'new'
    end
  end

  def update
    @dataset = current_dataset
    @dataset.update_attributes(params.require(:dataset).permit(:title, :summary, :description))

    if @dataset.save
      redirect_to dataset_path(@dataset)
    else
      render 'edit'
    end
  end

  def publish
    @dataset = current_dataset

    if request.post?
      @dataset.published = true
      @dataset.__elasticsearch__.index_document

      flash[:success] = I18n.t 'dataset_published'
      flash[:extra] = @dataset

      if @dataset.save
        redirect_to manage_path
      else
        @dataset.published = false
        flash[:error] = @dataset.errors
        render 'show'
      end
    end
  end

  def confirm_delete
    @dataset = current_dataset
    if @dataset.published?
      @dataset.errors.add(:delete_prevent, 'Published datasets cannot be deleted')
    else
      flash[:alert] = 'Are you sure you want to delete this dataset?'
    end
    render 'show'
  end

  def destroy
    @dataset = current_dataset
    if @dataset.published?
      @dataset.errors.add(:delete_prevent, 'Published datasets cannot be deleted')
      render 'show'
    else
      flash[:deleted] = "The dataset '#{current_dataset.title}' has been deleted"
      current_dataset.destroy
      redirect_to manage_path
    end

  end

  private
  def current_dataset
    Dataset.find_by(:name => params.require(:id))
  end

  def current_file
    Datafile.find(params.require(:file_id))
  end
end
