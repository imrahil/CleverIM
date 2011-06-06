/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.view.mediators
{
    import com.imrahil.bbapps.cleverinstant.model.vo.ChatRoomVO;
    import com.imrahil.bbapps.cleverinstant.model.vo.MessageItemVO;
    import com.imrahil.bbapps.cleverinstant.signals.DisplayChatSignal;
    import com.imrahil.bbapps.cleverinstant.signals.DisplayOnlineOnlySignal;
    import com.imrahil.bbapps.cleverinstant.signals.LogoutSignal;
    import com.imrahil.bbapps.cleverinstant.signals.RemoveChatSignal;
    import com.imrahil.bbapps.cleverinstant.signals.SendMessageSignal;
    import com.imrahil.bbapps.cleverinstant.signals.signaltons.ChatRoomChangedSignal;
    import com.imrahil.bbapps.cleverinstant.signals.signaltons.ChatRoomListChangedSignal;
    import com.imrahil.bbapps.cleverinstant.signals.signaltons.ChatUserRosterChangedSignal;
    import com.imrahil.bbapps.cleverinstant.signals.signaltons.DisplayMessagesSignal;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    import com.imrahil.bbapps.cleverinstant.view.ChatView;
    
    import flash.text.TextFieldAutoSize;
    
    import mx.collections.ArrayCollection;
    import mx.logging.ILogger;
    
    import org.igniterealtime.xiff.data.im.RosterItemVO;
    import org.robotlegs.mvcs.Mediator;
    
    import qnx.ui.data.DataProvider;
    import qnx.ui.data.SectionDataProvider;
    import qnx.ui.listClasses.ICellRenderer;
    import qnx.ui.text.Label;

    public class ChatViewMediator extends Mediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:ChatView;

        /**
         * SIGNALTONS
         */
        [Inject]
        public var chatUserRosterChanged:ChatUserRosterChangedSignal;

        [Inject]
        public var chatRoomChanged:ChatRoomChangedSignal;

        [Inject]
        public var chatRoomListChanged:ChatRoomListChangedSignal;

        [Inject]
        public var displayMessages:DisplayMessagesSignal;

        /**
         * SIGNAL -> COMMAND
         */
        [Inject]
        public var displayOnlineOnlySignal:DisplayOnlineOnlySignal;

        [Inject]
        public var sendMessageSignal:SendMessageSignal;

        [Inject]
        public var displayChatSignal:DisplayChatSignal;

        [Inject]
        public var removeChatSignal:RemoveChatSignal;

        [Inject]
        public var logoutSignal:LogoutSignal;

        /** variables **/
        private var logger:ILogger; 
        
        private var currentChatRoom:ChatRoomVO;
        
        /** 
         * CONSTRUCTOR 
         */
        public function ChatViewMediator()
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

            chatUserRosterChanged.add(onChatUserRosterChanged);
            chatRoomListChanged.add(onChatRoomListChanged);
            chatRoomChanged.add(onChatRoomChanged);
            displayMessages.add(onDisplayMessages);
            
            view.displayOnlineOnlyClicked.add(onDisplayOnlineOnlyClicked);
            view.rosterListItemClicked.add(onRosterListItemClicked);
            view.displayChatSignal.add(onDisplayChatSignal);
            view.closeChatClicked.add(onCloseChatClicked);
            view.logoutClicked.add(onLogoutClicked);
            view.sendMessageClicked.add(onSendMessageClicked);
        }
        
        /** methods **/

        /** eventHandlers **/

        private function onChatUserRosterChanged(roster:SectionDataProvider):void
        {
            logger.debug(": onChatUserRosterChanged");

            if (view.rosterList.firstVisibleItem)
            {
                var firstItem:ICellRenderer = view.rosterList.firstVisibleItem; 
                var isHeader:Boolean = firstItem.isHeader;
                var visibleSectionIndex:int = firstItem.section;
                var visibleItemIndex:int = firstItem.index;
                
                view.rosterList.dataProvider = roster;
                view.rosterList.drawNow();
                
                if (isHeader)
                {
                    view.rosterList.scrollToIndex(visibleSectionIndex, 0);
                }
                else
                {
                    view.rosterList.scrollToIndexInSection(visibleSectionIndex, visibleItemIndex, 0);
                }
            }
            else
            {
                view.rosterList.dataProvider = roster;
            }
        }

        private function onChatRoomListChanged(chatRoomList:ArrayCollection):void
        {
            logger.debug(": onChatRoomListChanged");
            
            view.chatRoomListDropdown.dataProvider = new DataProvider(chatRoomList.source);
        }
        
        private function onChatRoomChanged(chatroom:ChatRoomVO):void
        {
            logger.debug(": onChatRoomChanged");

            if (chatroom != null)
            {
                view.chatRoomListDropdown.enabled = true;
                view.closeChatBtn.enabled = true;
                view.inputMessageTxt.enabled = true;
                view.sendMessageBtn.enabled = true;
                
                if (view.chatRoomListDropdown.dataProvider && view.chatRoomListDropdown.dataProvider.length > 0)
                {
                    for each (var room:ChatRoomVO in view.chatRoomListDropdown.dataProvider.data)
                    {
                        if (room.displayName == chatroom.displayName)
                        {
                            view.chatRoomListDropdown.selectedItem = room;
                            break;
                        }
                    }
                }
                
                onDisplayMessages(chatroom.messages);
            }
            else
            {
                while (view.messagesContainer.numChildren > 0) view.messagesContainer.removeChildAt(0);

                view.chatRoomListDropdown.enabled = false;
                view.closeChatBtn.enabled = false;
                view.inputMessageTxt.enabled = false;
                view.sendMessageBtn.enabled = false;
            }
        }
        
        private function onDisplayMessages(messageList:ArrayCollection):void
        {
            logger.debug(": onDisplayMessages");
            
            while (view.messagesContainer.numChildren > 0) view.messagesContainer.removeChildAt(0);

            var messageLabel:Label;
            var posY:int = 0;
            for each (var messageItem:MessageItemVO in messageList)
            {
                messageLabel = new Label();
                messageLabel.autoSize = TextFieldAutoSize.LEFT;
                messageLabel.htmlText = "<b> " + messageItem.author + "</b> - " + messageItem.message;
                messageLabel.y = posY;
                view.messagesContainer.addChild(messageLabel);
                
                posY += messageLabel.textHeight;
            }
            
            view.messagesScrollPane.update();
            
            if (view.messagesContainer.height > view.messagesScrollPane.height)
            {
                view.messagesScrollPane.scrollY = view.messagesContainer.height - view.messagesScrollPane.height;
            }
        }

        protected function onDisplayOnlineOnlyClicked(value:Boolean):void
        {
            logger.debug(": onDisplayOnlineOnlyClicked");

            displayOnlineOnlySignal.dispatch(value);
        }
        
        protected function onRosterListItemClicked():void
        {
            logger.debug(": onRosterListItemClicked");

            view.startChatBtn.enabled = true;
        }
        
        protected function onDisplayChatSignal(user:RosterItemVO):void
        {
            logger.debug(": onDisplayChatSignal");
  
            displayChatSignal.dispatch(user);
        }

        protected function onCloseChatClicked():void
        {
            logger.debug(": onCloseChatClicked");
            
            removeChatSignal.dispatch();
        }
        
        protected function onLogoutClicked():void
        {
            logger.debug(": onLogoutClicked");
            
            logoutSignal.dispatch();
        }
        
        protected function onSendMessageClicked(messageTxt:String):void
        {
            logger.debug(": onSendMessageClicked");
 
            sendMessageSignal.dispatch(messageTxt);
            
            view.inputMessageTxt.text = "";
        }
    }
}
