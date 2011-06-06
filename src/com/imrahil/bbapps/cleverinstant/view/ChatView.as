/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.view
{
    import com.imrahil.bbapps.cleverinstant.model.vo.ChatRoomVO;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    import com.imrahil.bbapps.cleverinstant.view.components.ChatRoomDropdownCellRenderer;
    import com.imrahil.bbapps.cleverinstant.view.components.RosterListRenderer;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.ui.Keyboard;
    
    import mx.logging.ILogger;
    
    import org.igniterealtime.xiff.data.im.RosterItemVO;
    import org.osflash.signals.Signal;
    
    import qnx.ui.buttons.CheckBox;
    import qnx.ui.buttons.LabelButton;
    import qnx.ui.buttons.LabelPlacement;
    import qnx.ui.core.Container;
    import qnx.ui.core.ContainerAlign;
    import qnx.ui.core.ContainerFlow;
    import qnx.ui.core.Containment;
    import qnx.ui.core.SizeUnit;
    import qnx.ui.core.Spacer;
    import qnx.ui.events.ListEvent;
    import qnx.ui.listClasses.DropDown;
    import qnx.ui.listClasses.ListSelectionMode;
    import qnx.ui.listClasses.ScrollDirection;
    import qnx.ui.listClasses.ScrollPane;
    import qnx.ui.listClasses.SectionList;
    import qnx.ui.text.Label;
    import qnx.ui.text.TextInput;
    
    public class ChatView extends Sprite
    {
        public var displayOnlineOnlyClicked:Signal = new Signal(Boolean);
        public var rosterListItemClicked:Signal = new Signal();
        public var displayChatSignal:Signal = new Signal(RosterItemVO);
        public var closeChatClicked:Signal = new Signal();
        public var logoutClicked:Signal = new Signal();
        public var sendMessageClicked:Signal = new Signal(String);

        private var logger:ILogger;
        
        private var displayOnlineOnly:CheckBox;
        
        public var rosterList:SectionList;
        
        private var titleTextFormat:TextFormat;
        
        private var tempChatRoom:ChatRoomVO;

        // CONTAINERS
        private var mainContainer:Container;
        
        private var leftContainer:Container;
        private var leftTopContainer:Container;
        private var leftBottomContainer:Container;
        
        private var rightContainer:Container;
        private var rightTopContainer:Container;
        private var rightBottomContainer:Container;
        // END OF CONTAINERS
        
        public var messagesScrollPane:ScrollPane;
        public var messagesContainer:Sprite;
        
        // BUTTONS
        public var startChatBtn:LabelButton; 
        public var chatRoomListDropdown:DropDown;
        public var closeChatBtn:LabelButton; 
        public var logoutBtn:LabelButton; 
        public var inputMessageTxt:TextInput;
        public var sendMessageBtn:LabelButton;
        
        public function ChatView()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
            
            this.addEventListener(Event.ADDED_TO_STAGE, view_addedToStage);

            titleTextFormat = new TextFormat();
            titleTextFormat.size = 25;
            titleTextFormat.align = TextFormatAlign.CENTER;
        }
        
        protected function view_addedToStage(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, view_addedToStage);
            
            initUI();
        }

        protected function initUI():void
        {
            logger.debug(": initUI");
            
            // MAIN CONTAINER
            mainContainer = new Container();
            mainContainer.margins = Vector.<Number>([10, 0, 10, 0]);
            mainContainer.flow = ContainerFlow.HORIZONTAL;
            addChild(mainContainer);

            // LEFT CONTAINER
            leftContainer = new Container();
            leftContainer.margins = Vector.<Number>([0, 10, 10, 0]);            
            leftContainer.flow = ContainerFlow.VERTICAL;
            leftContainer.padding = 10;
            leftContainer.size = 25;
            leftContainer.sizeUnit = SizeUnit.PERCENT;            
            leftContainer.align = ContainerAlign.NEAR;
      
            // LEFT-TOP CONTAINER
            leftTopContainer = new Container();
            leftTopContainer.size = 4;
            leftTopContainer.sizeUnit = SizeUnit.PERCENT;
            leftTopContainer.flow = ContainerFlow.HORIZONTAL;
            leftTopContainer.align = ContainerAlign.MID;
            leftTopContainer.containment = Containment.DOCK_TOP; 

            // LEFT-BOTTOM CONTAINER
            leftBottomContainer = new Container();
            leftBottomContainer.size = 9;
            leftBottomContainer.sizeUnit = SizeUnit.PERCENT;
            leftBottomContainer.flow = ContainerFlow.HORIZONTAL;
            leftBottomContainer.align = ContainerAlign.NEAR;
            leftBottomContainer.containment = Containment.DOCK_BOTTOM; 
            
            // RIGHT CONTAINER
            rightContainer = new Container();
            rightContainer.margins = Vector.<Number>([10, 0, 10, 0]);            
            rightContainer.size = 75;            
            rightContainer.sizeUnit = SizeUnit.PERCENT;
            rightContainer.flow = ContainerFlow.VERTICAL;
            
            // RIGHT-TOP CONTAINER
            rightTopContainer = new Container();
            rightTopContainer.size = 9;
            rightTopContainer.sizeUnit = SizeUnit.PERCENT;
            rightTopContainer.flow = ContainerFlow.HORIZONTAL;
            
            // RIGHT-BOTTOM CONTAINER
            rightBottomContainer = new Container();
            rightBottomContainer.size = 10;
            rightBottomContainer.sizeUnit = SizeUnit.PERCENT;
            rightBottomContainer.flow = ContainerFlow.HORIZONTAL;
            rightBottomContainer.align = ContainerAlign.MID;
            
            // MESSAGES SCROLL PANE
            messagesScrollPane = new ScrollPane();
            messagesScrollPane.size = 81;
            messagesScrollPane.sizeUnit = SizeUnit.PERCENT;
            messagesScrollPane.scrollDirection = ScrollDirection.VERTICAL;
            
            messagesContainer = new Sprite();
            
            // BORDER BETWEN LEFT & RIGHT
            var border:Sprite = new Sprite();
            border.graphics.beginFill(0x666666);
            border.graphics.drawRect(0, 0, 2, this.stage.height);
            border.graphics.endFill();
            
            
            // LEFT TITLE
            var rosterTitleLbl:Label = new Label();
            rosterTitleLbl.format = titleTextFormat;
            rosterTitleLbl.text = "List:";
            rosterTitleLbl.sizeUnit = SizeUnit.PIXELS;
            rosterTitleLbl.autoSize = TextFieldAutoSize.CENTER;

            // DISPLAY ONLINE ONLY
            displayOnlineOnly = new CheckBox();
            displayOnlineOnly.width = 140;
            displayOnlineOnly.label = "Online only";
            displayOnlineOnly.labelPlacement = LabelPlacement.LEFT;
            displayOnlineOnly.labelPadding = 0;
            displayOnlineOnly.addEventListener(MouseEvent.CLICK, onDisplayChange);

            // ROSTER LIST
            rosterList = new SectionList();
            rosterList.size = 100;
            rosterList.sizeUnit = SizeUnit.PERCENT;
            rosterList.headerHeight = 40;
            rosterList.allowDeselect = false;
            rosterList.selectionMode = ListSelectionMode.SINGLE;
            rosterList.setSkin(RosterListRenderer);
            rosterList.addEventListener(ListEvent.ITEM_CLICKED, onRosterListItemClick);
            
            // START CHAT BUTTON
            startChatBtn = new LabelButton();
            startChatBtn.label = "CHAT";
            startChatBtn.width = 140;
            startChatBtn.enabled = false;
            startChatBtn.addEventListener(MouseEvent.CLICK, onStartChatBtnClicked);

            
            // RIGHT CONTAINER CONTENT
            
            // COMBO WITH OPEN CHATS
            var chatsTitleLbl:Label = new Label();
            chatsTitleLbl.format = titleTextFormat;
            chatsTitleLbl.text = "Chats:";
            chatsTitleLbl.autoSize = TextFieldAutoSize.CENTER;

            chatRoomListDropdown = new DropDown();
            chatRoomListDropdown.width = 300;
            chatRoomListDropdown.setListSkin(ChatRoomDropdownCellRenderer);
            chatRoomListDropdown.enabled = false;
            chatRoomListDropdown.dropDownParent = rightContainer;
            chatRoomListDropdown.addEventListener(Event.OPEN, onChatRoomListDropdownOpen);
            chatRoomListDropdown.addEventListener(Event.SELECT, onChatRoomListDropdownSelect);

            // CLOSE BUTTON
            closeChatBtn = new LabelButton();
            closeChatBtn.label = "Close";
            closeChatBtn.width = 80;
            closeChatBtn.enabled = false;
            closeChatBtn.addEventListener(MouseEvent.CLICK, onCloseChatBtnClicked);

            // LOGOUT BUTTON
            logoutBtn = new LabelButton();
            logoutBtn.label = "Logout";
            logoutBtn.width = 90;
            logoutBtn.addEventListener(MouseEvent.CLICK, onLogoutBtnClicked);

            // BOTTOM INPUT TEXT FIELD
            inputMessageTxt = new TextInput();
            inputMessageTxt.size = 100;
            inputMessageTxt.sizeUnit = SizeUnit.PERCENT;
            inputMessageTxt.enabled = false;
            inputMessageTxt.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
            inputMessageTxt.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
            inputMessageTxt.addEventListener(KeyboardEvent.KEY_DOWN, onKeyBoardEvent);

            // BOTTOM SEND BUTTON
            sendMessageBtn = new LabelButton();
            sendMessageBtn.label = "Send";
            sendMessageBtn.enabled = false;
            sendMessageBtn.addEventListener(MouseEvent.CLICK, onSendMessageBtnClicked);

            // ADD CHILD SECTION
            leftTopContainer.addChild(rosterTitleLbl);
            leftTopContainer.addChild(new Spacer(100));
            leftTopContainer.addChild(displayOnlineOnly);
            leftContainer.addChild(leftTopContainer);
            
            leftContainer.addChild(rosterList);
            
            leftBottomContainer.addChild(new Spacer(50));
            leftBottomContainer.addChild(startChatBtn);
            leftBottomContainer.addChild(new Spacer(50));
            leftContainer.addChild(leftBottomContainer);

            rightTopContainer.addChild(new Spacer(10, SizeUnit.PIXELS));
            rightTopContainer.addChild(chatsTitleLbl);
            rightTopContainer.addChild(new Spacer(10, SizeUnit.PIXELS));
            rightTopContainer.addChild(chatRoomListDropdown);
            rightTopContainer.addChild(new Spacer(30, SizeUnit.PIXELS));
            rightTopContainer.addChild(closeChatBtn);
            rightTopContainer.addChild(new Spacer(100, SizeUnit.PERCENT));
            rightTopContainer.addChild(logoutBtn);

            rightBottomContainer.addChild(new Spacer(10, SizeUnit.PIXELS));
            rightBottomContainer.addChild(inputMessageTxt);
            rightBottomContainer.addChild(new Spacer(20, SizeUnit.PIXELS));
            rightBottomContainer.addChild(sendMessageBtn);
            rightBottomContainer.addChild(new Spacer(10, SizeUnit.PIXELS));
            
            rightContainer.addChild(rightTopContainer);
//            rightContainer.addChild(messagesContainer);
            messagesScrollPane.setScrollContent(messagesContainer);
            rightContainer.addChild(messagesScrollPane);
            rightContainer.addChild(rightBottomContainer);

            // ADD TO MAIN CONTAINER
            mainContainer.addChild(leftContainer);   
            mainContainer.addChild(border);   
            mainContainer.addChild(rightContainer); 
            
            mainContainer.setSize(stage.stageWidth, stage.stageHeight);
        }
        
        private function onFocusIn(event:FocusEvent):void
        {
            mainContainer.setPosition(0, stage.stageHeight/2);
            mainContainer.setSize(stage.stageWidth, stage.stageHeight/2);
        }
        
        private function onFocusOut(event:FocusEvent):void
        {
            mainContainer.setSize(stage.stageWidth, stage.stageHeight);
            mainContainer.setPosition(0, 0);
        }
        
        protected function onKeyBoardEvent(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.ENTER)
            {
                onSendMessageBtnClicked(null);    
            }
        }

        protected function onDisplayChange(event:MouseEvent):void
        {
            logger.debug(": onDisplayChange");

            displayOnlineOnlyClicked.dispatch(displayOnlineOnly.selected);
        }

        protected function onRosterListItemClick(event:ListEvent):void
        {
            logger.debug(": onRosterListItemClick");

            rosterListItemClicked.dispatch();
        }

        protected function onStartChatBtnClicked(event:MouseEvent):void
        {
            logger.debug(": onStartChatBtnClicked");

            displayChatSignal.dispatch(rosterList.selectedItem as RosterItemVO);
        }
        
        protected function onCloseChatBtnClicked(event:MouseEvent):void
        {
            logger.debug(": onCloseChatBtnClicked");

            closeChatClicked.dispatch();
        }
        
        protected function onLogoutBtnClicked(event:MouseEvent):void
        {
            logger.debug(": onLogoutBtnClicked");

            logoutClicked.dispatch();
        }
        
        protected function onSendMessageBtnClicked(event:MouseEvent):void
        {
            logger.debug(": onSendMessageBtnClicked");

            if (inputMessageTxt.text != "")
            {
                sendMessageClicked.dispatch(inputMessageTxt.text);
            }
        }
        
        protected function onChatRoomListDropdownOpen(event:Event):void
        {
            logger.debug(": onChatRoomListDropdownOpen");
            
            tempChatRoom = (event.currentTarget as DropDown).selectedItem as ChatRoomVO;
        }
        
        protected function onChatRoomListDropdownSelect(event:Event):void
        {
            logger.debug(": onChatRoomListDropdownSelect");
            
            var selectedChatRoom:ChatRoomVO = (event.currentTarget as DropDown).selectedItem as ChatRoomVO;
            
            if (selectedChatRoom != tempChatRoom)
            {
                displayChatSignal.dispatch(new RosterItemVO(selectedChatRoom.recipient));
                
                tempChatRoom = null;
            }
        }
    }
}
