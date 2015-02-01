class DeliveryLoaderController < ApplicationController
  before_action :require_admin

  def index
    @todays_deliveries = Delivery.where(date: Date.today).length
  end

  # POST /upload
  def upload
    # check actually added a file to upload
    uploaded_file = params[:upload_file]
    if uploaded_file.blank?
      redirect_to upload_path, alert: 'A file must first be choosen to upload'
    else
      # save file
      upload_status = DeliveryLoader.load(uploaded_file)
      if upload_status
        save_status = DeliveryLoader.save
        if save_status == 1
          redirect_to upload_path, notice: 'File was successfully uploaded.'
        elsif save_status == 0
          redirect_to upload_path, alert: 'There was a problem saving the file.'
        elsif save_status == -1
          redirect_to customers_path, alert: 'There was a problem adding a customer. Correct below.'
        end
      else
        redirect_to upload_path, alert: 'There was a problem uploading the file.'
      end
    end
  end

end
