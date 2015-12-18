# Pebble development environment

## Legal Note
You must accept the [Pebble Terms of Use](https://developer.getpebble.com/legal/terms-of-use/)
and the [SDK License Agreement](https://developer.getpebble.com/legal/sdk-license/) 
to use the Pebble SDK.

To accept the license automatically create a file `ACCEPT_LICENSE` in 
`/home/pebble/.pebble-sdk/`.


## Note
With the Pebble Tool 4.0 and above it is possible to switch the SDK version on 
the fly. Based on this change this image will not download an SDK in the build 
process.


## Before you start
To build a pebble APP you must first download a SDK. 

If you want to use the image as terminal simply run 
`pebble sdk install <SDK_VERSION>` before the first build.

If you want to build direct the build command must be extended like:
app with:
```sh
docker run --rm -it \
    -v ~/pebble-dev/project/:/pebble/ \
    bboehmke/pebble-dev \
    /bin/sh -c 'pebble sdk install <SDK_VERSION> && pebble build'
```

If you want to keep the SDK mount a volume for `/home/pebble/.pebble-sdk/SDKs`.
Than you load the SDK once and reuse it for the next container.
Load the SDK:
```sh
docker run --rm -it \
    -v ~/pebble-dev/SDKs/:/home/pebble/.pebble-sdk/SDKs/ \
    bboehmke/pebble-dev \
    pebble sdk install <SDK_VERSION>
```
Build the APP:
```sh
docker run --rm -it \
    -v ~/pebble-dev/project/:/pebble/ \
    -v ~/pebble-dev/SDKs/:/home/pebble/.pebble-sdk/SDKs/ \
    bboehmke/pebble-dev \
    pebble build
```

If you have multiple SDK you must switch to the correct one before build:
```sh
docker run --rm -it \
    -v ~/pebble-dev/SDKs/:/home/pebble/.pebble-sdk/SDKs/ \
    bboehmke/pebble-dev \
    pebble sdk activate <SDK_VERSION>
```


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
