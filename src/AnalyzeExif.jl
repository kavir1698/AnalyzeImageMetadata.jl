module AnalyzeExif

using ImageMagick

export return_exif, return_exif_dir

const desired_tags = ["exif:XResolution", "exif:YResolution", "exif:BrightnessValue", "exif:FocalLength", "exif:DateTime", "exif:Make", "exif:FocalLengthIn35mmFilm", "exif:MaxApertureValue", "exif:Model", "exif:FNumber", "exif:ExposureTime", "exif:MeteringMode", "exif:Flash", "exif:ISOSpeedRatings"]

"""
  return_exif(imagefile::String)

Return all exif data of an image in a dictionary
"""
function return_exif(imagefile::String)
  exif_dict = magickinfo(imagefile, desired_tags)
  return exif_dict
end

"""
  return_exif(imagedir::String; imageformat::String="jpg")

Return exif data of all the image in a directory
"""
function return_exif_dir(imagedir::String; imageformat::String="jpg")
  imagefiles = Array{String}(undef, 0)
  for (root, dirs, files) in walkdir(imagedir)
    for ff in files
      if endswith(lowercase(ff), imageformat)
        push!(imagefiles, joinpath(root, ff))
      end
    end
  end

  exif_dicts = [return_exif(i) for i in imagefiles]
end



end # module
