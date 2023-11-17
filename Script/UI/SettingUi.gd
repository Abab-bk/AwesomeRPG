extends Control

enum SETTING_KEYS {
    AUDIO_MAIN,
    AUDIO_SFX,
    AUDIO_MUSIC
}

@onready var title_bar:MarginContainer = %TitleBar

@onready var main_sound_slider:HSlider = %MainSoundSlider
@onready var sfx_slider:HSlider = %SfxSlider
@onready var music_slider:HSlider = %MusicSlider

var cancel_event:Callable = func():
    SoundManager.play_ui_sound(load(Master.CLICK_SOUNDS))
    owner.change_page(owner.PAGE.HOME)


func _ready() -> void:
    title_bar.cancel_callable = cancel_event
    main_sound_slider.value_changed.connect(change_audio_db.bind(SETTING_KEYS.AUDIO_MAIN))
    sfx_slider.value_changed.connect(change_audio_db.bind(SETTING_KEYS.AUDIO_SFX))
    music_slider.value_changed.connect(change_audio_db.bind(SETTING_KEYS.AUDIO_MUSIC))

    change_audio_db(main_sound_slider.value, SETTING_KEYS.AUDIO_MAIN)
    change_audio_db(sfx_slider.value, SETTING_KEYS.AUDIO_SFX)
    change_audio_db(music_slider.value, SETTING_KEYS.AUDIO_MUSIC)

func change_audio_db(_value:float, _key:SETTING_KEYS) -> void:
    match _key:
        SETTING_KEYS.AUDIO_MAIN:
            SoundManager.set_music_volume(_value)
        SETTING_KEYS.AUDIO_SFX:
            SoundManager.set_sound_volume(_value)
        SETTING_KEYS.AUDIO_MAIN:
            AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(_value))
