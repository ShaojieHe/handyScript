'use strict'
let dp
let addr = document.getElementById('addr')

function toplay(){
    if (addr.value === '') {
      addr.value="https://ftp.qwq.es/share/test.mp4"
    }
    console.log(addr.value);
    
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
