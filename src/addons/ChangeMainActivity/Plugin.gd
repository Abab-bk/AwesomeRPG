@tool
extends EditorPlugin


var export_plugin : AndroidExportPlugin


func _enter_tree() -> void:
    export_plugin = AndroidExportPlugin.new()
    add_export_plugin(export_plugin)


func _exit_tree() -> void:
    remove_export_plugin(export_plugin)
    export_plugin = null


class AndroidExportPlugin extends EditorExportPlugin:
    var _plugin_name = "ChangeMainActivity"

    func _supports_platform(platform):
        if platform is EditorExportPlatformAndroid:
            return true
        return false

    func _get_android_manifest_application_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
        return """
        <activity
            android:name=".MainActivity"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
    
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        """
    
    func _get_name():
        return _plugin_name
