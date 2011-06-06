/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant
{
	import com.imrahil.bbapps.cleverinstant.controller.*;
	import com.imrahil.bbapps.cleverinstant.model.CleverModel;
	import com.imrahil.bbapps.cleverinstant.services.IJabberService;
	import com.imrahil.bbapps.cleverinstant.services.JabberService;
	import com.imrahil.bbapps.cleverinstant.services.JabberServiceMock;
	import com.imrahil.bbapps.cleverinstant.signals.*;
	import com.imrahil.bbapps.cleverinstant.signals.signaltons.*;
	import com.imrahil.bbapps.cleverinstant.view.*;
	import com.imrahil.bbapps.cleverinstant.view.mediators.*;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.SignalContext;
	
	public class CleverIMContext extends SignalContext
	{
		public function CleverIMContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		/**
		 *  The Startup Hook
		 */		
		override public function startup():void
		{
			// todo: Add Commands
			signalCommandMap.mapSignalClass(StartupSignal, StartupCommand);

            // request signals
            signalCommandMap.mapSignalClass(LoginSignal, LoginCommand);
            signalCommandMap.mapSignalClass(LogoutSignal, LogoutCommand);
            signalCommandMap.mapSignalClass(SaveLoginDetailsSignal, SaveLoginDetailsCommand);

            signalCommandMap.mapSignalClass(DisplayChatSignal, DisplayChatCommand);
            signalCommandMap.mapSignalClass(SendMessageSignal, SendMessageCommand);
            signalCommandMap.mapSignalClass(RemoveChatSignal, RemoveChatCommand);
            
            // response signals
            signalCommandMap.mapSignalClass(UserLoggedSignal, UserLoggedCommand);
            signalCommandMap.mapSignalClass(ChatUserRosterLoadedSignal, ChatUserRosterLoadedCommand);
            signalCommandMap.mapSignalClass(ChatMessageReceivedSignal, ChatMessageReceivedCommand);

            signalCommandMap.mapSignalClass(DisplayOnlineOnlySignal, DisplayOnlineOnlyCommand);
            
			// todo: Add Model
            injector.mapSingleton(CleverModel);
			
			// todo: Add Services
            injector.mapSingletonOf(IJabberService, JabberService);
			
			// todo: Add View
            mediatorMap.mapView(MainAppNavigator, MainAppNavigatorMediator);
            mediatorMap.mapView(LoginView, LoginViewMediator);
            mediatorMap.mapView(ChatView, ChatViewMediator);
			
			// todo: Add Signalton
            injector.mapSingleton(ChatUserRosterChangedSignal);
            injector.mapSingleton(ChatRoomChangedSignal);
            injector.mapSingleton(ChatRoomListChangedSignal);
            injector.mapSingleton(DisplayActivityIndicatorSignal);
            injector.mapSingleton(DisplayMessagesSignal);
		}		
	}
}
