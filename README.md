# A hot-reloading development environment for Wordpress

Unfortunately, despite at the time I am writing this we live in the year of the Lord 2023, somehow approximately 39.5% of the web runs on WordPress. [[source]](https://techjury.net/blog/percentage-of-wordpress-websites/#gref)

And since modern proplems require modern solutions I thought it would be nice to have a hot-reloading wordpress development environment to make this nightmare a bit more bereable.

## Dependencies
* Docker

## How it works
Builds a docker container with Wordpress and MySQL and automatically mounts the content of the "plugins" and "themes" folder every time a change happens inside them (kinda like Vite's hot reload) on the running container.

## Support
The script was built and tested on WSL2 so I assume it should work on most linux distros.
Currently it uses the command 'md5sum' that should not work on macOS, but in theory you can make it run by changing 'md5sum' with 'md5' in the MD5 variable on top of the **start.sh** file.

## Usage
Download the folder and just execute ./start.sh, it will pull the required docker image and build the environoment by itself.
Once it's up and running open **http://localhost:666/** and finish the Wordpress installation.