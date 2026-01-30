set_project("librime-prebuilder")

add_rules("mode.debug", "mode.release", "mode.releasedbg")

includes("packages/**/xmake.lua")

add_requires(
    {
        "boost", "glog", "yaml-cpp", "marisa", "opencc", "snappy", "leveldb", "lua"
    },
    {
        system = false,
        configs = {
            mode = get_config("mode")
        }
    }
)

target("android")
    set_kind("phony")
    add_packages("boost", "glog", "yaml-cpp", "marisa", "opencc", "snappy", "leveldb", "lua")

    on_install(function (target)
        local base_dir = path.join(os.projectdir(), "out", target:name() .. "-" .. target:arch())

        for name, pkg in pairs(target:pkgs()) do
            local source_dir = pkg:installdir()
            local dest_dir = path.join(base_dir, name)

            os.rm(dest_dir)
            os.cp(source_dir, dest_dir)
        end
    end)
