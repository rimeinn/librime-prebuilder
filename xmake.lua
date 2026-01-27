set_project("librime-prebuilder")

add_rules("mode.debug", "mode.release")

includes("packages/**/xmake.lua")

add_requires(
    {
        "glog", "yaml-cpp", "marisa", "opencc", "leveldb", "lua"
    },
    {
        system = false
    }
)
