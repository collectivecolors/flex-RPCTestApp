package application
{	
	import com.collectivecolors.rpc.AMFAgent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	import mx.controls.List;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;


	public class ApplicationClass extends Application
	{
		/**
		 * MXML Components
		 **/
		 
		 public var lstBlogs:List;
		 public var lstTerms:List;
		 
		 /**
		 * RPC Services
		 **/
		 
		 public var views:ViewsServices;

		/**
		 * Constructor And Creation Complete Handler
		 **/

		public function ApplicationClass()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}


		public function creationCompleteHandler(value:Event):void
		{	
			//Add Event Listeners
			lstBlogs.addEventListener(ListEvent.ITEM_CLICK, lstBlogsClickHandler);
			lstTerms.addEventListener(ListEvent.ITEM_CLICK, lstTermsClickHandler);
			systemManager.addEventListener(MouseEvent.MOUSE_WHEEL, lstBlogsWheelHandler, true);
			
			//Create instance of AMFAgent with the "views" source
			var viewsAmfAgent:AMFAgent = new AMFAgent("views", null);
			//Set the URL to the Drupal Services Module we mean to connect with
			viewsAmfAgent.addChannel("http://services6.collectivecolors.com/services/amfphp");
			//Create instance of ViewsServices, and give it a reference to the above AMFAgent
			views = new ViewsServices(viewsAmfAgent, null);
			//Set the event handlers for the ViewsServices class
			views.viewGetHandlers(viewsConnectHandler, faultHandler);
			
			//Retrieve the popular blog terms
			retrieveBlogTerms();
			//Retrieve all blogs
			retrieveBlogs();
			
			/**
			 * INERT CODE
			 * 
			 * One day, this code may do something. Quite possibly something of vital importance. 
			 * But that day is not today, and until that day, when this code is finally allowed 
			 * to fulfill its purpose it will remain unused and unnoticed, but never forgotten.
			
			//Create instance of AMFAgent with the "user" source
			var userAmfAgent:AMFAgent = new AMFAgent("user", null);
			//Set the URL to the Drupal Services Module we mean to connect with
			userAmfAgent.addChannel("http://services6.collectivecolors.com/services/amfphp");
			//Create instance of UserServices, and give it a reference to the above AMFAgent
			var user:UserServices = new UserServices(userAmfAgent, null);
			//Set the event handlers for the ViewsServices class
			user.userGetHandlers(userConnectHandler, faultHandler);			
			*/
		}


		/**
		 * Event Handlers
		 **/
		 
		 //If the user clicks on a blog take them to that blog in a new browser window/tab
		 public function lstBlogsClickHandler( event:ListEvent ):void{
		 	var url:String = "http://services6.collectivecolors.com/" + lstBlogs.selectedItem.path;
		 	navigateToURL(new URLRequest(url));
		 }
		 
		 //When the user clicks on a search term, pull up all blogs that have that term
		 public function lstTermsClickHandler( event:ListEvent ):void{
		 	//The "All" term is special as its not truly a term supported by the site, so we handle it locally
		 	//The "All" term is added by the parser in the ViewsServices class
		 	if(lstTerms.selectedItem == "ALL"){
		 		retrieveBlogs();
		 	}
		 	//The user has selected a specific term, so we'll give them only blogs that match that parameter
		 	else{
		 		retrieveBlogs(lstTerms.selectedItem as String);
		 	}
		 }
		 
		 //Allows mouse wheel scrolling as long as the user is focused anywhere in the application
		 public function lstBlogsWheelHandler( event:MouseEvent ):void{
		 	if(event.delta > 0){
		 		lstBlogs.validateNow();
		 		//If the scroll position is already at the minimum, do nothing
		 		if(lstBlogs.verticalScrollPosition == 0){return;}
		 		//Move the scroll position down
		 		lstBlogs.verticalScrollPosition = lstBlogs.verticalScrollPosition - 1;
		 	}
		 	else if(event.delta < 0){
		 		lstBlogs.validateNow();
		 		//If the scroll position is already at the maximum, do nothing
		 		if(lstBlogs.verticalScrollPosition == lstBlogs.maxVerticalScrollPosition){return;}
		 		//Move the scroll position up
		 		lstBlogs.verticalScrollPosition = lstBlogs.verticalScrollPosition + 1;
		 	}
		 }
		
		public function viewsConnectHandler( result:Array ):void{
			//Check to see if the returned results are BlogVOs
			if(result[0] is BlogVO){
				lstBlogs.dataProvider = result;
			}
			//Check to see if the returned results are strings
			else if(result[0] is String){
				lstTerms.dataProvider = result;
			}
		 }
		 
		 public function faultHandler( fault:Object ):void{
		 	Alert.show(String(fault));
		 }
		 
		 /**
		 * Methods
		 **/
		 
		 public function retrieveBlogTerms():void{			
			views.viewGet("popular_blog_terms", "terms");
		 }
		 
		 public function retrieveBlogs(term:String = null):void{
			//The user wants to search for all blog entries
			if(term == null){
		 		views.viewGet("recent_blog_entries", "blogs");
		 	}
		 	//The user only want to search for a specific keyword
		 	else{
		 		views.viewGet("recent_blog_entries", "blogs", term);
		 	}
		 }
	}
}