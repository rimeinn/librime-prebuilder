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
