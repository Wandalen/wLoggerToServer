( function _ToServer_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  // require( '../printer/top/ToServer.s' );
  require( '../l1_logger/ToServer.s' );

  const _ = _global_.wTools;

  _.include( 'wTesting' );

}

const _ = _global_.wTools;
const Parent = wTools.Testing;
const Proto = {};

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

const Proto =
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
const Self = wTestSuite( Proto );

if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
