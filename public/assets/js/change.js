         function change(obj) {
             var len = obj.files.length;
             for (var i = 0; i < len; i++) {
                 var temp = obj.files[i].name;
                 console.log()
                 obj.previousSibling.previousSibling.innerHTML = "<i class='am-icon-cloud-upload'></i>" + temp;
             }
         }