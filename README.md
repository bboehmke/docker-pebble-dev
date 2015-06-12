# Pebble development environment

## Legal Note
You must accept the [Pebble Terms of Use](https://developer.getpebble.com/legal/terms-of-use/)
and the [SDK License Agreement](https://developer.getpebble.com/legal/sdk-license/) 
to use the Pebble SDK.


## Usage

For example if you created a directory ```pebble-dev``` in your home directory 
you start the container with:
```
docker run --rm -i -t -v ~/pebble-dev/:/pebble/ bboehmke/pebble
```
This opens a shell where you can use the ```pebble``` command.
The actual directory is already ```/pebble/``` (or the host dir ```~/pebble-dev/```).
If you close the session, the docker container is removed.


If you want to reuse the container you should start it with:
```
docker run --name=pebbleDev -i -t -v ~/pebble-dev/:/pebble/ bboehmke/pebble
```
After you close the shell and the container exit, you can use the restart the 
container with:
```
docker start -i -a pebbleDev
```
