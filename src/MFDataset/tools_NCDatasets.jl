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
    # "x", "y", "z",
    "time", "time_bounds"]
  setdiff(vars, [dims; dims .* "_bnds"; "height"])
end

# guess file type
function nc_st_bbox(file)
  nc_open(file) do nc
    lat = nc[r"lat"][:]
    lon = nc[r"lon"][:]
    st_bbox(lon, lat)
  end
end

function Base.getindex(ds::NCDataset, pattern::Regex)
  _keys = keys(ds)
  _id = grep(_keys, pattern)[1]
  _name = _keys[_id]
  ds[_name]
end

