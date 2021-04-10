(function _PrinterToSever_s_()
{

'use strict';

// require

if( typeof module !== 'undefined' )
{
  // const _ = require( 'Tools' );
  const _ = require( 'Tools' );

  if( module.isBrowser )
  {
    require( 'socket.io-client/dist/socket.io.js' );
    _.io = io;
  }
  else
  {
    _.io = require( 'socket.io-client' );
  }

  _.include( 'wLogger' );
  _.include( 'wConsequence' );

}

var symbolForLevel = Symbol.for( 'level' );

//

const _ = _global_.wTools;
// const Parent = _.PrinterTop;
const Parent = _.Logger;
const Self = wLoggerToServer;
function wLoggerToServer( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.nameShort = 'LoggerToSever';

//

function init( o )
{
  var self = this;

  Parent.prototype.init.call( self, o );

  if( !self.url )
  self.url = 'http://127.0.0.1:3000';

  self.counter = { out : 0, in : 0 };
}

//

function connect( url )
{
  var self = this;

  if( url )
  self.url = url;

  _.assert( _.strIs( self.url ) );

  var con = new _.Consequence();

  if( self.socket && self.socket.connected )
  self.socket.disconnect();

  self.socket = _.io( self.url );
  self.socket.on( 'connect', function ()
  {
    self.socket.emit( 'join', '', () => con.take( null ) );
  });

  return _.Consequence.Or( con, _.time.outError( self.connectionTimeout ) );
  // return con.orKeepingSplit( _.timeOutError( self.connectionTimeout ) );
}

//

function disconnect()
{
  var self = this;
  return _.time.out( self.delayBeforeDisconnect, () => self.socket.disconnect() );
}

//

// function write()
// {
//   var self = this;

//   var o = wPrinterBasic.prototype.write.apply( self,arguments );

//   if( !o )
//   return;

//   _.assert( o );
//   _.assert( _.arrayIs( o.output ) );
//   _.assert( o.output.length === 1 );

//   var message = o.output[ 0 ];

//   if( self.socket.connected )
//   {
//     self.counter.out++;
//     self.socket.emit( self.typeOfMessage, message, () => self.counter.in++ );
//   }

//   return o;
// }

//

function _transformEnd( o )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  // debugger

  o = Parent.prototype._transformEnd.call( self, o );

  if( !o )
  return;

  _.assert( _.arrayIs( o._outputForPrinter ) );
  _.assert( o._outputForPrinter.length === 1 );

  var message = o._outputForPrinter[ 0 ];

  if( self.socket.connected )
  {
    self.counter.out++;
    self.socket.emit( self.typeOfMessage, message, () => self.counter.in++ );
  }

  return o;
}

// --
// relationships
// --

var Composes =
{
  url : null,
  typeOfMessage : 'log',
  connectionTimeout : 5000,
  delayBeforeDisconnect : 1500
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
  counter : null
}

// --
// prototype
// --

const Proto =
{

  init,

  connect,
  disconnect,

  // write : write,
  _transformEnd,

  // relationships

  // constructor : Self,
  Composes,
  Aggregates,
  Associates,
  Restricts,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;
_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

})();
