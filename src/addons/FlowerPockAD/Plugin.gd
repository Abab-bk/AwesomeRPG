@tool
extends EditorPlugin

var export_plugin : AndroidExportPlugin

func _enter_tree():
    export_plugin = AndroidExportPlugin.new()
    add_export_plugin(export_plugin)
    add_autoload_singleton("PockAD", "PockAD.gd")


func _exit_tree():
    remove_export_plugin(export_plugin)
    export_plugin = null
    remove_autoload_singleton("v")


class AndroidExportPlugin extends EditorExportPlugin:
    var _plugin_name = "PockAD"

    func _supports_platform(platform):
        if platform is EditorExportPlatformAndroid:
            return true
        return false

    # func _get_android_libraries(platform, debug):
    #     if debug:
    #         return PackedStringArray([
    #         "FlowerTapTapSDK/bin/debug/RealTapSDK-debug.aar",
    #         ])
    #     else:
    #         return PackedStringArray([
    #         "FlowerTapTapSDK/bin/release/RealTapSDK-release.aar",
    #         ])
    

    # func _get_android_dependencies(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
    #     return PackedStringArray([
    #         "cn.leancloud:storage-android:8.2.19",
    #     ])

    func _get_android_manifest_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
        return """
        <uses-permission android:name="android.permission.INTERNET"></uses-permission>
        """

    func _get_name():
        return _plugin_name
