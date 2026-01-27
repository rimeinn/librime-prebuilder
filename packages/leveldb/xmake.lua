package("leveldb")
    set_homepage("https://github.com/google/leveldb")
    set_description("LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values.")
    set_license("BSD-3-Clause")

    add_urls("https://github.com/google/leveldb/archive/refs/tags/$(version).tar.gz",
             "https://github.com/google/leveldb.git", {submodules = false})

    add_versions("1.23", "9a37f8a6174f09bd622bc723b55881dc541cd50747cbd08831c2a82d620f6d76")

    add_deps("cmake")
    add_deps("snappy", { system = false })

    on_load(function (package)
        package:set("installdir", path.join(os.projectdir(), "build", package:plat() .. "-" .. package:arch()))
    end)

    on_install(function (package)
        if package:config("shared") then
            package:add("defines", "LEVELDB_SHARED_LIBRARY")
        end

        local configs = {
            "-DLEVELDB_BUILD_TESTS=OFF",
            "-DLEVELDB_BUILD_BENCHMARKS=OFF"
        }
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)
