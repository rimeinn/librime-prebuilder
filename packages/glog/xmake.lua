package("glog")
    set_homepage("https://github.com/google/glog/")
    set_description("C++ implementation of the Google logging module")
    set_license("BSD-3-Clause")

    add_urls("https://github.com/google/glog/archive/refs/tags/$(version).tar.gz",
             "https://github.com/google/glog.git")

    add_versions("v0.7.1", "00e4a87e87b7e7612f519a41e491f16623b12423620006f59f5688bfd8d13b08")

    add_patches("v0.7.1", path.join(os.scriptdir(), "patches", "glog.patch"))

    add_deps("cmake")

    on_install(function (package)
        local configs = {
            "-DWITH_GFLAGS=OFF",
            "-DWITH_UNWIND=OFF",
            "-DBUILD_TESTING=OFF"
        }
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))

        import("package.tools.cmake").install(package, configs)
    end)