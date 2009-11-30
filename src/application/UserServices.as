package application
{ 
	import com.collectivecolors.rpc.IServiceAgent;
	import com.collectivecolors.rpc.RemoteService;
	
	import mx.rpc.events.ResultEvent;
 
 
	public class UserServices extends RemoteService
	{
		/**
		 * Variables
		 **/
 
 		private static const GET : String = 'get';
 		
 		/**
 		 * Constructor
 		 **/
 
		public function UserServices( agent : IServiceAgent, urls : Array = null )
		{
			super( agent, urls );
 
			// Register view service handlers
			agent.register( GET, userGetResultHandler, serviceFaultHandler );
		}
 
 
 
		/**
		 * Methods
		 **/
		 
		// Service methods
		public function userGetHandlers( resultHandler : Function, faultHandler : Function = null ) : void
		{
		  registerHandlers( GET, resultHandler, faultHandler );
		}
 
		//Execute remote connect method and return current user.
		public function userGet( input:String ) : void
		{
		  agent.execute( GET , input );
		}
		
		//Executed when remote connect method returns sucessfully.
		protected function userGetResultHandler( event : ResultEvent ) : void
		{
		  executeResultHandler( event,  parseUserGetResult);
		}
		
		//Since we only need the name of the user who created the blog, return only the username
		protected function parseUserGetResult( result:Object ) : String
		{
			//Return the user's name
			return result.name;
		}
	}
}