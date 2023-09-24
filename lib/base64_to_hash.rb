module Base64ToHash

  def convert(img)
    {
      io: StringIO.new(Base64.decode64(img.split(",")[1])),
      filename: "cam_base64_image.png",
      content_type: img.split(/:|;/)[1]
    }
  end

end
