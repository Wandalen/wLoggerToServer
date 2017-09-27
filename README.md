# wLoggerToServer [![Build Status](https://travis-ci.org/Wandalen/wLoggerToServer.svg?branch=master)](https://travis-ci.org/Wandalen/wLoggerToServer)

The module in JavaScript provides way to send messages to the dedicated server.
Logger connects to the server and transfers all incoming/outcoming messages to it using socket.io.


## Installation
```terminal
npm install wloggertoserver
```
## Usage
### Options
* url { string }[ optional, default : localhost:3000 ] - address of the server.

### Methods
 * connect - connect to server;
 * disconnect - disconnect from current server.

[More information about common wLogger features.]( https://github.com/Wandalen/wLogger )

##### Example
```javascript
/* Assume that we have local socket.io server on port 3000 */

/* create logger and pass connection address as option */
var l = new wLoggerToServer({ url : 'http://127.0.0.1:3000' });
l.connect()
/* connect returns consequence that gives us a message on successful connection */
.doThen( function ()
{
  /* logger is connected, now send a message */
  l.log( 'Message from wLoggerToServer' );
  l.disconnect();
})
```

