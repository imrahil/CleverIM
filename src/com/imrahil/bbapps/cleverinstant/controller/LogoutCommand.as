/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.controller 
{
    import com.imrahil.bbapps.cleverinstant.constants.ApplicationConstants;
    import com.imrahil.bbapps.cleverinstant.model.CleverModel;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    
    import flash.net.SharedObject;
    import flash.utils.Dictionary;
    
    import mx.collections.ArrayCollection;
    import mx.logging.ILogger;
    
    import org.robotlegs.mvcs.SignalCommand;

    public final class LogoutCommand extends SignalCommand 
    {
        /** INJECTIONS **/
        [Inject]
        public var cleverModel:CleverModel;

        /** variables **/
        private var logger:ILogger;
        
        /** 
         * CONSTRUCTOR 
         */		
        public function LogoutCommand()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        /**
         * Method handle the logic for <code>LogoutCommand</code>
         */        
        override public function execute():void    
        {
            logger.debug(": execute");
            
            cleverModel.chatUserRoster = null;
            cleverModel.fullChatUserRoster = null;
            cleverModel.currentUser = null;
            cleverModel.currentChat = null;
            cleverModel.chatRoomList = new ArrayCollection();
            cleverModel.chatRooms = new Dictionary();
            cleverModel.displayOnlineOnly = false;
            
            var sessionSO:SharedObject = SharedObject.getLocal(ApplicationConstants.CLEVERIM_SO_NAME);
            sessionSO.clear();
        }
    }
}
