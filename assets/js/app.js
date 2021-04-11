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

function playAudio(audio, audio_num) {
    document.getElementById(audio_num).classList.add('play')
    document.getElementById(audio_num).classList.remove('stop')
    audio.play()
}

let Hooks = {}
Hooks.AudioControl = {
    mounted() {
        this.handleEvent("play_audio", (payload) => {
            let audio = document.getElementById(payload.audio_id)
            let audio_parent = audio.parentElement
            let audio_num = payload.audio_id.slice(6)
            let audio_music_elements = document.querySelectorAll('div.music')
            if (audio_parent.classList.contains('music')) {                
                audio_music_elements.forEach(function(el) {
                    el.firstElementChild.pause()
                    if (!el.classList.contains('pausable')) {
                        el.firstElementChild.currentTime = 0
                    }                    
                    el.classList.add('stop')
                    el.classList.remove('play')
                })
                playAudio(audio, audio_num)             
            } else {
                playAudio(audio, audio_num)
            }
            
        })
        this.handleEvent("stop_audio", (payload) => {
            let audio = document.getElementById(payload.audio_id)
            let audio_num = payload.audio_id.slice(6)
            document.getElementById(audio_num).classList.add('stop');
            document.getElementById(audio_num).classList.remove('play');
            audio.pause()
            audio.currentTime = 0
        })
        this.handleEvent("pause_audio", (payload) => {
            let audio = document.getElementById(payload.audio_id)
            let audio_num = payload.audio_id.slice(6)
            document.getElementById(audio_num).classList.add('stop');
            document.getElementById(audio_num).classList.remove('play');
            audio.pause() 
        })
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

