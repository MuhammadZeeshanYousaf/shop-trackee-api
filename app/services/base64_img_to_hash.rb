class Base64ImgToHash < ApplicationService

  def initialize(img)
    @image = img
  end

  def call
    {
      io: StringIO.new(Base64.decode64(@image.split(",")[1])),
      filename: "cam_base64_image.png",
      content_type: @image.split(/:|;/)[1]
    }
  end

end
