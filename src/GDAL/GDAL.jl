using ArchGDAL.GDAL
using ArchGDAL.GDAL.GDAL_jll: gdalinfo_path, ogrinfo_path

include("gdal_basic.jl")
include("gdal_polygonize.jl")
include("gdalinfo.jl")

export gdal_open, gdal_close,
  nband, 
  bandnames, set_bandnames,
  # gdal_getnodata,
  gdalinfo,
  gdal_info, ogr_info
export gdal_polygonize
