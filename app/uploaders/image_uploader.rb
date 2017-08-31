class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_limit => [700, 700]

  version :thumb do
    process resize_to_fit: [200, 200]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

end
