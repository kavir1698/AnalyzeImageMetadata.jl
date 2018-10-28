using Plots; gr()

"""
  exifdicts_to_dataframe(exif_objects::Array{AnalyzeExif.ImageMetaData})

Create a dataframe from the exif dicts of your images
"""
function ISO_histogram(exif_objects::Array{AnalyzeExif.ImageMetaData})
  isos = [i.ISO for i in exif_objects]
  histogram(isos)
end

