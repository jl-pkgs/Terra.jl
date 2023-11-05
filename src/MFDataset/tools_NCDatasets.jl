using NCDatasets: NCDataset, CFVariable

function nc_open(f::AbstractString, args...; kwargs...)
  NCDataset(f, args...; kwargs...)
end

function nc_open(f::Function, args...; kwargs...)
  ds = nc_open(args...; kwargs...)
  try
    f(ds)
  finally
    @debug "closing netCDF NCDataset $(ds.ncid) $(NCDatasets.path(ds))"
    close(ds)
  end
end

# https://github.com/rafaqz/Rasters.jl/blob/master/src/sources/ncdatasets.jl
function nc_bands(ds::NCDataset)
  # v_id = NCDatasets.nc_inq_varids(ds.ncid)
  # vars = NCDatasets.nc_inq_varname.(ds.ncid, v_id)
  vars = keys(ds)
  dims = ["lon", "long", "longitude",
    "lat", "latitude",
    "lev", "level", "mlev", "plev",
    "height",
    "crs",
    "prob", "probs",
    "bnds",
    # "vertical", 
    "x", "y",
    # "z",
    "time", "time_bounds"]
  setdiff(vars, [dims; dims .* "_bnds"; "height"])
end


struct FileNetCDF
  file
end

struct FileTiff
  file
end

struct FileGDAL
  file
end

export file_ext
file_ext(file::String) = file[findlast(==('.'), file):end]

FileType = Dict(
  ".nc" => FileNetCDF,
  ".tif" => FileGDAL
)

function guess_filetype(f::String)
  ext = file_ext(f)
  FileType[ext](f)
end

function st_dims(f::String)
  x = guess_filetype(f)
  st_dims(x)
end

# guess file type
function st_dims(x::FileNetCDF)
  nc_open(x.file) do nc
    lon = nc[r"lon|x$"][:]
    lat = nc[r"lat|y$"][:]
    lon, lat
  end
end

function st_dims(x::FileGDAL)
  gdalinfo(x.file)["dims"]
end

function st_bbox(f::String)
  lon, lat = st_dims(f)
  st_bbox(lon, lat)
end

function Base.getindex(ds::NCDataset, pattern::Regex)
  _keys = keys(ds)
  _id = grep(_keys, pattern)[1]
  _name = _keys[_id]
  ds[_name]
end


export FileNetCDF
