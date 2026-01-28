package("marisa")
    set_homepage("https://github.com/s-yata/marisa-trie")
    set_description("Matching Algorithm with Recursively Implemented StorAge.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/s-yata/marisa-trie/archive/refs/tags/$(version).tar.gz",
             "https://github.com/s-yata/marisa-trie.git")

    add_versions("v0.3.1", "986ed5e2967435e3a3932a8c95980993ae5a196111e377721f0849cad4e807f3")

    add_patches("v0.3.1", path.join(os.scriptdir(), "patches", "marisa-trie.patch"))

    add_deps("cmake")

    on_install(function (package)
        local configs = {
            "-DCMAKE_POLICY_DEFAULT_CMP0057=NEW",
            "-DENABLE_TESTS=OFF",
            "-DBUILD_TESTING=OFF",
            "-DENABLE_TOOLS=OFF"
        }
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))

        import("package.tools.cmake").install(package, configs)
    end)