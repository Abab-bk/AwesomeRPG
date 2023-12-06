@tool
extends EditorPlugin

# A class member to hold the editor export plugin during its lifecycle.
var export_plugin : AndroidExportPlugin

func _enter_tree():
    # Initialization of the plugin goes here.
    export_plugin = AndroidExportPlugin.new()
    add_export_plugin(export_plugin)


func _exit_tree():
    # Clean-up of the plugin goes here.
    remove_export_plugin(export_plugin)
    export_plugin = null


class AndroidExportPlugin extends EditorExportPlugin:
    # TODO: Update to your plugin's name.
    var _plugin_name = "FlowerTapSDK"

    func _supports_platform(platform):
        if platform is EditorExportPlatformAndroid:
            return true
        return false

    func _get_android_libraries(platform, debug):
        if debug:
            return PackedStringArray([
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/debug/RealTapSDK-debug.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/AntiAddiction_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/AntiAddictionUI_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/lib-rtc-1.1.0-release.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapAchievement_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapBillboard_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapBootstrap_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapCommon_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapLicense_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapLogin_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapMoment_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/THEMIS-release3.0.7.aar"
            ])
        else:
            return PackedStringArray([
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/release/RealTapSDK-release.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/AntiAddiction_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/AntiAddictionUI_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/lib-rtc-1.1.0-release.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapAchievement_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapBillboard_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapBootstrap_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapCommon_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapLicense_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapLogin_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/TapMoment_3.24.0.aar",
            "E:/Dev/Godot/AwesomeRPG/src/addons/FlowerTapTapSDK/bin/libs/THEMIS-release3.0.7.aar"
            ])


    func _get_android_dependencies(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
        return PackedStringArray([
            "cn.leancloud:storage-android:8.2.19",
            "io.reactivex.rxjava2:rxandroid:2.1.1",
            "cn.leancloud:realtime-android:8.2.19",
            "io.reactivex.rxjava2:rxandroid:2.1.1",
            
        ])

    func _get_android_manifest_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
        return """<uses-permission android:name="android.permission.INTERNET"></uses-permission>"""

    func _get_name():
        return _plugin_name
