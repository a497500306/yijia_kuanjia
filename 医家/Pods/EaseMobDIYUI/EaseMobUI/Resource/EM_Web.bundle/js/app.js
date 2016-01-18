$(function() {

    var uploader = new plupload.Uploader({
        runtimes: 'html5',
        browse_button: 'btn-upload',
        drop_element: 'drag',
        dragdrop: true,
        url: "/files",
        init: {
            FilesAdded: function(up, files) {

                if (files.length !== 1) {

                    alert('只允许单文件上传');
                    return;
                }

                var type = files[0].type.split('/')[0].toLowerCase();

                if (!type) {

                    type = 'other';
                }

                up.setOption('headers', {
                    'filename': Base64.encode(files[0].name),
                    'filetype': type
                });

            	up.start();
            },
            UploadProgress: function(up, file) {

                $('#progress').removeClass('hidden').html('正在上传 ' + file.percent + ' %');
            },
            FileUploaded: function(up, file) {

                $('#progress').addClass('hidden');

                var type = file.type.split('/')[0].toLowerCase();
                var size = file.size;
                var unit;

                var tmp = [];
                if (size > 1024 * 1024 * 1024) {

                    unit = (size / (1024 * 1024 * 1024)).toFixed(2) + 'G';
                } else if (size > 1024 * 1024) {

                    unit = (size / (1024 * 1024)).toFixed(2) + 'M';
                } else if (size > 1024) {

                    unit = (size / 1024).toFixed(2) + 'K';
                } else {

                    unit = size + 'B';
                }

                tmp.push('<tr>');
                tmp.push('<td>'+file.name+'</td>');
                tmp.push('<td>'+unit+'</td>');
                tmp.push('<td>');
                tmp.push('<a href="" download>');
                tmp.push('<i class="fa fa-cloud-download"></i>');
                tmp.push('</a>');
                tmp.push('<a href="javascript:;">');
                tmp.push('<i class="fa fa-trash-o" data="hello.txt"></i>');
                tmp.push('</a>');
                tmp.push('</td>');
                tmp.push('</tr>');

                tmp = tmp.join('');

                $('.tab-pane').removeClass('active');
                if (type === 'image') {

                    $('#image').find('table').find('tbody').prepend(tmp);
                    $('#file-panel').children().removeClass('active').eq(0).addClass('active');
                    $('#image').addClass('active');
                } else if (type === 'text') {

                    $('#doc').find('table').find('tbody').prepend(tmp);
                    $('#file-panel').children().removeClass('active').eq(1).addClass('active');
                    $('#doc').addClass('active');
                } else if (type === 'video') {

                    $('#video').find('table').find('tbody').prepend(tmp);
                    $('#file-panel').children().removeClass('active').eq(2).addClass('active');
                    $('#video').addClass('active');
                } else if (type === 'audio') {

                    $('#audio').find('table').find('tbody').prepend(tmp);
                    $('#file-panel').children().removeClass('active').eq(3).addClass('active');
                    $('#audio').addClass('active');
                } else {

                    $('#other').find('table').find('tbody').prepend(tmp);
                    $('#file-panel').children().removeClass('active').eq(4).addClass('active');
                    $('#other').addClass('active');
                }
            },
            Error: function(up, err) {
                alert(err.response);
            }
        }
    });

    uploader.init();

    $('.tab-content').on('click','.fa-trash-o',function() {

        var that = $(this);
        var flag = confirm('确认删除?');

        if (!flag) {

            return;
        }
        
        var type = $('#file-panel').find('.active').find('input[type=hidden]').val();
        var filename = $(this).attr('data');

        $.ajax({
            url: '/files/'+type+'/'+filename,
            type: 'DELETE',
            data: {
                random: Math.random()
            },
            statusCode: {
                500: function() {

                    alert('删除失败');
                },
                200: function() {

                    that.parent().parent().parent().remove();
                }
            }
        })
    });
});