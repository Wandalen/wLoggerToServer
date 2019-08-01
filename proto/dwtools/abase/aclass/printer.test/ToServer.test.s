( function _ToServer_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../printer/top/ToServer.s' );

  var _ = wTools;

  _.include( 'wTesting' );

}

var _ = wTools;
var Parent = wTools.Testing;
var Self = {};

//

function log( test )
{
  var msgs = [];

  var http = require('http');
  var server = http.createServer( () => {} );
  var io = require( 'socket.io' )( server );

  io.sockets.on( 'connection', function ( socket )
  {
    socket.on( 'join', function ( msg, reply )
    {
      logger.log( 'wLoggerToServer connected' );
      reply();
    });

    socket.on ( 'log', function ( msg, reply )
    {
      msgs.push( msg );
      reply();
    });
  });

  var loggerToServer = new wLoggerToServer({ url : 'http://127.0.0.1:8080' });
  var msg = 'hello server';

  server.listen( 8080, () => console.log( 'server started' ) );

  return loggerToServer.connect()
  .doThen( () =>
  {
    loggerToServer.log( msg );
  })
  .doThen( () => loggerToServer.disconnect() )
  .doThen( () =>
  {
    var con = new wConsequence();
    io.close( () => server.close( () => con.give() ) )
    return con;
  })
  .doThen( () => test.identical( msgs, [ msg ] ) );
}

//

var Proto =
{

  name : 'LoggerToServer',
  silencing : 1,

  tests :
  {
    log : log
  },
}

//

_.mapExtend( Self,Proto );
Self = wTestSuit( Self );

if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
