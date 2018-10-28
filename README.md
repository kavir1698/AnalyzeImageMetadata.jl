# Motivation

Using this package, you can get statistics and figures about your photography habits: what are your mostly used camera settings? How often and at which times do you shoot? How do you often shoot in different lighting situations? Knowing photography habits can help in deciding which lens and camera to buy.

The package recursively reads exif data from images in a directory (currently only tested with jpg files) and reports the following plots:

* Focal length expressed in “35mm equivalent”
* Shutter speed on logarithmic scale
* Aperture
* ISO values
* ISO values as a function of time of day
* A heatmap of date and time of shooting photos
* Brightness 
* Exposure bias


# Installation

You need to have Julia language installed. Then:

```
git clone https://github.com/kavir1698/AnalyzeImageMetadata.jl.git
```

and analyze images in any directory by calling the module from the `src` directory

```
include("AnalyzeImageMetadata.jl")
```

and analyzing your images directory:

```
AnalyzeImageMetadata.main(<images dir>; imageformat=jpg)
```

# Usage
I currently use `ImageMagick.jl` for extracting EXIF data, which is slow in reading EXIF data. Please be patient when analyzing a directory for the first time.