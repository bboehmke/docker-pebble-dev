# Pebble development environment

This is a 64-bit Docker image for Pebble using the Rebble SDK.

## Legal Note
You must accept the [Pebble Terms of Use](https://developer.getpebble.com/legal/terms-of-use/)
and the [SDK License Agreement](https://developer.getpebble.com/legal/sdk-license/) 
to use the Pebble SDK.

## Building

First download the SDK tar file required:

```
wget https://github.com/aveao/PebbleArchive/raw/master/SDKCores/sdk-core-4.3.tar.bz2
```

Next, build an image:

```
docker build -t pebble-sdk .
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

## Troubleshooting

If you see something like the following error when running 'pebble build' or 'pebble new-project', then you need to update the permissions on the folder that you are running the command against. 

```
Traceback (most recent call last):
  File "/opt/pebble-sdk-4.5-linux64/pebble-tool/pebble.py", line 7, in <module>
    pebble_tool.run_tool()
  File "/opt/pebble-sdk-4.5-linux64/pebble-tool/pebble_tool/__init__.py", line 44, in run_tool
    args.func(args)
  File "/opt/pebble-sdk-4.5-linux64/pebble-tool/pebble_tool/commands/base.py", line 47, in <lambda>
    parser.set_defaults(func=lambda x: cls()(x))
  File "/opt/pebble-sdk-4.5-linux64/pebble-tool/pebble_tool/commands/sdk/create.py", line 163, in __call__
    _copy_from_template(template_layout, extant_path(template_paths), args.name, options)
  File "/opt/pebble-sdk-4.5-linux64/pebble-tool/pebble_tool/commands/sdk/create.py", line 68, in _copy_from_template
    os.mkdir(project_path)
OSError: [Errno 13] Permission denied: 'test'
```

For example, if the folder you are using is '~/pebble-dev', then run the following to enable docker to write to this folder:
```
sudo chmod -R 777 ~/pebble-dev
```
