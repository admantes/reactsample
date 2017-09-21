package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*; 
	import flash.utils.*;
	import flash.net.*;
	
	/**
	 * ...
	 * @author APM
	 */
	public class Main extends Sprite 
	{
		
		[Embed(source='BOXes.swf', symbol='charBox_mov')]
		 private var boxClass:Class;		
		 private var mainx_btn:MovieClip;
			  
		 [Embed(source = 'BOXes.swf', symbol = 'bg')]
		 private var bgClass:Class;		
		 private var bg:Sprite;
		 
		 [Embed(source = 'BOXes.swf', symbol = 'textbg')]
		 private var txtbgClass:Class;		
		 private var txtbg:MovieClip;
		 
		 [Embed(source = 'BOXes.swf', symbol = 'checkBtn_mov')]
		 private var chkBtnClass:Class;	 
		 private var chkBtn_mov:MovieClip;
		 
		//For Start Menu 
		[Embed(source = 'BOXes.swf', symbol = 'startBG')]
		private var startBGClass:Class;		
		private var startBG:MovieClip;
			
		[Embed(source = 'BOXes.swf', symbol = 'play')]
		private var playBtnClass:Class;		
		private var playBtn:MovieClip;
		
		[Embed(source='BOXes.swf', symbol='testMovie')]
		private var testClass:Class;		
		private var testMov:MovieClip;
		
		[Embed(source = 'loading.swf', symbol = 'load_mov')]
		private var loadMovClass:Class;		
		private var loadMov:MovieClip;
		
		private var txtContent:String;
		private var charList:Array;
		private var alphabetList:Array;;
		private var vowelLIST1:Array;
		private var vowelLIST2:Array;
		private var specCharList:Array;
		private var chargenList:Array = [];
		private  var objArr:Array = new Array();
		private var label:TextField = new TextField();
		private var timeTxt:TextField = new TextField();
		private	var ScoreText1:TextField = new TextField();
		private var scoreText:TextField = new TextField();
			
		private var neighborArr:Array;
		private var prevHit:int=0;
		private var valWordsArr:Array = [];
		private var mainScore:int = 0;
		
		private var gameTimer:Timer = new Timer(1000,120);  // Time Limit in Seconds, Default 120
		private var gameMode:String = "new";
		
		private var gOvrText:TextField = new TextField();
		
		private var withLogin:Boolean = false;
		
		private var uName:String = "User";
	 
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			 
			bg = new bgClass() as Sprite;
			addChild(bg);	
			CreateStartMenu();
			setText();
			
		}
		
		// TEST Load Text
		private function setText():void {
			var netText:TextLoader = new TextLoader("english.dic");
			netText.addEventListener("LoadSuccess",TextLoaded)
		}
		
		private function TextLoaded(e:Event):void {
			txtContent  = e.currentTarget.txt;			
					
			//inserted in TextLoad function to ensure source txt has been loaded before performing operations
			 			
			InitializeVariables()			 
			//CreateStartMenu();			
			AddPlayButton();
			
			loadMov.visible = false;
		} 
		
		private function CreateStartMenu():void {
		
			//Start menu Background
		 startBG = new startBGClass() as MovieClip;
		 
		 addChild(startBG);
		 startBG.stop();
		 startBG.x = 7;
		 startBG.y = 7;
		  
		startBG.hiScore_mov.visible = false;
		startBG.hiScore_mov.alpha = 0;
				
		  startBG.uName_mov.visible = true;
		 
		  startBG.sandmantis_txt.addEventListener(MouseEvent.MOUSE_UP, gotoSandMantis);
		  
		  // LOADING GAME MOVIE
		  loadMov = new loadMovClass() as MovieClip;
		   addChild(loadMov);
		   loadMov.x = 250;
		 loadMov.y = 200;
		   
		}
		
		 
		private function AddPlayButton():void {
			
		 playBtn = new playBtnClass() as MovieClip;
	 
		 addChild(playBtn);
		 playBtn.stop();
		 playBtn.btnText.text = "Play";
		 playBtn.x = 280;
		 playBtn.y = 210;
	
		 playBtn.addEventListener(MouseEvent.MOUSE_UP, playBtnClicked);
		 playBtn.addEventListener(MouseEvent.MOUSE_OVER, hover);
		 playBtn.addEventListener(MouseEvent.MOUSE_OUT, checkOut);
		 playBtn.addEventListener(MouseEvent.MOUSE_DOWN, btnDown);
			
		}
		
		private function playBtnClicked(e:Event):void {
			trace("PLay na to!!!");			
			
			 
			  
			 //RemoveStartMenu();
			 if (gameMode == "new") {	
				 if (startBG.uName_mov.uName_txt.text == "" ) {
					startBG.uName_mov.uName_txt.text = "Enter username here"; 
					
				 }else {	
					 uName = startBG.uName_mov.uName_txt.text;
					ShowStartMenu(false);
					NewGame();
				 }
				 
				 
			 }else {	
				  
					ShowStartMenu(false);
				 removeChild(gOvrText);
				 ShowGameElements(true);
				 ResetGame();
			 }
			
			 
		}
		
		private function ShowStartMenu(_flag:Boolean):void {
			if(_flag){
				startBG.alpha = 1;
				playBtn.alpha = 1;  
				}
			else {
				startBG.alpha = 0;
				playBtn.alpha = 0;
			}
			
				startBG.visible = _flag;
				playBtn.visible = _flag; 
				 
				 startBG.hiScore_mov.visible = true;
			     startBG.hiScore_mov.alpha = 1;
				 startBG.uName_mov.visible = false;
				 
			 if (gameMode == "replay") {	
				
				 playBtn.btnText.text = "Play Again";
				 trace("Replay na to");
			 
			  addChild(gOvrText);
			  
			   var format:TextFormat = new TextFormat();
			    format.font = "Verdana";
				format.color = 0xFF0000;
				format.size = 20;
				format.underline = false;
		 
				  var formatLite:TextFormat = new TextFormat();
			    formatLite.font = "Verdana";
				formatLite.color = 0xFF0000;
				formatLite.size = 20;
				formatLite.underline = false;
				
			  gOvrText.defaultTextFormat = formatLite;
			  gOvrText.autoSize = TextFieldAutoSize.LEFT;

			  gOvrText.multiline = true
			  gOvrText.x = 175;
			  gOvrText.y = 155;
			  gOvrText.selectable = false;
			  gOvrText.width = 400;
			  gOvrText.text = "Game Over! Your total score is "   + String(mainScore) + " points"; 
			    
			  getHiScores();
			 }
			
		}
		
		private function RemoveStartMenu():void {
			removeChild(startBG);
			removeChild(playBtn);
		}
		 
		private function ShowGameElements(_num:Boolean):void {
			var show:int;
 
			
			if (_num==true) {				
				show = 1;	
				displayBoxes();
			}else { 	
				txtbg.disTxt.text = "";
				show = 0;				 
			}
			
			chkBtn_mov.alpha = show; 
			txtbg.alpha = show; 				
			label.alpha = show; 
			scoreText.alpha = show; 
			timeTxt.alpha = show; 
			ScoreText1.alpha = show; 
			 
			chkBtn_mov.visible = _num; 
			txtbg.visible = _num; 				
			label.visible = _num; 
			scoreText.visible = _num; 
			timeTxt.visible = _num 
			ScoreText1.visible = _num; 
			
				for (var i:int = 0; i < 16; i++) {
				 //objArr[i].alpha = show; 
				 //objArr[i].mouseEnabled = _num; 
				 
				 if (_num == false) {		
					removeChild(objArr[i]);
				 }
				 
				}
				
			
		}
		
		private function NewGame():void {
			
			generateCharList();	
			displayBoxes();					
			displayCheckBox();
		  	displayTextBox();			
			starTimer();
			
		}
		
		private function CheckWords(_source:String):Boolean {
			
			// Validates if chars can be found on loaded text
			 
			var pSearchStr:String = _source ;  
									
			pSearchStr = "\n" + pSearchStr + "\r";
			//trace (pSearchStr + "this is the search string");
						
			var pStr:int = txtContent.indexOf(pSearchStr);
			
			var pSrchLen:int =  pSearchStr.length;
			
			if (pStr > 0 ) {
				trace("Word Found");
				return true;
		  
			}  else {
				return false;
				trace("Word not Found");
			}
		   
		} 
		 
		private function InitializeVariables():void {
			
			alphabetList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "V", "W", "X", "Y"]
			vowelLIST1 = ["E", "A",  "I"]
			vowelLIST2 = ["O", "U"]
			specCharList = ["X", "Z", "Qu", "J"]
			
			charList = [[11, 12, 13, 14], [21, 22, 23, 24], [31, 32, 33, 34], [41, 42, 43, 44]]
			 
		}
		
		private function clickTest(e:Event):void {
			//trace("clicked");
		}
		
		
		private function displayBoxes():void {
		
			
			   //testMov =  new testClass() as MovieClip;
				//addChild(testMov);
				//testMov.movinsyd.addEventListener(MouseEvent.MOUSE_UP, clickTest);
		//
				objArr = [];
		
			   var xstart:int = 50;
			   var ystart:int = 150;
			   var xcntr:int = 0; 
			   
			   var prevyCoeff:int = 0;
			   
			  for (var i:Number = 0; i <= 15; i++) { 
				  var mv:MovieClip =  new boxClass() as MovieClip;
					
					addChild(mv);							
					
					
					// Gets Row Value
					var yCoeff:int = int( i / 4);
					 
						
					mv.x = xstart + (mv.width * xcntr)  - yCoeff * (mv.width)*4;
					
					// trace( "i:" + i +  "  xntr:" + xcntr + "  yCoeff:" + yCoeff + "  mvX:" + mv.x)
					 					
					mv.y = ystart + ( mv.width * yCoeff )  
					 
					xcntr++;	
						 
					prevyCoeff = yCoeff;		
					
					objArr.push(mv);					 
					mv.boxtext.text = chargenList[i] ;   						 
					mv.addEventListener(MouseEvent.MOUSE_UP, BoxPressed);
					mv.stop();
			  }
			  
			  
			  
		}
		
		private function RepopulateCharBoxes():void {
			
			 for (var i:Number = 0; i <= 15; i++) { 
				 objArr[i].boxtext.text = chargenList[i];  
			 }
		}
		
		private function displayCheckBox():void {
				txtbg =  new txtbgClass() as MovieClip;
			   txtbg.x = 360;
			   txtbg.y = 400;
			   
			   chkBtn_mov =  new chkBtnClass() as MovieClip;
				chkBtn_mov.x = 390;
			   chkBtn_mov.y = 125;
			   
			   addChild(txtbg);
			   addChild(chkBtn_mov);
			   
			   txtbg.stop();
			   chkBtn_mov.stop();
			   
			   chkBtn_mov.addEventListener(MouseEvent.MOUSE_OVER, hover);
			   chkBtn_mov.addEventListener(MouseEvent.MOUSE_UP, CheckButtonPressed);
			 chkBtn_mov.addEventListener(MouseEvent.MOUSE_OUT, checkOut);
		}
		
		private function hover(e:Event):void {
			e.currentTarget.gotoAndStop("_hi");			
		}
		
		private function checkOut(e:Event):void {
			e.currentTarget.gotoAndStop("_up");			
		}
		
		private function btnDown(e:Event):void {
			e.currentTarget.gotoAndStop("_down");			
		}
		
		
		private function CheckButtonPressed(e:Event):void {
			var tx:String = label.text;
			var res:Boolean;
			
			tx = tx.toLowerCase();
			
			// trace(tx);
			trace("Check Box Pressed");
			res = CheckWords(tx);
			
			//trace(res);
			
			//trace(CheckWords("apple"));
			
			if (tx.length < 3) {
				txtbg.boxtext.text = "Word should have 3 or more letters";
			
			}
			else{
			 
			if (valWordsArr.indexOf(tx) > -1) {
				txtbg.boxtext.text = "You already found this word";
			}else {
				if (res==true) {
				txtbg.boxtext.text = "Good!!!";
				valWordsArr.push(tx);
				
				var score:int = tx.length;
				mainScore = mainScore + score;
				
				scoreText.text = String(mainScore);
				 
				txtbg.disTxt.text = tx + "\n" + txtbg.disTxt.text;
			}else {
				txtbg.boxtext.text = "INVALID WORD!";
			}
			
			}
			}
			
			resetWords();
			
		}
		
		private function BoxPressed(e:Event):void {
			trace("boxPressed");
			//var pmc:Object = e.currentTarget;
			
			var mvNum:int = objArr.indexOf(e.currentTarget) + 1;
			
			if(prevHit==0 || verifyPress(mvNum)){
				trace(e.currentTarget.boxtext.text);
				trace(objArr.indexOf(e.currentTarget));
				label.appendText(e.currentTarget.boxtext.text);
				prevHit = mvNum;
				e.currentTarget.gotoAndStop(2);
				
			}else {
				resetWords();
				trace("Wala");
			}
			
			txtbg.boxtext.text = "";
			
			
		}
		
		private function resetWords():void {
			label.text = "";
			
			trace("reset");
			
			for (var i:int = 0; i < 16; i++) {
				var mc:MovieClip = objArr[i] as MovieClip;
				mc.gotoAndStop(1); 
				trace(objArr[i]);
				mc = null;
			}
			
			prevHit = 0;
		}
		
		private function verifyPress(_num:int):Boolean {
			
			
			var curHit:int = _num;
			
			//UNCHECKED
			
			var mc:MovieClip = objArr[_num - 1] as MovieClip;
			var cf:int = mc.currentFrame;
			
			
			if(cf==1){
				neighborArr = [];	
				
				setNeighbor(curHit);
				 
				//CHECK IF NEIGHBOR
				if (neighborArr.indexOf(prevHit)!= -1){
					trace("I AM A NEIGHBOR:");
					trace(neighborArr.indexOf(prevHit));
					trace("prevHit:" + prevHit);
					trace("neighborArr:" + neighborArr);
					return true
				}else {
					trace("I AM NOT A NEIGHBOR");	
					trace(neighborArr.indexOf(prevHit));
					trace("prevHit:" + prevHit);
					trace("neighborArr:" + neighborArr);
					return false
								
					 
				}
				
			}else if(cf==2){
			//CHECK
				//DO NOTHING	
				 
				return false
			}else{
			return false
			}
			
		}
		
		private function setNeighbor(_num:int):void {
			//5431
			
			var mv:MovieClip = objArr[_num - 1] as MovieClip;
			
			var xpos:Number = 1 + int((mv.x - 50) / 70);
			var ypos:Number = 1+ int((mv.y - 150) / 70);
			trace("coor:" + xpos +":" +ypos);	
			
			
			var tmArr:Array = [-1,1,-3,3,-4,4,-5,5];
			 
			
			if (xpos == 1) { // LEFT 
				 tmArr[0] = 0;
				 tmArr[3] = 0;
				 tmArr[6] = 0;
			}
			
			if (xpos == 4) { //RIGHT
				tmArr[1] = 0;
				tmArr[2] = 0;
				tmArr[7] = 0;
			}
			
			if (ypos == 1) { //TOP
				tmArr[2] = 0;
				tmArr[4] = 0;
				tmArr[6] = 0;
			}
			
			if (ypos == 4) { //DOWN
				tmArr[5] = 0;
				tmArr[3] = 0;
				tmArr[7] = 0;
			}
			
			
			for (var i:int = 0; i < 8; i++) {
				var pval:int = tmArr[i];
				if (pval != 0) {
					neighborArr.push(_num+pval)
				}
				trace("BAHAY: " + neighborArr);
				
			} 
	
		}
		
		private function displayTextBox():void {		
            label.autoSize = TextFieldAutoSize.LEFT;
            label.background = false;
            label.border = false;
			label.selectable = false;
			
            var format:TextFormat = new TextFormat();
            format.font = "Verdana";
            format.color = 0x000000;
            format.size = 20;
            format.underline = false;
	
            label.defaultTextFormat = format;
			label.text = "";
			label.x = 393;
			label.y = 410;
            addChild(label);
 
			var formatLite:TextFormat = new TextFormat();
            formatLite.font = "Verdana";
            formatLite.color = 0xFFFFFF;
			formatLite.size = 20;
            formatLite.underline = false;
			
			ScoreText1.autoSize = TextFieldAutoSize.LEFT;
            ScoreText1.background = false;
            ScoreText1.border = false;
			ScoreText1.selectable = false;
			
			ScoreText1.defaultTextFormat = formatLite;
			ScoreText1.text = "SCORE:";
			ScoreText1.x =15
			ScoreText1.y = 25;
            addChild(ScoreText1);
			
			scoreText.autoSize = TextFieldAutoSize.LEFT;
            scoreText.background = false;
            scoreText.border = false;
			scoreText.selectable = false;
			
			scoreText.defaultTextFormat = formatLite;
			scoreText.text = "0";
			scoreText.x = 100;
			scoreText.y = 25;
            addChild(scoreText);
			
			
			timeTxt.autoSize = TextFieldAutoSize.LEFT;
            timeTxt.background = false;
            timeTxt.border = false;
			timeTxt.selectable = false;
			
			// Change Text Color			
			format.color = 0xFF0000;
			format.size = 30;
			
			timeTxt.defaultTextFormat = format;
			timeTxt.text = "2:00";
			timeTxt.x = 375;
			timeTxt.y = 20;
			addChild(timeTxt);
		}
		
		private function starTimer():void {
			gameTimer.addEventListener("timer", timerHandler);
			gameTimer.addEventListener("timerComplete", timerCompleteHandler);
            gameTimer.start(); 
		}
		
		private function timerHandler(e:Event):void {
			var pNum:int;
			
			pNum = gameTimer.currentCount;
			
			var pDiff:int = 120 - pNum;
			
			var str:String = convertSecToMinutes(pDiff);
			
			timeTxt.text = String(str);
		}
		
		private function timerCompleteHandler(e:Event):void {
			 
	
		 gameMode = "replay";
		 
		//ShowStartMenu(true);
			

		trace("Time is up");
		
		ShowStartMenu(true);
	 
		ShowGameElements(false);
		
		}
		
		private function ResetGame():void {
			
			generateCharList();	
		RepopulateCharBoxes();
		gameTimer.reset();
		gameTimer.start();
		resetWords();
		valWordsArr = [];
		mainScore = 0;
		scoreText.text = "0";
		txtbg.boxtext.text = "";
		prevHit = 0;
			
		}
		
		private function convertSecToMinutes(_num:int):String {
			var pStr:String = "2:00";
		
			var min:int = int(_num / 60);
			var diff:int = int(_num % 60);
			var secStr:String = String(diff);
			
			if (diff < 10 ) {
				secStr = "0" + secStr;
			}
			
			pStr = String(min) + ":" + secStr;
			//
			//if ( _num < 60 ) {
				//pStr = "0:" + String(_num);
			//}else if(_num > 60 && _num < 120){
				//pStr = "1:" + String(_num-60);
			//}else {
				//pStr = "2:" + String(_num-120);
			//}
			
			return pStr;
		}
		
		
		
		private function textPress(e:Event):void {
			
			trace("pressed textbox");
			
		}
		
		private function generateCharList():void {
			var vList:Array = ["A", "E", "I", "O", "U"];
			var char:String;
			var vCnt:int = 0;
			
			chargenList = [];
			
			for (var i:uint = 0; i < 16; i++) {
				char = newRandomChar();
				
				trace("index of char:" + vList.indexOf(char));
				if (vList.indexOf(char) > -1 ) {
					vCnt++;					
				}  
				
				//LIMIT VOWELS TO 7
				if (vCnt > 7) {
					while (vList.indexOf(char)>-1) {
						char = newRandomChar();
					}
				}
				
				//CHECKS FOR Q,Z
				if (char == "Z" || char == "Qu"  || char == "X" || char == "J") {
					while (chargenList.indexOf(char)>-1) {
						char = newRandomChar();
					}
				} 
				
				 chargenList.push(char);
				
			}
			
			trace("Chargen:" + chargenList); 
			 			
		}
		
		private function newRandomChar():String {
			var pChar:String;
			var rnd:Number = Math.random() * 100;
			var rnd2:Number = Math.random() * 100;
			var num:uint;
			
			trace("RANDOM: " + rnd)
			//Check if prog chooses vowel or consonant
			
			
			if (rnd < 8 ) {  //VOWEL1
			pChar = "E";
					
			}else if (rnd > 7 && rnd <13) {
				num = uint(Math.random() * 2)
				pChar = vowelLIST1[num]	
			}	
			else if (rnd > 12 && rnd < 21) { //VOWEL2
				num = uint(Math.random() * 1)
				pChar = vowelLIST2[num]		
				
			}else if (rnd > 21 && rnd <40) { // Common Consonants 
				var commonConsList:Array = ["N", "R","D","T"];
				num = uint(Math.random() * 4)
				pChar = commonConsList[	num];
				
			}else if (rnd >39&& rnd < 99) { //Consonant
				num = uint(Math.random()*24)
				pChar = alphabetList[num]		
			}else if (rnd == 99) { // Z
				pChar = "Z";	
			}else if (rnd == 100) { // Qu			 
				pChar = "Qu";	
			}
			else { 
				pChar = "E";
			}
			 
			return pChar
		}
		 
		private var scoreLoader:URLLoader;
		private var onlineURL:String = "http://localhost/scramblords/php/submit.php"; //"http://localhost/scramblords/php/submit.php";
		
		private function getHiScores():void {
			
			var loader:URLLoader = new URLLoader();
            configureListeners(loader);

			var urlStr:String = onlineURL + "?enc=" + uName + "&encscor=" + String(mainScore);
            var request:URLRequest = new URLRequest(urlStr);
			 
            try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
            }

		}
				
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

		
		
        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
            trace("completeHandler: " + loader.data);
    
            var vars:URLVariables = new URLVariables(loader.data);
            trace("uCount " + vars.uCount);
			
			var uCount:int = int(vars.uCount);
			var uNameStr:String = vars.users;
			var uScoreStr:String = vars.scores;
			
			var uName_arr:Array = uNameStr.split("*");
			var uScore_arr:Array = uScoreStr.split("*");
			
			var scrtxt:String = "";
			
			for (var i:int = 0; i < uCount; i++ ){
				scrtxt = scrtxt + uName_arr[i] + " - " + uScore_arr[i] + "\n";
			}
			
			startBG.hiScore_mov.hiScore_txt.text = scrtxt;
			
        }

        private function openHandler(event:Event):void {
            trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }

		private function gotoSandMantis(e:Event):void {
			 var url:String = "http://www.sandmantis.com";
             var request:URLRequest = new URLRequest(url);
			 
            try {            
                navigateToURL(request);
            }
            catch (e:Error) {
                // handle error here
            }

		}
		
	}
	
}