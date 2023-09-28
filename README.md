# Terra.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jl-spatial.github.io/Terra.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jl-spatial.github.io/Terra.jl/dev)
[![CI](https://github.com/jl-spatial/Terra.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/jl-spatial/Terra.jl/actions/workflows/CI.yml)
[![Codecov](https://codecov.io/gh/jl-spatial/Terra.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jl-spatial/Terra.jl)

> Dongdong Kong

This package is dependent on `Rasters.jl`, most geospatial processing function are imported from there.

This package is only for my peasonal researches without warranty. Julia beginner, please do not use package.

> 个人研究中用到的一些空间数据处理函数。

# Functions

1. 引入`bbox`，借鉴`GeoArrays.jl`定义Raster的方式，`Raster`重命名为`rast`为了与R语言`terra`保持一致，定义`rast`更加便捷；

2. 添加`apply`函数，与R语言`apply`函数操作方法一致；

3. 一些GDAL的功能，如`gdal_info`，`gdal_polygonize`。

# Installation

```
using Pkg
Pkg.add(url = "https://github.com/jl-spatial/Terra.jl")
```
