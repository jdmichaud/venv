# venv
A virtual environment creator for linux.

Venv let you install software on your system without bloating it. It creates an *overlay* filesystem, mirroring / on which any modification, addition or deletion is written in a special folder. Once 'logged in' the virtual environment, it looks as if the modifications are made. But if you exit that virtual environment, your actual system is untouched.

# Install
```
curl -sOL https://raw.githubusercontent.com/jdmichaud/venv/master/venv.sh
chmod +x venv.sh
```
You can also execute the script from github directly to create a virtual environment called foo:
```
bash <(curl -s https://raw.githubusercontent.com/jdmichaud/venv/master/venv.sh?$(date +%s)) foo
```

# How to
```
./venv.sh venv
```
This will create a virtual environment in the `venv` folder if it does not exists already and start a bash process into it. Any modification made after this point will not be replicated into your original filesystem but will only be visible into the virtual environment. To exit the virtual environment just exit the current bash process.

Exit the bash process to exit the virtual environment.

# How does it works
Venv is leveraging several linux related technology to achieve its goal. When launched it basically does the following:
* create a folder (`.venv`) which itself contains 3 directories (`upper`, `work` and `mount`)
* create an [overlay](https://en.wikipedia.org/wiki/OverlayFS) filesystem mapping your root folder (`/`) into .env
* mount some special folders into that overlay filesystem that are not part of `/` but still necessary to have a functionning system
* and finally chroot into that overlay filesystem by spawning a `bash` process

From that point, any modification made to the apparent root filesystem will actually be performed in the overlay.

# Dependencies

You will need:
* bash
* chroot
* the overlay filesysyem.

To check if the overlay filesystem is installed:
```
cat /proc/filesystems | grep overlay
```

# Contributions
Made after multiple questions asked on various [stackexchange.com](https://stackexchange.com/):
* [Overlayfs inside archivemount](https://unix.stackexchange.com/questions/486916/overlayfs-inside-archivemount)
* [Layered or Virtual filesystem on Linux](https://unix.stackexchange.com/questions/486810/layered-or-virtual-filesystem-on-linux/486827#486827)
