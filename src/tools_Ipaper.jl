flipud(x::AbstractArray{T,2}) where {T<:Real} = x[end:-1:1, :]
flipud(x::AbstractArray{T,3}) where {T<:Real} = x[end:-1:1, :, :]

fliplr(x::AbstractArray{T,2}) where {T<:Real} = x[:, end:-1:1]
fliplr(x::AbstractArray{T,3}) where {T<:Real} = x[:, end:-1:1, :]

# add a resample function at here
