extends AudioStreamPlayer2D

class_name SoundPlayer


var pitch_range = Vector2(0.9, 1.1)
func play_audio(sound: AudioStream):
    if sound == null:
        print("Playing null audio")
    
    var rng_pitch: float = randf_range(pitch_range.x, pitch_range.y)

    var audio_instance := AudioStreamPlayer2D.new()
    add_child(audio_instance)

    audio_instance.stream = sound
    audio_instance.pitch_scale = rng_pitch
    audio_instance.play()
    
    audio_instance.connect("finished", Callable(audio_instance, "queue_free"))