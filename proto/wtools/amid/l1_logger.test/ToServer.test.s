( function _ToServer_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  // require( '../printer/top/ToServer.s' );
  require( '../l1_logger/ToServer.s' );

  let _ = wTools;

  _.include( 'wTesting' );

}

let _ = wTools;
let Parent = wTools.Testing;
let Self = {};

//

function log( test )
{
  var http = require( 'http' );
  var server = http.createServer( () => {} );
  var io = require( 'socket.io' )( server );

  let messageCon = new wConsequence();

  io.sockets.on( 'connection', function ( socket )
  {
    socket.on( 'join', function ( msg, reply )
    {
      logger.log( 'wLoggerToServer connected' );
      reply( 0 );
    });

    socket.on( 'log', function ( msg )
    {
      messageCon.take( msg )
    });
  });

  var loggerToServer = new wLoggerToServer({ url : 'http://127.0.0.1:8080' });
  var msg = 'hello server';

  server.listen( 8080, () => console.log( 'server started' ) );

  let ready = loggerToServer.connect();

  ready
  .then( () =>
  {
    loggerToServer.log( msg );
    return _.Consequence.Or( messageCon, _.timeOutError( 3000 ) );
    // return messageCon.orKeepingSplit( _.timeOutError( 3000 ) );
  })
  .then( ( got ) =>
  {
    test.identical( got, msg );
    return null;
  })
  .finally( () =>
  {
    return loggerToServer.disconnect()
  })
  .finally( () =>
  {
    var con = new wConsequence();
    io.close( () => server.close( () => con.take( null ) ) )
    return con;
  })

  return ready;
}

//

var Proto =
{

  name : 'LoggerToServer',
  silencing : 1,

  tests :
  {
    log
  },
}

//

_.mapExtend( Self, Proto );
Self = wTestSuite( Self );

if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
