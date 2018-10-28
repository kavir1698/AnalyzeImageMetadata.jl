using Plots; gr()


"""
  ISO_histogram(df::DataFrame)

Histogram of ISO values
"""
function ISO_histogram(df::DataFrame)
  histogram(collect(skipmissing(df[:ISO])), bins=20, label="", xlabel="ISO ratings", ylabel="Frequency", color="black")
  outname = "isoratings_hist.png"
  png(outname)
  return outname
end

"""
  exposureTime_histogram(df::DataFrame)

Histogram of exposure times
"""
function exposureTime_histogram(df::DataFrame)
  histogram(collect(skipmissing(df[:ExposureTime])), bins=20, label="", xlabel="Exposure time (sec)", ylabel="Frequency", color="black")
  outname = "exposureTime_hist.png"
  png(outname)
  return outname
end

"""
  exposureBias_histogram(df::DataFrame)

Histogram of exposure Biases
"""
function exposureBias_histogram(df::DataFrame)
  histogram(collect(skipmissing(df[:ExposureBias])), bins=20, label="", xlabel="Exposure bias", ylabel="Frequency", color="black")
  outname = "exposureBias_hist.png"
  png(outname)
  return outname
end

"""
  brightness_histogram(df::DataFrame)

Histogram of brightness values
"""
function brightness_histogram(df::DataFrame)
  histogram(collect(skipmissing(df[:BrightnessValue])), bins=20, label="", xlabel="Brightness", ylabel="Frequency", color="black")
  outname = "brightness_hist.png"
  png(outname)
  return outname
end

"""
  focalLength_histogram(df::DataFrame)

Histogram of focal length values
"""
function focalLength_histogram(df::DataFrame)
  histogram(collect(skipmissing(df[:FocalLength])), bins=20, label="", xlabel="Focal Length", ylabel="Frequency", color="black")
  outname = "focalLength_hist.png"
  png(outname)
  return outname
end

"""
  maxAperture_histogram(df::DataFrame)

Histogram of maximum aperture values
"""
function maxAperture_histogram(df::DataFrame)
  histogram(collect(skipmissing(df[:MaxApertureValue])), bins=20, label="", xlabel="Max aperture", ylabel="Frequency", color="black")
  outname = "maxAperture_hist.png"
  png(outname)
  return outname
end

"""
  fNumber_histogram(df::DataFrame)

Histogram of F-numbers
"""
function fNumber_histogram(df::DataFrame)
  histogram(collect(skipmissing(df[:FNumber])), bins=20, label="", xlabel="F-Number", ylabel="Frequency", color="black")
  outname = "fNumber_hist.png"
  png(outname)
  return outname
end

"""
  datetime_heatmap(df::DataFrame)

A heatmap of date and time you have shot your photos
"""
function datetime_heatmap(df::DataFrame)
  dates_by_hour = dropmissing(by(df, :Date, d -> hour.(d.Time)))
  dbh_count = by(dates_by_hour, [:Date, :x1], d -> length(d.x1), sort=true)
  ys = [string(i) for i in (dbh_count[:Date])]
  unique_days = unique(ys)
  ndays = length(unique_days)
  daydict = Dict(unique_days .=> 1:ndays)
  xs = dbh_count[2]
  nhours = 24
  zs = fill(0.0, 1:ndays, 1:nhours)
  for (dd, tt, cc) in zip(ys, xs, dbh_count[3])
    ddind = daydict[dd]
    zs[ddind, tt] = convert(Float64, cc)
  end

  # aspect_ratio = 0.3/(ndays/24)
  heatmap([string(i) for i in 1:nhours], unique_days, zs, xlabel="Hour", ylabel="Date")

  outname = "datetime_heatmap.png"
  png(outname)
  return outname
end


#= TODO exposure bias as a function of exposure time
j = dropmissing(by(df, :ExposureTime, d -> d.ExposureBias))
cc = by(j, [:ExposureTime, :x1], d -> length(d.x1), sort=true)
=#
