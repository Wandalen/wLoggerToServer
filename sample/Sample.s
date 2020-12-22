
if( typeof module !== 'undefined' )
require( 'wloggertoserver' );

let _ = wTools;

var express = require( 'express' );
var app = express();
var server = require( 'http' ).createServer( app );
var io = require( 'socket.io' )(server);
var port = 3000;

io.on( 'connection', function( client )
{
  client.on( 'join', function()
  {
    console.log( 'logger connected' );

    client.on ('log', function ( msg )
    {
      logger.log( _.strColor.bg( _.strColor.fg( 'Message from logger  : ' + msg, 'black' ), 'yellow' ) );
    });
  });

  client.on( 'disconnect', function ()
  {
    console.log( 'logger disconnected' );
  })
});

server.listen( 3000, function ()
{
  var l = new wLoggerToServer();
  l.connect()
  .doThen( function ()
  {
    l.log( 'wLoggerToServer' );
    l.disconnect();
  })
});
