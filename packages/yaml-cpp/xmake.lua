package("yaml-cpp")
    set_homepage("https://github.com/jbeder/yaml-cpp/")
    set_description("A YAML parser and emitter in C++")
    set_license("MIT")

    add_urls("https://github.com/jbeder/yaml-cpp/archive/refs/tags/$(version).tar.gz",
             "https://github.com/jbeder/yaml-cpp.git")

    add_versions("0.8.0", "fbe74bbdcee21d656715688706da3c8becfd946d92cd44705cc6098bb23b3a16")

    add_deps("cmake")

    on_install(function (package)
        local configs = {
            "-DYAML_CPP_BUILD_CONTRIB=OFF",
            "-DYAML_CPP_BUILD_TESTS=OFF",
            "-DYAML_CPP_BUILD_TOOLS=OFF"
        }
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))

        import("package.tools.cmake").install(package, configs)
    end)
