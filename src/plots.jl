using Plots; gr()
using StatsBase: countmap, mean

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
  ISO_bar(df::DataFrame)

bar plot of ISO value frequencies
"""
function ISO_bar(df::DataFrame, savedir)
  if count(a->!ismissing(a), df[:ISO]) <= 10# || length(unique(df[:ISO])) <= 10
    return
  end
  counts = countmap(collect(skipmissing(df[:ISO])))
  xs = collect(keys(counts))
  y = collect(values(counts))
  sumy = sum(y)
  ys = [round(i/sumy, digits=2) for i in y]
  bar(xs, ys, label="", xlabel="ISO ratings", ylabel="Frequency", color="orange")
  outname = joinpath(savedir,"isoratings_bar.png")
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
  exposureTime_bar(df::DataFrame)

bar plot of exposureTime value frequencies
"""
function exposureTime_bar(df::DataFrame, savedir)
  if count(a->!ismissing(a), df[:ExposureTime]) <= 10# || length(unique(df[:ExposureTime])) <= 10
    return
  end
  counts = countmap(collect(skipmissing(df[:ExposureTime])))
  xs = collect(keys(counts))
  y = collect(values(counts))
  sumy = sum(y)
  ys = [round(i/sumy, digits=2) for i in y]
  bar(xs, ys, label="", xlabel="Log shutter speed (sec)", ylabel="Frequency", color="orange", xscale=:log)
  outname = joinpath(savedir, "shutterSpeed_bar.png")
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
  exposureBias_scatter(df::DataFrame)

scatter plot of exposureBias value frequencies
"""
function exposureBias_scatter(df::DataFrame, savedir)
  if count(a->!ismissing(a), df[:ExposureBias]) <= 10 #|| length(unique(df[:ExposureBias])) <= 10
    return
  end
  counts = countmap(collect(skipmissing(df[:ExposureBias])))
  xs = collect(keys(counts))
  y = collect(values(counts))
  sumy = sum(y)
  ys = [round(i/sumy, digits=2) for i in y]
  scatter(xs, ys, label="", xlabel="Exposure Bias", ylabel="Frequency", color="orange", markersize=5)
  outname = joinpath(savedir, "exposureBias_scatter.png")
  png(outname)
  return outname
end

"""
  brightness_histogram(df::DataFrame)

Histogram of brightness values
"""
function brightness_histogram(df::DataFrame, savedir)
  if count(a->!ismissing(a), df[:BrightnessValue]) <= 10
    return
  end
  j = collect(skipmissing(df[:BrightnessValue]))
  histogram(j, bins=20, label="", xlabel="Brightness", ylabel="Frequency", color="black")
  outname = joinpath(savedir, "brightness_hist.png")
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
  focalLength_scatter(df::DataFrame)

scatter plot of focal length in 35 mm film frequencies
"""
function focalLength_scatter(df::DataFrame, savedir)
  if count(a->!ismissing(a), df[:FocalLengthIn35mmFilm]) <= 10
    return
  end
  counts = countmap(collect(skipmissing(df[:FocalLengthIn35mmFilm])))
  xs = collect(keys(counts))
  y = collect(values(counts))
  sumy = sum(y)
  ys = [round(i/sumy, digits=2) for i in y]
  scatter(xs, ys, label="", xlabel="Focal length in 35 mm equivalen", ylabel="Frequency", color="orange", markersize=5)
  outname = joinpath(savedir, "focalLength_scatter.png")
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
  maxApurture_scatter(df::DataFrame)

scatter plot of max apurture values
"""
function maxApurture_scatter(df::DataFrame, savedir)
  if count(a->!ismissing(a), df[:MaxApertureValue]) <= 10
    return
  end
  counts = countmap(collect(skipmissing(df[:MaxApertureValue])))
  xs = collect(keys(counts))
  y = collect(values(counts))
  sumy = sum(y)
  ys = [round(i/sumy, digits=2) for i in y]
  scatter(xs, ys, label="", xlabel="Max apurture value", ylabel="Frequency", color="orange", markersize=5)
  outname = joinpath(savedir, "maxApurture_scatter.png")
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
  fNumber_scatter(df::DataFrame)

scatter plot of focal length frequencies
"""
function fNumber_scatter(df::DataFrame, savedir)
  counts = countmap(collect(skipmissing(df[:FNumber])))
  xs = collect(keys(counts))
  y = collect(values(counts))
  sumy = sum(y)
  ys = [round(i/sumy, digits=2) for i in y]
  scatter(xs, ys, label="", xlabel="F Number", ylabel="Frequency", color="orange", markersize=5)
  outname = joinpath(savedir, "fNumber_scatter.png")
  png(outname)
  return outname
end

"""
  datetime_heatmap(df::DataFrame)

A heatmap of date and time you have shot your photos
"""
function datetime_heatmap(df::DataFrame, savedir)
  if count(a->!ismissing(a), df[:Date]) <= 10 || count(a->!ismissing(a), df[:Time]) <= 10
    return
  end
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

  outname = joinpath(savedir, "datetime_heatmap.png")
  png(outname)
  return outname
end

"""
  isoTime_bar(df::DataFrame)

A bar plot of the average iso relative to time of the day
"""
function isoTime_bar(df::DataFrame, savedir)
  if count(a->!ismissing(a), df[:Time]) <= 10 || count(a->!ismissing(a), df[:ISO]) <= 10
    return
  end
  df[:Hour] = hour.(df[:Time])
  j = dropmissing(by(df, :Hour, d -> d.ISO))
  jmean = by(j, :Hour, d -> mean(d.x1), sort=true)

  bar(jmean[1], jmean[2], label="", xlabel="Hour", ylabel="Average ISO", color="orange")

  outname = joinpath(savedir, "isoTime_bar.png")
  png(outname)
  return outname
end



function allplots(df::DataFrame, savedir::String)
  println("Plotting...")
  exposureBias_scatter(df, savedir)
  ISO_bar(df, savedir)
  exposureTime_bar(df, savedir)
  datetime_heatmap(df, savedir)
  brightness_histogram(df, savedir)
  focalLength_scatter(df, savedir)
  maxApurture_scatter(df, savedir)
  isoTime_bar(df, savedir)
end