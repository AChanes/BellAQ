var recorder = new MP3Recorder({
  debug: true,
  funOk: function() {
    btnStart.disabled = false;
    log("初始化成功");
  },
  funCancel: function(msg) {
    log(msg);
    recorder = null;
  }
});
var mp3Blob;

function funStart(button) {
  btnStart.disabled = true;
  btnStop.disabled = false;
  btnUpload.disabled = true;
  log("录音开始...");
  recorder.start();
}

function funStop(button) {
  recorder.stop();
  btnStart.disabled = false;
  btnStop.disabled = true;
  btnUpload.disabled = false;
  log("录音结束，MP3导出中...");
  recorder.getMp3Blob(function(blob) {
    log("MP3导出成功");

    mp3Blob = blob;
    var url = URL.createObjectURL(mp3Blob);
    var div = document.createElement("div");
    var au = document.createElement("audio");

    au.controls = true;
    au.src = url;
    div.appendChild(au);

    recordingslist.appendChild(div);
  });
}

function log(str) {
  recordingslist.innerHTML += str + "<br/>";
}

function funUpload() {
  var fd = new FormData();
  var mp3Name = encodeURIComponent(
    "audio_recording_" + new Date().getTime() + ".mp3"
  );
  fd.append("mp3Name", mp3Name);
  fd.append("file", mp3Blob);

  var xhr = new XMLHttpRequest();
  xhr.onreadystatechange = function() {
    if (xhr.readyState == 4 && xhr.status == 200) {
      $("#su").attr("src", xhr.responseText);
    }
  };

  xhr.open("POST", "video");
  xhr.send(fd);
}
