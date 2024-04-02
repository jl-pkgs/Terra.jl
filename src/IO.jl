"""
    readGDAL(file::String, options...)
    readGDAL(files::Array{String,1}, options)

# Arguments:
- `options`: other parameters to `ArchGDAL.read(dataset, options...)`.

# Return
"""
function readGDAL(file::AbstractString, options...)
  ArchGDAL.read(file) do dataset
    ArchGDAL.read(dataset, options...)
  end
end

# read multiple tiff files and cbind
function readGDAL(files::Vector{<:AbstractString}, options...)
  # bands = collect(bands)
  # bands = collect(Int32, bands)
  res = map(file -> readGDAL(file, options...), files)
  res
  # vcat(res...)
end


export readGDAL
