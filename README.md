# Twitcherino
(Name not final)

Source code for an upcoming web application that will combine all livegaming webservice in one!
This is a work in progress!

It is currently hosted [here](http://warm-mountain-7865.herokuapp.com/)

You can create an account if you like, but it will most likely be deleted at some point

## License

This project is licensed under Attribution-NonCommercial-ShareAlike 4.0 International.
http://creativecommons.org/licenses/by-nc-sa/4.0/


## Requirements

### Building

[nodejs](http://nodejs.org/), [bower](http://bower.io/), [grunt](http://gruntjs.com/), [ruby](https://www.ruby-lang.org/) (used to compile sass/coffeescript)

### Running

[nodejs](http://nodejs.org/), [expressjs](http://expressjs.com/), [mongodb](https://www.mongodb.org/), [angularjs](https://angularjs.org/)


## Getting Started


Create the configuration file "server/config/coffee/config.coffee" and override what you need.


### Dependencies

Install sass (you will need ruby installed)

```shell
gem install sass
```

Install the node dependencies

```shell
npm install
```

Install the front-end dependencies (should be automatically run at the end of npm install)

```shell
bower install
```

Compile Sass, coffeescript and start the watch (sass and coffeescript should also be automatically compilled after npm install)

```shell
npm install -g grunt-cli
grunt
```

## Start the server

```shell
npm install -g nodemon
nodemon server.js
```
