# Terra.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jl-pkgs.github.io/Terra.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jl-pkgs.github.io/Terra.jl/dev)
[![CI](https://github.com/jl-pkgs/Terra.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/jl-pkgs/Terra.jl/actions/workflows/CI.yml)
[![Codecov](https://codecov.io/gh/jl-pkgs/Terra.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jl-pkgs/Terra.jl)

> Dongdong Kong

This package is dependent on `Rasters.jl`, geospatial processing function are imported from there.

This package is only for my peasonal researches without warranty. *<u>Please do not use this package. On your own risks.</u>*

This package is backend tooks for my GEE whittaker smoothing algorithm for global MODIS Terra LAI reconstruction.

# Introduction

这里重写了一些`Rasters`的函数，为了取得更高的性能（如`st_mosaic`），亦或是为了便捷性（Rasters+bbox）。

加入了Zarr和Threads多线程的支持，使他在跑全球任务时计算非常迅速，同时又不会有爆内存的问题。

这里是尝试将我的GEE LAI除噪算法移植到本地，惊奇的发现，*julia版本的算法在单个PC上的运行效率大致是GEE的5倍*。

# Functions

- [x] 引入`bbox`，定义`Raster`更加便捷；

- [x] 添加`apply`函数，与R语言`apply`函数操作方法一致；

- [x] 一些GDAL的功能，如`gdal_info`，`gdal_polygonize`。

- [x] Input框架: NCDatasets -> `MFDataset`

- [x] 全球并行计算框架，GridChunks + Threads
  

- [x] Output框架: GeoZarr, Zarr + bbox + GridChunks 

  > 划分为Grids, 每次只取一瓢饮, 节省内存, 每次计算完成结果立即保存到Zarr Grids（防止程序中途报错，计算结果全部丢失），下次只计算余下未计算过的Grids。


# Installation

```
using Pkg
Pkg.add(url = "https://github.com/jl-pkgs/Terra.jl")
```

# Acknowledgement

- `Rasters.jl`: <https://rafaqz.github.io/Rasters.jl/dev>

- `YAXArrays.jl`: <https://juliadatacubes.github.io/YAXArrays.jl/dev/>

- `Zarr.jl`: <https://github.com/JuliaIO/Zarr.jl>

# Roadmaps

- `Dagger.jl`: <https://github.com/JuliaParallel/Dagger.jl>

