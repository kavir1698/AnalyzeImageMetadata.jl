module AnalyzeImageMetadata

using ImageMagick
using Dates
using DataFrames
using CSV

include("plots.jl")

const desired_tags = ["exif:XResolution", "exif:YResolution", "exif:BrightnessValue", "exif:FocalLength", "exif:DateTime", "exif:Make", "exif:FocalLengthIn35mmFilm", "exif:MaxApertureValue", "exif:Model", "exif:FNumber", "exif:ExposureTime", "exif:MeteringMode", "exif:Flash", "exif:ISOSpeedRatings", "exif:ExposureBiasValue", "exif:ResolutionUnit"]


struct ImageMetaData
  XResolution::Union{Int64, Missing} # in ResolutionUnit
  YResolution::Union{Int64, Missing} # in ResolutionUnit
  ResolutionUnit::Union{String, Missing}
  BrightnessValue::Union{Float64, Missing}
  FocalLength::Union{Int64, Missing}
  Date::Union{Date, Missing}
  Time::Union{Time, Missing}
  Make::Union{String, Missing}  # Camera maker
  FocalLengthIn35mmFilm::Union{Int64, Missing}
  MaxApertureValue::Union{Float64, Missing}
  Model::Union{String, Missing}  # Camera model
  FNumber::Union{Float64, Missing}  # The f-number of an optical system is the ratio of the system's focal length to the diameter of the entrance pupil. It is a dimensionless number that is a quantitative measure of lens speed, and an important concept in photography. It is also known as the focal ratio, f-ratio, or f-stop. It is the reciprocal of the relative aperture.
  ExposureTime::Union{Float64, Missing} # in seconds
  ExposureBias::Union{Float64, Missing}
  MeteringMode::Union{String, Missing}
  Flash::Union{String, Missing}
  ISO::Union{Int64, Missing}
end

""" 
  ImageMetaData(exif_dict::Dict)

Convert a dictionary of exif data to appropriate types and create an ImageMetaData object.
"""
function ImageMetaData(exif_dict::Dict)

  XResolution = exif_dict["exif:XResolution"] == nothing ? missing : parse(Int64, split(exif_dict["exif:XResolution"], "/")[1])

  YResolution = exif_dict["exif:YResolution"] == nothing ? missing : parse(Int64, split(exif_dict["exif:YResolution"], "/")[1])

  FocalLength = exif_dict["exif:FocalLength"] == nothing ? missing : Int64(evalexpression(Meta.parse(exif_dict["exif:FocalLength"])))

  ResolutionUnit = exif_dict["exif:ResolutionUnit"] == nothing ? missing : exif_dict["exif:ResolutionUnit"]

  BrightnessValue = exif_dict["exif:BrightnessValue"] == nothing ? missing : evalexpression(Meta.parse(exif_dict["exif:BrightnessValue"]))

  date, ttime = exif_dict["exif:DateTime"] == nothing ? (missing, missing) : (Date(split(exif_dict["exif:DateTime"])[1], Dates.DateFormat("y:m:d")), Time(split(exif_dict["exif:DateTime"])[2]))

  Make = exif_dict["exif:Make"] == nothing ? missing : exif_dict["exif:Make"]

  FocalLengthIn35mmFilm = exif_dict["exif:FocalLengthIn35mmFilm"] == nothing ? missing : parse(Int64, exif_dict["exif:FocalLengthIn35mmFilm"])

  MaxApertureValue = exif_dict["exif:MaxApertureValue"] == nothing ? missing : evalexpression(Meta.parse(exif_dict["exif:MaxApertureValue"]))
  
  Model = exif_dict["exif:Model"] == nothing ? missing : exif_dict["exif:Model"]

  FNumber = exif_dict["exif:FNumber"] == nothing ? missing : evalexpression(Meta.parse(exif_dict["exif:FNumber"]))

  ExposureTime = exif_dict["exif:ExposureTime"] == nothing ? missing : evalexpression(Meta.parse(exif_dict["exif:ExposureTime"]))

  ExposureBias = exif_dict["exif:ExposureBiasValue"] == nothing ? missing : evalexpression(Meta.parse(exif_dict["exif:ExposureBiasValue"]))

  MeteringMode = exif_dict["exif:MeteringMode"] == nothing ? missing : exif_dict["exif:MeteringMode"]

  Flash = exif_dict["exif:Flash"] == nothing ? missing : exif_dict["exif:Flash"]

  ISO = exif_dict["exif:ISOSpeedRatings"] == nothing ? missing : parse(Int64, exif_dict["exif:ISOSpeedRatings"])

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
  exif_dict = magickinfo(imagefile, desired_tags)  # this is a bottleneck. exiftool is way faster
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
  imagefiles, exif_objects = return_exif_dir(imagedir::String, imageformat::String)

Return exif objects for each image in a directory
"""
function return_exif_dir(imagedir::String, imageformat::String)
  imagefiles = return_images(imagedir, imageformat)
  exif_objects = Array{ImageMetaData}(undef, length(imagefiles))
  for (index, ff) in enumerate(imagefiles)
   exif_objects[index] = ImageMetaData(return_exif(ff))
  end
  return imagefiles, exif_objects
end

function objects_to_df(imagedir::String, imageformat::String)
  outfile = joinpath(imagedir, "images_metadata.csv")
  if isfile(outfile)
    colnames = collect(fieldnames(ImageMetaData))
    fieldtypes = [fieldtype(ImageMetaData, i) for i in colnames]
    df = CSV.read(outfile, delim='\t', header=1, quotechar='"', missingstring="", types=fieldtypes)
    return df
  end

  imagefiles, exif_objects = return_exif_dir(imagedir, imageformat)

  colnames = collect(fieldnames(ImageMetaData))
  ncols = length(colnames)
  nfiles = length(exif_objects)
  fieldtypes = [fieldtype(ImageMetaData, i) for i in colnames]

  allcolumns = [Array{fieldtypes[i], 1}(undef, nfiles) for i in 1:ncols]
  for cc in 1:ncols
    for index in 1:nfiles
      allcolumns[cc][index] = getfield(exif_objects[index], colnames[cc])
    end
  end

  df = DataFrame(allcolumns, colnames)

  CSV.write(outfile, df, delim='\t', writeheader=true, quotechar='"', missingstring="")

  return df
end

# TODO: put an option to find images recursively or only the current dir
# TODO: include multiple image formats in one analysis
function main(imagedir::String; imageformat::String="jpg")
  df = objects_to_df(imagedir, imageformat)
  
end

end # module
