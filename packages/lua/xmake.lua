package("lua")
    set_homepage("https://github.com/walterschell/Lua")
    set_description("A powerful, efficient, lightweight, embeddable scripting language")

    add_urls("https://github.com/lua/lua/archive/refs/tags/$(version).tar.gz",
             "https://github.com/lua/lua.git")

    add_versions("v5.4.7", "5c39111b3fc4c1c9e56671008955a1730f54a15b95e1f1bd0752b868b929d8e3")

    add_patches("v5.4.7", path.join(os.scriptdir(), "patches", "lua.patch"))

    add_includedirs("include/lua")

    on_load(function (package)
        package:set("installdir", path.join(os.projectdir(), "build", package:plat() .. "-" .. package:arch()))
    end)

    on_install(function (package)
        -- local configs = {
        --     "-DLUA_BUILD_BINARY=OFF",
        --     "-DLUA_BUILD_COMPILER=OFF",
        --     "-DLUA_ENABLE_TESTING=OFF",
        --     "-DLUA_SUPPORT_DL=ON"
        -- }

        -- table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:is_debug() and "Debug" or "Release"))
        -- table.insert(configs, "-DLUA_ENABLE_SHARED=" .. (package:config("shared") and "ON" or "OFF"))

        local sourcedir = os.isdir("src") and "src/" or "" -- for tar.gz or git source
        io.writefile("xmake.lua", format([[
            add_rules("mode.release", "mode.debug")
            add_rules("utils.install.cmake_importfiles")

            local sourcedir = "%s"
            local kind = "%s"
            target("lua")
                set_kind(kind)
                add_headerfiles(sourcedir .. "*.h", {prefixdir = "lua"})
                add_headerfiles(sourcedir .. "lua.hpp", {prefixdir = "lua"})
                add_files(sourcedir .. "*.c|lua.c|luac.c|onelua.c")
                add_defines("LUA_COMPAT_5_2", "LUA_COMPAT_5_1")
                if is_plat("linux", "bsd", "cross") then
                    add_defines("LUA_USE_LINUX")
                    add_defines("LUA_DL_DLOPEN")
                elseif is_plat("macosx", "iphoneos") then
                    add_defines("LUA_USE_MACOSX")
                    add_defines("LUA_DL_DYLD")
                elseif is_plat("windows", "mingw") then
                    -- Lua already detects Windows and sets according defines
                    if is_kind("shared") then
                        add_defines("LUA_BUILD_AS_DLL", {public = true})
                    end
                end
        ]], sourcedir,
            package:config("shared") and "shared" or "static"))

        local configs = {}
        if package:config("shared") then
            configs.kind = "shared"
        end

        import("package.tools.xmake").install(package, configs)
    end)
