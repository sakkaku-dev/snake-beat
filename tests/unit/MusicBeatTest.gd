extends UnitTest

var music_beat: MusicBeat
var music: MusicPlayer

var bpm = 60
var beats_per_loop = 16

func before_each():
	music_beat = autofree(MusicBeat.new())
	music_beat.bpm = bpm
	music_beat.beatsPerLoop = beats_per_loop
	watch_signals(music_beat)
	
	music = double(MusicPlayer).new()
	music_beat.audio_player = music


func test_music_beat():
	var verified_count = 0
	for i in range(0, beats_per_loop * 10):
		stub(music, 'get_song_position').to_return(i / 10)
		simulate(music_beat, 1, 1)
		if i % 10 == 0:
			assert_eq(get_signal_emit_count(music_beat, "beat"), verified_count + 1)
			verified_count += 1
	
	
	for i in range(0, beats_per_loop * 10):
		stub(music, 'get_song_position').to_return(i / 10)
		simulate(music_beat, 1, 1)
		if i % 10 == 0:
			assert_eq(get_signal_emit_count(music_beat, "beat"), verified_count + 1)
			verified_count += 1
