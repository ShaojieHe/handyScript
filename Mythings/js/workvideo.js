'use strict'
let dp
let type
let addr = {"default_addr":[{}],"value":''}
addr.default_addr["normal"]="https://ftp.qwq.es/share/test.mp4"
addr.default_addr["dash"]="https://ftp.qwq.es/share/test_dash.mp4/output.mpd"
type="normal"
document.getElementById('normal').onclick = () =>{
    type="normal"
    document.getElementById('addr').setAttribute("placeholder",addr.default_addr.normal)
    }
document.getElementById('dash').onclick = () =>{
    type="dash"
    document.getElementById('addr').setAttribute("placeholder",addr.default_addr.dash)
    }
function toplay(){
    addr["value"] = document.getElementById('addr').value;
    if (addr["value"] === '') {
      type === "normal" && (addr.value=addr.default_addr.normal);
      type === "dash" && (addr.value=addr.default_addr.dash);
    }
    console.log(addr.value);
if (type === 'normal'){    
    dp = new DPlayer({
    container: document.getElementById('dplayer'),
    lang: 'zh-cn',
    theme: '#FADFA3',
    volume: 0.3,
    video: {
        url: addr.value,
    },
});
}
if (type === 'dash'){
        dp = new DPlayer({
    container: document.getElementById('dplayer'),
    lang: 'zh-cn',
    theme: '#FADFA3',
    volume: 0.3,
    live: false,
    video: {        
        url: addr.value,
        type: 'shakaDash',
        customType: {
            shakaDash: function(video, player) {
                var src = video.src;
                var playerShaka = new shaka.Player(video);
                playerShaka.configure({
                    streaming:{
                        bufferingGoal: 30,
                        rebufferingGoal: 15,
                        bufferBehind: 15
                    }
                })
                playerShaka.load(src);
            },
        },
    },
});
    }
}
