# s3fs-check-aspell

## About s3fs-check-aspell
This is a tool and personal dictionary that supports spelling checking of all text files of [s3fs-fuse/s3fs-fuse](https://github.com/s3fs-fuse/s3fs-fuse) repository.  
This tool uses GNU Aspell(http://aspell.net/) and is an aspell wrapper script.

## Usage
You can use Aspell's personal dictionary freely.
It could be inclouded into the editor.
Our scripts are useful when updating your personal dictionary by checking manually.
You can see those script usage following:
```
$ s3fs-check-aspell.sh --help
$ s3fs-update-aspell-dictionary.sh --help
```

### Install aspell
You need to install aspell and english dictionary before using those script.
For example on CentOS following:
```
# yum install aspell aspell-en
```

## License
This source code is MIT license.  
Please see the LICENSE file for details.

Copyright(C) 2019 Takeshi Nakatani <ggtakec@gmail.com>
