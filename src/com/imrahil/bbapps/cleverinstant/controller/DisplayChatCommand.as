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
    
    import org.igniterealtime.xiff.data.im.RosterItemVO;
    import org.robotlegs.mvcs.SignalCommand;

    public final class DisplayChatCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var chatUser:RosterItemVO;
        
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
        public function DisplayChatCommand()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }
        
        /**
         * Method handle the logic for <code>CreateNewChatCommand</code>
         */        
        override public function execute():void    
        {
            logger.debug(": execute");

            var chatRoom:ChatRoomVO;
            
            if (cleverModel.chatRooms[chatUser.jid.bareJID])
            {
                chatRoom = cleverModel.chatRooms[chatUser.jid.bareJID] as ChatRoomVO;
                cleverModel.currentChat = chatRoom;
            }
            else
            {
                chatRoom = new ChatRoomVO();
                chatRoom.displayName = chatUser.displayName;
                chatRoom.recipient = chatUser.jid;
                
                cleverModel.chatRooms[chatUser.jid.bareJID] = chatRoom;
                
                cleverModel.chatRoomList.addItem(chatRoom);
                chatRoomListChanged.dispatch(cleverModel.chatRoomList);

                cleverModel.currentChat = chatRoom;
            }
        }
    }
}
