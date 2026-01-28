package("opencc")
    set_homepage("https://github.com/BYVoid/OpenCC")
    set_description("Conversion between Traditional and Simplified Chinese.")
    set_license("Apache-2.0")

    add_urls("https://github.com/BYVoid/OpenCC/archive/refs/tags/ver.$(version).tar.gz")

    add_versions("1.2.0", "f4f86eb25e239450d075081e08594801aa063c298d21d9f6c6aa85cd55241962")

    add_patches("1.2.0", path.join(os.scriptdir(), "patches", "opencc.patch"))

    add_deps("cmake")
    add_deps("marisa", { system = false })

    on_load(function (package)
        if not package:config("shared") then
            package:add("defines", "Opencc_BUILT_AS_STATIC")
        end
    end)

    on_install(function (package)
        io.replace(
            "src/CMakeLists.txt",
            "target_link_libraries(libopencc marisa)",
            "target_link_libraries(libopencc PUBLIC Marisa::marisa)", 
            {plain = true}
        )

        local configs = {
            "-DBUILD_DOCUMENTATION=OFF",
            "-DBUILD_PYTHON=OFF",
            "-DENABLE_GTEST=OFF",
            "-DENABLE_BENCHMARK=OFF",
            "-DENABLE_DARTS=OFF",
            "-DUSE_SYSTEM_MARISA=ON",
            "-DUSE_SYSTEM_PYBIND11=OFF",
            "-DUSE_SYSTEM_RAPIDJSON=OFF",
            "-DUSE_SYSTEM_TCLAP=OFF"
        }
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))

        import("package.tools.cmake").install(package, configs)
    end)

