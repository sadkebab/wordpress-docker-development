# Docker Compose development template for Wordpress

Unfortunately, 
despite at the time I am writing this we live in the year of the Lord 2023, 
somehow approximately 39.5% of the web runs on WordPress. [source](https://techjury.net/blog/percentage-of-wordpress-websites/#gref)

And since modern proplems require modern solutions I thought it would be nice to have a docker-compose development environment to make this nightmare a bit more bereable.

## How it works
Builds a docker container with Wordpress and MySQL and automatically mounts the content of the "plugins" and "themes" folder every time a change happens inside them (kinda like Vite's hot reload) on the running container


## Requirements

- Docker

```

```
