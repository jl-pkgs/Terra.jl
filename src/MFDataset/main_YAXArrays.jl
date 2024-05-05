using NCDatasets.DiskArrays: GridChunks

export GridChunks, chunksize
export get_zarr, which_grid
export readRaster, writeRaster

GridChunks(z::ZArray) = GridChunks(size(z), chunksize(z))

function chunksize end
function get_zarr end
function which_grid end
function readRaster end
function writeRaster end
