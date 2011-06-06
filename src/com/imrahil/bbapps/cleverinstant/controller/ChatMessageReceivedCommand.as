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
    import com.imrahil.bbapps.cleverinstant.model.vo.MessageItemVO;
    import com.imrahil.bbapps.cleverinstant.signals.signaltons.ChatRoomListChangedSignal;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    
    import mx.logging.ILogger;
    
    import org.igniterealtime.xiff.core.EscapedJID;
    import org.igniterealtime.xiff.data.im.RosterItemVO;
    import org.robotlegs.mvcs.SignalCommand;

    public final class ChatMessageReceivedCommand extends SignalCommand 
    {
        [Inject]
        public var fromUser:EscapedJID;
        
        [Inject]
        public var message:String;
        
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
        public function ChatMessageReceivedCommand()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }
    
        /**
         * Method handle the logic for <code>ChatMessageReceivedCommand</code>
         */        
        override public function execute():void    
        {
            logger.debug(": execute");

            var newMessage:MessageItemVO;
            var chatRoom:ChatRoomVO;
            
            if (cleverModel.chatRooms[fromUser.bareJID])
            {
                if (cleverModel.currentChat && cleverModel.currentChat.recipient.bareJID == fromUser.bareJID)
                {
                    newMessage = new MessageItemVO();
                    newMessage.author = cleverModel.currentChat.displayName;
                    newMessage.message = message;
                    
                    cleverModel.addMessageToCurrentChatRoom(newMessage);
                }
                else
                {
                    chatRoom = cleverModel.chatRooms[fromUser.bareJID] as ChatRoomVO;

                    newMessage = new MessageItemVO();
                    newMessage.author = chatRoom.displayName;
                    newMessage.message = message;
                    
                    chatRoom.messages.addItem(newMessage);
                }
            }
            else
            {
                var displayName:String = fromUser.bareJID;
                
                for each (var user:RosterItemVO in  cleverModel.chatUserRoster)
                {
                    if (user.jid.bareJID == fromUser.bareJID)
                    {
                        displayName = user.displayName;
                        break;
                    }
                }
                
                chatRoom = new ChatRoomVO();
                chatRoom.displayName = displayName;
                chatRoom.recipient = fromUser.unescaped;
                
                cleverModel.chatRooms[fromUser.bareJID] = chatRoom;
                
                cleverModel.chatRoomList.addItem(chatRoom);
                chatRoomListChanged.dispatch(cleverModel.chatRoomList);
                
                cleverModel.currentChat = chatRoom;
                
                newMessage = new MessageItemVO();
                newMessage.author = displayName;
                newMessage.message = message;
                
                cleverModel.addMessageToCurrentChatRoom(newMessage);
            }
        }
    }
}
