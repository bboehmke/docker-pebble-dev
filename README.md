# Pebble development environment

## Legal Note
You must accept the [Pebble Terms of Use](https://developer.getpebble.com/legal/terms-of-use/)
and the [SDK License Agreement](https://developer.getpebble.com/legal/sdk-license/) 
to use the Pebble SDK.


## Usage as terminal

For example if you created a directory ```pebble-dev``` in your home directory 
you start the container with:
```sh
docker run --rm -it -v ~/pebble-dev/:/pebble/ bboehmke/pebble-dev
```
This opens a shell where you can use the ```pebble``` command.
The actual directory is already ```/pebble/``` (or the host dir ```~/pebble-dev/```).
If you close the session, the docker container is removed.


If you want to reuse the container you should start it with:
```sh
docker run --name=pebbleDev -it -v ~/pebble-dev/:/pebble/ bboehmke/pebble-dev
```
After you close the shell and the container exit, you can use the restart the 
container with:
```sh
docker start -it -a pebbleDev
```


## Direct usage

If you have created a project in ```~/pebble-dev/project``` you can build the 
app with:
```sh
docker run --rm -it -v ~/pebble-dev/project/:/pebble/ bboehmke/pebble-dev pebble build
```

If the app should be installed after build you can achieve this with:
```sh
docker run --rm -it \
    -v ~/pebble-dev/project/:/pebble/ \
    bboehmke/pebble-dev \
    sh -c 'pebble build && pebble install --phone=192.168.2.124'
```
This works if the phone has the IP address '192.168.2.124'.


## Emulator

To use the emulator, you have to add 
```-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix```. 
Start the container with:
```sh
docker run -it --rm \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/pebble-dev/:/pebble/ \
    bboehmke/pebble-dev
```

If the XServer on the host system only allow valid user (e.g. Arch Linux), 
you have to add ```-v ~/.Xauthority:/home/pebble/.Xauthority --net=host```:
```sh
docker run -it --rm \
    --net=host \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/pebble-dev/:/pebble/ \
    -v ~/.Xauthority:/home/pebble/.Xauthority \
    bboehmke/pebble-dev
```
