# module::LoggerToServer [![status](https://github.com/Wandalen/wLoggerToServer/workflows/publish/badge.svg)](https://github.com/Wandalen/wLoggerToServer/actions?query=workflow%3Apublish) [![experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/emersion/stability-badges#experimental)

Class to redirect output from remote source to console.




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

More information about common wLogger you may find [here]( https://github.com/Wandalen/wLogger ).

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
  l.log( 'Message to server' );
  l.disconnect();
})
```
