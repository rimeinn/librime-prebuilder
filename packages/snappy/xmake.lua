package("snappy")
    set_homepage("https://github.com/google/snappy")
    set_description("A fast compressor/decompressor")

    set_urls("https://github.com/google/snappy/archive/$(version).tar.gz",
             "https://github.com/google/snappy.git")

    add_versions("1.2.2", "90f74bc1fbf78a6c56b3c4a082a05103b3a56bb17bca1a27e052ea11723292dc")

    add_deps("cmake")

    on_load(function (package)
        package:set("installdir", path.join(os.projectdir(), "build", package:plat() .. "-" .. package:arch()))
    end)

    on_install(function (package)
        -- io.replace("CMakeLists.txt", "cmake_minimum_required(VERSION 3.1)", "cmake_minimum_required(VERSION 3.3)", {plain = true})
        -- io.replace("CMakeLists.txt", "-Werror", "", {plain = true})


        local configs = {
            "-DSNAPPY_BUILD_TESTS=OFF",
            "-DSNAPPY_BUILD_BENCHMARKS=OFF"
        }
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
    
        import("package.tools.cmake").install(package, configs)
    end)
