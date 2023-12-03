flipud(x::AbstractArray{T,2}) where {T<:Real} = x[end:-1:1, :]
flipud(x::AbstractArray{T,3}) where {T<:Real} = x[end:-1:1, :, :]

fliplr(x::AbstractArray{T,2}) where {T<:Real} = x[:, end:-1:1]
fliplr(x::AbstractArray{T,3}) where {T<:Real} = x[:, end:-1:1, :]

# add a resample function at here

is_wsl() = Sys.islinux() && isfile("/mnt/c/Windows/System32/cmd.exe")
is_windows() = Sys.iswindows()
is_linux() = Sys.islinux()

function writelines(x::AbstractVector{<:AbstractString}, f; mode="w", eof="\n")
  fid = open(f, mode)
  @inbounds for _x in x
    write(fid, _x)
    write(fid, eof)
  end
  close(fid)
end
