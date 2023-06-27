function set_names(ra::AbstractRaster, names)
  rebuild(ra, name = names)
end

function Base.names(ra::AbstractRaster)
  ra.name
end


export set_names, names
