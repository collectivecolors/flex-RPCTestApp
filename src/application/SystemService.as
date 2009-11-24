package application
{
	//----------------------------------------------------------------------------
	// Imports
 
	import com.collectivecolors.rpc.IServiceAgent;
	import com.collectivecolors.rpc.RemoteService;
 
	import mx.rpc.events.ResultEvent;
 
	//----------------------------------------------------------------------------
 
	public class SystemService extends RemoteService
	{
		//--------------------------------------------------------------------------
		// Constants
 
		public static const SOURCE : String = 'system';
 
		//---------------------
 
		private static const CONNECT : String = 'connect';
 
		//--------------------------------------------------------------------------
		// Constructor
 
		public function SystemService( agent : IServiceAgent, urls : Array = null )
		{
			super( agent, urls );
 
			// Register system service handlers
			agent.register( CONNECT, connectResultHandler, serviceFaultHandler );
		}
 
 
		//--------------------------------------------------------------------------
		// Service methods
 
		/**
		 * Register connect method handlers.
		 * 
		 * Prototypes :
		 * 
		 *  function connectResultHandler( user : UserVO ) : void
		 *  function connectFaultHandler( statusMessage : String ) : void
		 */
		
		public function connectHandlers( resultHandler : Function,
		                                 faultHandler : Function = null ) : void
		{
		  registerHandlers( CONNECT, resultHandler, faultHandler );
		}
 
		/**
		 * Execute remote connect method and return current user.
		 */
		public function connect( ) : void
		{
		  agent.execute( CONNECT );
		}
 
 
		//--------------------------------------------------------------------------
		// Event handlers
 
		/**
		 * Executed when remote connect method returns sucessfully.
		 */
		protected function connectResultHandler( event : ResultEvent ) : void
		{
		  executeResultHandler( event, parseConnectResult );
		}
 
 
		//--------------------------------------------------------------------------
		// Result parsers
 
		/**
		 * Parse the result of the remote connect method into a UserVO object
		 * that represents the user who is currently logged in.
		 * 
		 * If user is not logged in and does not have a user account then a uid
		 * of 0 is assigned and most UserVO fields are not available.
		 */
		protected function parseConnectResult( result : Object ) : UserVO
		{
		  var userObj : Object  = result.user;
			var userData : UserVO = new UserVO( );
 
			userData.sessionId = result.sessid;
			userData.uid       = userObj.userid;
			userData.hostname  = userObj.hostname;
 
			for ( var rid : String in userObj.roles )
			{
				userData.addRole( rid as int, userObj.roles[ rid ] );
			}
 
			if ( userData.uid )
			{
				userData.name           = userObj.name;
				userData.initMail       = userObj.init;
				userData.currentMail    = userObj.mail;
				userData.createdTime    = new Date( userObj.created );
				userData.lastLoginTime  = new Date( userObj.login );
				userData.lastAccessTime = new Date( userObj.access );
				userData.status         = userObj.status;
				userData.contact        = ( userObj.contact ? true : false );
				userData.timezone       = userObj.timezone;
				userData.language       = userObj.language;
				userData.imagePath      = userObj.picture;
			}			
 
			return userData;
		}
	}
}