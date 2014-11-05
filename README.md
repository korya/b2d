### Install

```sh
cd ~/dev
git clone https://github.com/korya/b2d
cd b2d
vagrant up
```

Include `b2d.sh` in your `.bashrc`:
```sh
. ~/dev/b2d/b2d.sh
```

### Use

Configure the new shell env vars:

```sh
b2d # shortcut for b2d config
docker version # to verify that everything is OK
```

Check boot2docker VM status:
```sh
b2d status
```

SSH to the boot2docker VM:

```sh
b2d ssh
# or execute a command
b2d ssh date -u
```

If your VM lags in time, then sync it:

```sh
b2d ntp
```

You can edit the Vagrantfile:

```sh
b2d edit
```

Any other commands are passed to vagrant. So after you've finished
the editing you can restart the VM:

```sh
b2d reload
```
