'use strict'
let dp
let vid
let div
let type = "hls"
let addr = {"default_addr":[{}],"value":''}
let protocol=document.location.protocol
addr.default_addr["hls"]="http://live.qwq.es/hls/hsj/index.m3u8"
addr.default_addr["flv"]="http://live.qwq.es/flv/dir?app=live&stream=hsj"
addr.default_addr["dash"]="https://live.qwq.es/dash/hsj.mpd"
addr.default_addr["rtmp"]="rtmp://live.qwq.es/live/hsj"
protocol === "https:" && (document.getElementById('flv').setAttribute("disabled",true))
protocol === "https:" && (addr.default_addr.hls="https://live.qwq.es/hls/hsj/index.m3u8")
protocol === "http:" && (addr.default_addr.dash="http://live.qwq.es/dash/hsj.mpd")

function todestory(){
    if (type !== "rtmp"){
       dp.destroy()
    }
    vid.dispose()
}
document.getElementById('hls').onclick = () =>{
    type="hls"
    document.getElementById('addr').setAttribute("placeholder",addr.default_addr.hls)
    }
document.getElementById('flv').onclick = () =>{
    type="flv"
    document.getElementById('addr').setAttribute("placeholder",addr.default_addr.flv)
    }
document.getElementById('dash').onclick = () =>{
    type="dash"
    document.getElementById('addr').setAttribute("placeholder",addr.default_addr.dash)
    }
document.getElementById('rtmp').onclick = () =>{
    type="rtmp"
    document.getElementById('addr').setAttribute("placeholder",addr.default_addr.rtmp)
    }
function toplay(){
    
    addr["value"] = document.getElementById('addr').value;
    if (addr["value"] === '') {
      type === "hls" && (addr.value=addr.default_addr.hls);
      type === "flv" && (addr.value=addr.default_addr.flv);
      type === "dash" && (addr.value=addr.default_addr.dash);
      type === "rtmp" && (addr.value=addr.default_addr.rtmp);
    }
    console.log(addr.value);
    console.log(type);
    if (type === 'flv'){
        dp = new DPlayer({
    container: document.getElementById('dplayer'),
    live: true,
    video: {
        url: addr.value,
        type: 'customFlv',
        customType: {
            customFlv: function(video, player) {
                const flvPlayer = flvjs.createPlayer({
                    type: 'flv',
                    url: video.src,
                    isLive: true,
                    enableWorker: true,
                    enableStashBuffer: false,
                    stashInitialSize: 128,
                });
                flvPlayer.attachMediaElement(video);
                flvPlayer.load();
            },
        },
    },
});
    }
    if (type === 'hls'){
    dp = new DPlayer({
    container: document.getElementById('dplayer'),
    video: {
        url: addr.value,
        type: 'hls',
        },
    });
    console.log(dp.plugins.hls);
    }
    if (type === 'dash'){
        dp = new DPlayer({
    container: document.getElementById('dplayer'),
    live: true,
    video: {        
        url: addr.value,
        type: 'shakaDash',
        customType: {
            shakaDash: function(video, player) {
                var src = video.src;
                var playerShaka = new shaka.Player(video);
                playerShaka.load(src);
            },
        },
    },
});
    }
    if (type === "rtmp"){
        div = document.getElementById('videojs')
        let videos = document.createElement("video")
        videos.setAttribute('id',"videos")
        div.appendChild(videos)
        vid = videojs("videos",{
           controls: true,
           autoplay: false,
           preload: 'auto',
           liveui: true,
           muted: true,
           techOrder: ["flash","html5"]
        });
        vid.src({
            type: 'rtmp/mp4',
            src: addr.value
        });
    }
    
}
