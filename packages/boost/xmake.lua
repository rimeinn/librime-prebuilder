package("boost")
    set_homepage("https://www.boost.org/")
    set_description("Collection of portable C++ source libraries.")
    set_license("BSL-1.0")

    add_urls("https://github.com/boostorg/boost/releases/download/boost-$(version)/boost-$(version)-cmake.tar.xz")

    add_versions("1.90.0", "aca59f889f0f32028ad88ba6764582b63c916ce5f77b31289ad19421a96c555f")

    on_install(function (package)
        local configs = {
            "-DCMAKE_INSTALL_MESSAGE=NEVER",
            "-DBOOST_INCLUDE_LIBRARIES=" .. table.concat({
                "algorithm",
                "crc",
                "dll",
                "interprocess",
                "range",
                "regex",
                "scope_exit",
                "signals2",
                "utility",
                "uuid"
            }, ";"),
            "-DBOOST_IOSTREAMS_ENABLE_BZIP2=OFF",
            "-DBOOST_IOSTREAMS_ENABLE_ZLIB=OFF",
            "-DBOOST_IOSTREAMS_ENABLE_LZMA=OFF",
            "-DBOOST_IOSTREAMS_ENABLE_ZSTD=OFF",
            "-DBOOST_INSTALL_LAYOUT=system",
        }

        import("package.tools.cmake").install(package, configs)
    end)
