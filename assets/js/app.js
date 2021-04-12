// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

// Helper functions
function playAudio(audio) {
    audio.play()
}

function stopOrPauseAudio(audio) {
    audio.pause()
    if (!audio.parentElement.classList.contains('pausable')) {
        audio.currentTime = 0
    } 
}

function togglePlayStop(audioField) {
    audioField.classList.toggle('stop')
    audioField.classList.toggle('play')
}

function playStopAudio(payload) {
    let audio = document.getElementById(payload.audio_id)
    let audioField = document.getElementById(payload.audio_id.slice(6))
    let audioFieldElements = document.querySelectorAll('div.music')
    if (audioField.classList.contains('music')) {                
        audioFieldElements.forEach(function(audioField) {
            let audio = audioField.firstElementChild

            if (!audio.paused) {
                togglePlayStop(audioField)
                stopOrPauseAudio(audio)
            }
        })
        togglePlayStop(audioField)
        playAudio(audio)             
    } else {
        togglePlayStop(audioField)
        playAudio(audio)
    }
}

const audioFields = document.querySelectorAll('audio')
audioFields.forEach(function(audio) {
    audio.addEventListener("timeupdate", function() {
        let audioId = audio.id.slice(6)
        let percentage = (audio.currentTime / audio.duration) * 100
        document.getElementById(`progress-${audioId}`).style.width = percentage + "%"
        //document.getElementById(`progress-${audioId}`).animate([{'width':(currentTime +.25)/duration*100+'%'}],1000,'linear');
    });
})

// Register Hooks
let Hooks = {}

for (let i = 0; i <= 81; i++) {
    Hooks[`PlayControl_${i}`] = {
        mounted() {
            this.handleEvent(`play_audio-${this.el.id.slice(11)}`, (payload) => {
                playStopAudio(payload)         
            })
        }
    }
}

for (let i = 0; i <= 81; i++) {
    Hooks[`StopControl_${i}`] = {
        mounted() {
            this.handleEvent(`stop_audio-${this.el.id.slice(11)}`, (payload) => {
                let audio = document.getElementById(payload.audio_id)
                let audioField = document.getElementById(payload.audio_id.slice(6))
                stopOrPauseAudio(audio)
                togglePlayStop(audioField)
            })
        }
    }
}

for (let i = 0; i <= 81; i++) {
    Hooks[`PauseControl_${i}`] = {
        mounted() {
            this.handleEvent(`pause_audio-${this.el.id.slice(12)}`, (payload) => {
                let audio = document.getElementById(payload.audio_id)
                let audioField = document.getElementById(payload.audio_id.slice(6))
                stopOrPauseAudio(audio)
                togglePlayStop(audioField)
            })
        }
    }
}

Hooks.StopAllAudio = {
    mounted() {
        this.handleEvent("stop_all_audio", (payload) => {
            let audioElements = document.querySelectorAll('audio')
            audioElements.forEach(function(audio) {
                let audioField = audio.parentElement
                if (!audio.paused) {
                    togglePlayStop(audioField)
                    stopOrPauseAudio(audio)
                }
            })
        })
    }
}

// Todo
Hooks.AudioControl = {
    mounted() {
        this.handleEvent("change_volume", (payload) => {
            let audio = document.getElementById(`audio-${payload.audio_id}`)
            let volume_input = document.getElementById(`volume-audio-${payload.audio_id}`)
            volume_input.value = payload.volume
            audio.volume = payload.volume
        })
    }
}

Hooks.SetVolume = {
    mounted() {
        let volume = document.getElementById(`volume-audio-${this.el.id}`).value
        let audio = document.getElementById(`audio-${this.el.id}`)
        audio.volume = volume
    }
}

let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

