module AnalyzeImageMetadata

using ImageMagick
using Dates

export ImageMetaData

include("plots.jl")

const desired_tags = ["exif:XResolution", "exif:YResolution", "exif:BrightnessValue", "exif:FocalLength", "exif:DateTime", "exif:Make", "exif:FocalLengthIn35mmFilm", "exif:MaxApertureValue", "exif:Model", "exif:FNumber", "exif:ExposureTime", "exif:MeteringMode", "exif:Flash", "exif:ISOSpeedRatings", "exif:ExposureBiasValue", "exif:ResolutionUnit"]


struct ImageMetaData
  XResolution::Union{Int64, Nothing} # in ResolutionUnit
  YResolution::Union{Int64, Nothing} # in ResolutionUnit
  ResolutionUnit::Union{String, Nothing}
  BrightnessValue::Union{Float64, Nothing}
  FocalLength::Union{Int64, Nothing}
  Date::Union{Date, Nothing}
  Time::Union{Time, Nothing}
  Make::Union{String, Nothing}  # Camera maker
  FocalLengthIn35mmFilm::Union{Int64, Nothing}
  MaxApertureValue::Union{Float64, Nothing}
  Model::Union{String, Nothing}  # Camera model
  FNumber::Union{Float64, Nothing}  # The f-number of an optical system is the ratio of the system's focal length to the diameter of the entrance pupil. It is a dimensionless number that is a quantitative measure of lens speed, and an important concept in photography. It is also known as the focal ratio, f-ratio, or f-stop. It is the reciprocal of the relative aperture.
  ExposureTime::Union{Float64, Nothing} # in seconds
  ExposureBias::Union{Float64, Nothing}
  MeteringMode::Union{String, Nothing}
  Flash::Union{String, Nothing}
  ISO::Union{Int64, Nothing}
end

""" 
  ImageMetaData(exif_dict::Dict)

Convert a dictionary of exif data to appropriate types and create an ImageMetaData object.
"""
function ImageMetaData(exif_dict::Dict)
  if exif_dict["exif:XResolution"] == nothing
    XResolution = nothing
  else
    XResolution = parse(Int64, split(exif_dict["exif:XResolution"], "/")[1])
  end
  if exif_dict["exif:YResolution"] == nothing
    YResolution = nothing
  else
    YResolution = parse(Int64, split(exif_dict["exif:YResolution"], "/")[1])
  end
  if exif_dict["exif:FocalLength"] == nothing
    FocalLength = nothing
  else
    FocalLength = Int64(evalexpression(Meta.parse(exif_dict["exif:FocalLength"])))
  end
  ResolutionUnit = exif_dict["exif:ResolutionUnit"]
  if exif_dict["exif:BrightnessValue"] == nothing
    BrightnessValue = nothing
  else
    BrightnessValue = evalexpression(Meta.parse(exif_dict["exif:BrightnessValue"]))
  end
  if exif_dict["exif:DateTime"] == nothing
    date = nothing
    ttime = nothing
  else
    date = Date(split(exif_dict["exif:DateTime"])[1], Dates.DateFormat("y:m:d"))
    ttime = Time(split(exif_dict["exif:DateTime"])[2])
  end
  Make = exif_dict["exif:Make"]
  if exif_dict["exif:FocalLengthIn35mmFilm"] == nothing
    FocalLengthIn35mmFilm = nothing
  else
    FocalLengthIn35mmFilm = parse(Int64, exif_dict["exif:FocalLengthIn35mmFilm"])
  end
  if exif_dict["exif:MaxApertureValue"] == nothing
    exif_dict["exif:MaxApertureValue"] = nothing
  else
    MaxApertureValue = evalexpression(Meta.parse(exif_dict["exif:MaxApertureValue"]))
  end
  Model = exif_dict["exif:Model"]
  if exif_dict["exif:FNumber"] == nothing
    exif_dict["exif:FNumber"] = nothing
  else
    FNumber = evalexpression(Meta.parse(exif_dict["exif:FNumber"]))
  end
  if exif_dict["exif:ExposureTime"] == nothing
    exif_dict["exif:ExposureTime"] = nothing
  else
    ExposureTime = evalexpression(Meta.parse(exif_dict["exif:ExposureTime"]))
  end
  if exif_dict["exif:ExposureBiasValue"] == nothing
    exif_dict["exif:ExposureBiasValue"] = nothing
  else
    ExposureBias = evalexpression(Meta.parse(exif_dict["exif:ExposureBiasValue"]))
  end
  MeteringMode = exif_dict["exif:MeteringMode"]
  Flash = exif_dict["exif:Flash"]
  if exif_dict["exif:ISOSpeedRatings"] == nothing
    ISO = nothing
  else
    ISO = parse(Int64, exif_dict["exif:ISOSpeedRatings"])
  end

  return ImageMetaData(XResolution, YResolution, ResolutionUnit, BrightnessValue, FocalLength, date, ttime, Make, FocalLengthIn35mmFilm, MaxApertureValue, Model, FNumber, ExposureTime, ExposureBias, MeteringMode, Flash, ISO)
end

function evalexpression(expr)
  return eval(expr)
end

"""
  return_exif(imagefile::String)

Return all exif data of an image in a dictionary
"""
function return_exif(imagefile::String)
  exif_dict = magickinfo(imagefile, desired_tags)  # this is a bottleneck
  return exif_dict
end

function return_images(imagedir::String, imageformat)
  imagefiles = Array{String}(undef, 0)
  for (root, dirs, files) in walkdir(imagedir)
    for ff in files
      if endswith(lowercase(ff), imageformat)
        push!(imagefiles, joinpath(root, ff))
      end
    end
  end
  return imagefiles
end

"""
  imagefiles, exif_objects = return_exif_dir(imagedir::String; imageformat::String="jpg")

Return exif objects for each image in a directory
"""
function return_exif_dir(imagedir::String; imageformat::String="jpg")
  imagefiles = return_images(imagedir, imageformat)
  exif_objects = Array{ImageMetaData}(undef, length(imagefiles))
  for (index, ff) in enumerate(imagefiles)
   exif_objects[index] = ImageMetaData(return_exif(ff))
  end
  return imagefiles, exif_objects
end

end # module
