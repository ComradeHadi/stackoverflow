# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.model_name.element}/#{mounted_as}/#{model.id}"
  end
end
