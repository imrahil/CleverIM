/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.view.mediators
{
    import com.imrahil.bbapps.cleverinstant.signals.LogoutSignal;
    import com.imrahil.bbapps.cleverinstant.signals.StartupSignal;
    import com.imrahil.bbapps.cleverinstant.signals.UserLoggedSignal;
    import com.imrahil.bbapps.cleverinstant.signals.signaltons.DisplayActivityIndicatorSignal;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    import com.imrahil.bbapps.cleverinstant.view.ChatView;
    import com.imrahil.bbapps.cleverinstant.view.LoginView;
    import com.imrahil.bbapps.cleverinstant.view.MainAppNavigator;
    import com.imrahil.bbapps.cleverinstant.view.components.CustomActivityIndicator;
    
    import flash.filters.BlurFilter;
    
    import mx.logging.ILogger;
    
    import org.igniterealtime.xiff.data.im.RosterItemVO;
    import org.robotlegs.mvcs.Mediator;
    
    import qnx.dialog.AlertDialog;
    import qnx.events.QNXApplicationEvent;
    
    public class MainAppNavigatorMediator extends Mediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:MainAppNavigator;
        
        /**
         * SIGNALTONS
         */
		[Inject]
		public var displayActivityIndicator:DisplayActivityIndicatorSignal; 

        [Inject]
		public var userLoggedSignal:UserLoggedSignal;
		
//		[Inject]
//		public var errorSignal:ErrorSignal;
//		
		[Inject]
		public var logoutSignal:LogoutSignal;
		
		/**
         * SIGNAL -> COMMAND
         */
		[Inject]
		public var startupSignal:StartupSignal;

		
        /** variables **/
		private var myActivity:CustomActivityIndicator;
		private var alert:AlertDialog;
		
		private var topMenuVisible:Boolean = false;
		private var browserViewMode:Boolean = false;

		private var logger:ILogger;
 
		/** 
		 * CONSTRUCTOR 
		 */		
		public function MainAppNavigatorMediator()
		{
			super();
			
			logger = LogUtil.getLogger(this);
			logger.debug(": constructor");
		}
		
        /** 
         * onRegister 
         * Override the invoked of the <code>IMediator</code> and allow you to place your own initialization. 
         */		
        override public function onRegister():void
        {
			logger.debug(": onRegister");
	
//			CONFIG::releaseMode
//			{
//				eventMap.mapListener(QNXApplication.qnxApplication, QNXApplicationEvent.SWIPE_DOWN, onTopMenuSwipe);
//			}
			
			displayActivityIndicator.add(displayActivity);
			
            userLoggedSignal.add(onUserLoggedSignal);
			logoutSignal.add(onLogoutSuccess);
//			errorSignal.add(displayError);
			
            view.creationCompleteSignal.add(onViewCreationComplete);
        }

        private function onViewCreationComplete():void
        {
            startupSignal.dispatch();
        }
        /** methods **/		
		
		/**
		 * Display top menu and blur background 
		 * @param event
		 * 
		 */
		private function onTopMenuSwipe(event:QNXApplicationEvent):void
		{
			logger.debug(": onTopMenuSwipe");

//			Tweener.addTween(view.topMenu, {y: 0, time: 0.5});
//			view.mainNavigator.filters = [new BlurFilter(6, 6)];
//			view.topMenu.mouseCatcher.y = 0;
//			
//			eventMap.mapListener(view.topMenu.mouseCatcher, MouseEvent.MOUSE_DOWN, clickOutsideTopMenuHandler);
		}
		
//		/**
//		 * Hide top menu 
//		 * @param event
//		 * 
//		 */
//		private function clickOutsideTopMenuHandler(event:MouseEvent):void
//		{
//			logger.debug(": clickOutsideTopMenuHandler");
//
//			event.stopPropagation();
//			eventMap.unmapListener(view.topMenu.mouseCatcher, MouseEvent.MOUSE_DOWN, clickOutsideTopMenuHandler);
//			
//			hideTopMenu();
//		}
//		
//		private function hideTopMenu():void
//		{
//			if (topMenuVisible)
//			{
//				logger.debug(": hideTopMenu");
//				topMenuVisible = false;
//	
//				Tweener.addTween(view.topMenu, {y: -200, time: 0.5});
//				view.mainNavigator.filters = [];
//				view.topMenu.mouseCatcher.y = -600;
//			}
//		}
		
		private function onUserLoggedSignal(user:RosterItemVO):void
		{
            view.mainNavigator.pushView(ChatView);
		}
		
		private function onLogoutSuccess():void
		{
            view.mainNavigator.pushView(LoginView);
		}
		
		/**
		 * Display activity indicator and blur background 
		 * @param state
		 * 
		 */
		private function displayActivity(state:Boolean):void
		{
			logger.debug(": displayActivity - state: " + ((state) ? "show" : "hide"));
			
			if (state)
			{
				if (!myActivity)
				{
					myActivity = new CustomActivityIndicator();     
					view.addChild(myActivity);
				}
				else
				{
					myActivity.visible = true;
					view.mainNavigator.filters = [new BlurFilter(6, 6)];
					view.setChildIndex(myActivity, view.numChildren - 1);
				}
				myActivity.activityIndicator.animate(true);
			}
			else
			{
//				hideTopMenu();
				
				if (myActivity)
				{
					view.mainNavigator.filters = [];
					myActivity.activityIndicator.animate(false);
					myActivity.visible = false;	
				}
			}
		}
		
//		/**
//		 * Display error message 
//		 * @param errorMessage
//		 * 
//		 */
//		private function displayError(errorMessage:String):void
//		{
//			logger.debug(": displayError - " + errorMessage);
//
//			displayActivity(false);
//			
//			CONFIG::releaseMode
//			{
//				alert = new AlertDialog();
//				alert.title = "Error";
//				alert.message = "Following error occured: " + errorMessage;
//				alert.addButton("OK");
//				alert.dialogSize= DialogSize.SIZE_MEDIUM;
//				alert.addEventListener(Event.SELECT, alertButtonClicked); 
//				alert.show(IowWindow.getAirWindow().group);
//			}
//		}
//		
//		private function alertButtonClicked(event:Event):void
//		{
//			alert.cancel();
//		}
    }
}