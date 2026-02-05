package("opencc")
    set_homepage("https://github.com/BYVoid/OpenCC")
    set_description("Conversion between Traditional and Simplified Chinese.")
    set_license("Apache-2.0")

    add_urls("https://github.com/BYVoid/OpenCC/archive/refs/tags/ver.$(version).tar.gz",
             "https://github.com/BYVoid/OpenCC.git", { submodules = false })

    add_versions("1.1.9", "ad4bcd8d87219a240a236d4a55c9decd2132a9436697d2882ead85c8939b0a99")

    add_patches("1.1.9", path.join(os.scriptdir(), "patches", "opencc.patch"))

    add_deps("cmake", "python 3.x", {kind = "binary"})
    add_deps("marisa", { system = false })

    on_install(function (package)
        io.replace(
            "src/CMakeLists.txt",
            "target_link_libraries(libopencc marisa)",
            "target_link_libraries(libopencc PUBLIC Marisa::marisa)", 
            {plain = true}
        )

        local configs = {
            "-DSHARE_INSTALL_PREFIX=share",
            "-DINCLUDE_INSTALL_DIR=include",
            "-DSYSCONF_INSTALL_DIR=etc",
            "-DLIB_INSTALL_DIR=lib",
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

        local archive_name = table.concat({package:name(), package:arch()}, "-")
        local archive_file = path.join(os.projectdir(), "out", package:plat(), archive_name .. ".tar.xz")

        local opt = {
            recurse = true,
            compress = "best",
            curdir = package:installdir()
        }

        local archive_dirs = {}
        for _, dir in ipairs(os.dirs(path.join(opt.curdir, "*"))) do
            table.insert(archive_dirs, path.filename(dir))
        end

        import("utils.archive").archive(archive_file, archive_dirs, opt)
    end)

