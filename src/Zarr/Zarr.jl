using Zarr
using JSON

zarr_rm(p) = rm(p, recursive=true, force=true)

## DirectoryStore
function zarr_group(s::String; overwrite=false, mode="w", kw...)
  if overwrite && isdir(s)
    rm(s, recursive=true, force=true)
  end
  isdir(s) ? zopen(s, mode) : zgroup(s; kw...)
end

# true : 运行结束
# false: 未结束
chunk_task_finished(z::ZArray, ichunk) = z.attrs["task"][ichunk]

function chunk_task_finished!(z::ZArray, ichunk, value=true)
  z.attrs["task"][ichunk] = value
  f = "$(z.storage.folder)/$(z.path)/.zattrs"
  open(f, "w") do fid
    JSON.print(fid, z.attrs)
  end
end

function get_zarr end


export zarr_rm, zarr_group, chunk_task_finished, chunk_task_finished!
export geo_zcreate, get_zarr
