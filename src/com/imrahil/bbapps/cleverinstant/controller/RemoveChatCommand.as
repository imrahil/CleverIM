/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.controller 
{
    import com.imrahil.bbapps.cleverinstant.model.CleverModel;
    import com.imrahil.bbapps.cleverinstant.model.vo.ChatRoomVO;
    import com.imrahil.bbapps.cleverinstant.signals.signaltons.ChatRoomListChangedSignal;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    
    import mx.logging.ILogger;
    
    import org.robotlegs.mvcs.SignalCommand;

    public final class RemoveChatCommand extends SignalCommand 
    {
        /** INJECTIONS **/
        [Inject]
        public var cleverModel:CleverModel;

        [Inject]
        public var chatRoomListChanged:ChatRoomListChangedSignal;
        
        /** variables **/
        private var logger:ILogger;
        
        /** 
         * CONSTRUCTOR 
         */		
        public function RemoveChatCommand()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        /**
         * Method handle the logic for <code>RemoveChatCommand</code>
         */        
        override public function execute():void    
        {
            logger.debug(": execute");

            cleverModel.chatRoomList.removeItemAt(cleverModel.chatRoomList.getItemIndex(cleverModel.currentChat));
            delete cleverModel.chatRooms[cleverModel.currentChat.recipient.bareJID];
            chatRoomListChanged.dispatch(cleverModel.chatRoomList);

            if (cleverModel.chatRoomList.length > 0)
            {
                cleverModel.currentChat = cleverModel.chatRoomList.getItemAt(cleverModel.chatRoomList.length - 1) as ChatRoomVO;
            }
            else
            {
                cleverModel.currentChat = null;
            }
        }
    }
}
