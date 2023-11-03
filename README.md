# Terra.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jl-pkgs.github.io/Terra.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jl-pkgs.github.io/Terra.jl/dev)
[![CI](https://github.com/jl-pkgs/Terra.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/jl-pkgs/Terra.jl/actions/workflows/CI.yml)
[![Codecov](https://codecov.io/gh/jl-pkgs/Terra.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jl-pkgs/Terra.jl)

> Dongdong Kong

This package is dependent on `Rasters.jl`, geospatial processing function are imported from there.

This package is only for my peasonal researches without warranty. *<u>Please do not use this package. On your own risks.</u>*

This package is backend tooks for my GEE whittaker smoothing algorithm for global MODIS Terra LAI reconstruction.

# Functions

- [x] 引入`bbox`，借鉴`GeoArrays.jl`定义Raster的方式，`Raster`重命名为`rast`为了与R语言`terra`保持一致，定义`rast`更加便捷；

- [x] 添加`apply`函数，与R语言`apply`函数操作方法一致；

- [x] 一些GDAL的功能，如`gdal_info`，`gdal_polygonize`。

- [ ] 核对绘图模块

- [x] zarr for MODIS global dataset

- [x] 设计一个`tiff/nc` to zarr的框架，zarr添加`bbox`信息

- [x] 全球并行计算的框架


# Installation

```
using Pkg
Pkg.add(url = "https://github.com/jl-pkgs/Terra.jl")
```

# Acknowledgement

- `Rasters.jl`

- `GeoArrays.jl`

- `YAXArrays.jl`: <https://juliadatacubes.github.io/YAXArrays.jl/dev/>

- `Zarr.jl`: <https://github.com/JuliaIO/Zarr.jl>

# Roadmaps

- `Dagger.jl`: <https://github.com/JuliaParallel/Dagger.jl>

