(local audio {})

(var sample-rate 44100)

(fn audio.generate-tone [frequency duration]
  "Generates a raw SoundData buffer containing a synth wave"
  (let [num-samples (math.floor (* sample-rate duration))
        sound-data (love.sound.newSoundData num-samples sample-rate 16 1)]

    (for [i 0 (- num-samples 1)]
      ;; CALCULATE PHASE LOCALLY PER SAMPLE:
      ;; This guarantees the wave stays structurally sound and never drifts out of bounds.
      (let [phase (* 2 math.pi frequency (/ i sample-rate))

            ;; Cyberpunk Sawtooth Wave Formula
            raw-sample (- (* 2 (/ (% phase (* 2 math.pi)) (* 2 math.pi))) 1)

            ;; Dampen the volume to 15% so it's a pleasant bass drone
            final-volume (* raw-sample 0.15)]

        (sound-data:setSample i final-volume)))

    ;; Create our source as a standard static sound effect asset
    (let [source (love.audio.newSource sound-data :static)]
      (source:setLooping true)
      source)))

audio
