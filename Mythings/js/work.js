'use strict'
let type = "video"
let addr = document.getElementById('addr')
document.getElementById('video').onclick = () =>{
    type="video"
    if (addr.value==="https://ftp.qwq.es/hls/hsj/index.m3u8" || addr.value === ''){
    addr.value="https://ftp.qwq.es/file/video/test.mp4"}
}
document.getElementById('live').onclick = () =>{
    type="live"
    if (addr.value==="https://ftp.qwq.es/file/video/test.mp4" || addr.value === '')
    addr.value="https://ftp.qwq.es/hls/hsj/index.m3u8"
}
function toplay(){
    if (addr.value === '') {
      addr.value="https://ftp.qwq.es/file/video/test.mp4"
    }
    if (type === ''){
        type="video"
    }
    addr == document.getElementById('addr');
    
    console.log(addr.value);
    console.log(type);
    
    if (type === 'live'){
    const dp = new DPlayer({
    container: document.getElementById('dplayer'),
    video: {
        url: addr.value,
        type: 'hls',
    },

});
console.log(dp.plugins.hls);
    }
    
    if (type === 'video'){
    const dp = new DPlayer({
    container: document.getElementById('dplayer'),
    lang: 'zh-cn',
    theme: '#FADFA3',
    volume: 0.3,
    video: {
        url: addr.value,
    },
});
        
    }
}
