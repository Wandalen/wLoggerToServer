(function _PrinterToSever_s_() {

'use strict';

// require

if( typeof module !== 'undefined' )
{

  // if( typeof wBase === 'undefined' )
  try
  {
    require( '../../wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;
  _.io = require( 'socket.io-client' );

  _.include( 'wLogger' );
  _.include( 'wConsequence' );

}

var symbolForLevel = Symbol.for( 'level' );

//

var _ = wTools;
var Parent = wPrinterTop;
var Self = function wLoggerToServer( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'LoggerToSever';

//

function init( o )
{
  var self = this;

  Parent.prototype.init.call( self,o );

  if( !self.url  )
  self.url = 'http://127.0.0.1:3000';
}

//

function connect( url )
{
  var self = this;

  if( url )
  self.url = url;

  _.assert( _.strIs( self.url ) );

  var con = new wConsequence;

  if( self.socket && self.socket.connected )
  self.socket.disconnect();

  self.socket = _.io( self.url );
  self.socket.on( 'connect', function()
  {
      self.socket.emit('join', '' );
      con.give();
  });

  return con.eitherThenSplit( _.timeOutError( self.connectionTimeout ) );
}

//

function disconnect()
{
  var self = this;

  if( self.socket && self.socket.connected )
  self.socket.disconnect();

  return !self.socket.connected;
}

//

function write()
{
  var self = this;

  debugger;
  var o = wPrinterBase.prototype.write.apply( self,arguments );

  if( !o )
  return;

  _.assert( o );
  _.assert( _.arrayIs( o.output ) );
  _.assert( o.output.length === 1 );

  var message = o.output[ 0 ];

  if( self.socket.connected )
  self.socket.emit( self.typeOfMessage, message );

  return o;
}

// --
// relationships
// --

var Composes =
{
  url : null,
  typeOfMessage : 'log',
  connectionTimeout : 5000
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
  socket : null,
}

// --
// prototype
// --

var Proto =
{

  init : init,

  connect : connect,
  disconnect : disconnect,

  write : write,

  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,

}

//

_.protoMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

// Self.prototype._initChainingMixin();

//

_.accessor
({
  object : Self.prototype,
  names :
  {
    level : 'level',
  },
  combining : 'rewrite'
});

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

})();
