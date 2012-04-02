package be.wellconsidered.othello.engine
{
	import be.wellconsidered.logging.Logger;
	import be.wellconsidered.othello.model.PlayerColours;
	import be.wellconsidered.othello.model.States;
	import be.wellconsidered.othello.model.TileData;
	
	import flash.events.EventDispatcher;

	public class Engine extends EventDispatcher
	{
		private var _arrCurrentLegalTurns:Array;
		private var _arrDirs:Array = [
												[-1, 	 0],
												[-1, 	-1],
												[ 0, 	-1],
												[ 1, 	-1],
												[ 1, 	 0],
												[ 1, 	 1],
												[ 0, 	 1],
												[-1, 	 1]
											];
		private var _arrSortAxisSym:Array = [
												[0, 	  0, 	 0, 	 0, 	 0],
												[0, 	 80, 	-49, 	16, 	 0],
												[0,	-49,	-80, 	48, 	32],
												[0,	 16, 	 48, 	64, 	64],
												[0,	  0, 	 32, 	64, 	 0],
											];
										
		private var _arrSort:Array = [];	
			
		private const WEIGHT_DIFF:String = "diff";						
		private const WEIGHT_MOB:String = "mob";						
		private const WEIGHT_POT_MOB:String = "pot_mob";						
		private const WEIGHT_CORNERS:String = "corners";						
		private const WEIGHT_DIAG_CORNERS:String = "diag_corners";						
		
		public function Engine(grid_size:int)
		{
			for(var i:int = 0; i < grid_size; i++)
			{
				_arrSort[i] = [];
				
				for(var j:int = 0; j < grid_size; j++)
					_arrSort[i][j] = 0;
			}
			
			for(var k:int = 0; k < grid_size / 2; k++)
			{
				for(var l:int = 0; l < grid_size / 2; l++)
				{
					_arrSort[k][l] = _arrSortAxisSym[k][l];
					_arrSort[9 - k][9 - l] = _arrSortAxisSym[k][l];
					_arrSort[9 - k][l] = _arrSortAxisSym[k][l];
					_arrSort[k][9 - l] = _arrSortAxisSym[k][l];
				}
			}
		}
		
		public function legalActionPossible(tiles:Array, iColourTurn:int):Array
		{			
			var iValue:int;
			var l:int;
			var iFlipValue:int;
			var arrLegalTurns:Array = [];
			
			for(var i:int = 1; i < tiles.length - 1; i++)
			{
				var arrTiles:Array = tiles[i] as Array;
				
				for(var j:int = 1; j < arrTiles.length - 1; j++)
				{
					var td:TileData = tiles[i][j] as TileData;
					
					iFlipValue = 0;
					
					if(td.state == States.ZET)
					{
						for(var k:int = 0; k < _arrDirs.length; k++)
						{
							var arrStp:Array = _arrDirs[k] as Array;
							
							l = 1;
							iValue = 0;
							
							while(true)
							{
								var ix:int = td.rij + _arrDirs[k][0] * l;
								var iy:int = td.kol + _arrDirs[k][1] * l;								
								
								var tdTest:TileData = tiles[ix][iy] as TileData;
								
								if(tdTest.state != States.ZET - iColourTurn)
								{
									if(l == 1)
										break; 
									else
									{
										if(tdTest.state == iColourTurn)
											iValue = l - 1;
										
										break;
									}
								}
								else
									l++;
							}
							
							iFlipValue += iValue;
						}
						
						if(iFlipValue > 0)
						{
							arrLegalTurns.push(td);	
						}
					}
				}
			}
			
			_arrCurrentLegalTurns = arrLegalTurns;
			
			// Logger.log("Legal Actions Possible (" + arrLegalTurns.length + ")");
			
			return arrLegalTurns;
		}
		
		public function legalAction(legalturns:Array, td:TileData):Boolean
		{
			for(var i:int = 0; i < legalturns.length; i++)
			{
				var tdLegal:TileData = legalturns[i] as TileData;
				
				if(tdLegal == td)
					return true;
			}	
			
			return false;
		}
		
		public function flipTiles(tiles:Array, tdTurn:TileData):void
		{
			// Logger.log("Flip Tiles");
			
			var iTeller:int;
			var l:int;
			
			for(var k:int = 0; k < _arrDirs.length; k++)
			{
				var arrStp:Array = _arrDirs[k] as Array;
				
				iTeller = 0;
				l = 1;
				
				while(true)
				{
					var ix:int = tdTurn.rij + _arrDirs[k][0] * l;
					var iy:int = tdTurn.kol + _arrDirs[k][1] * l;								
					
					var tdTest:TileData = tiles[ix][iy] as TileData;
					
					if(tdTest.state == States.ZET - tdTurn.state)
					{
						iTeller++;
						l++;
					}	
					else
					{
						if(l == 1)
						{
							if(tdTest.state == States.LEEG)
								tdTest.state = States.ZET; // OK
							else
								break;
						}
						else
						{
							if(tdTest.state == tdTurn.state) // EINDE VAN REEKS
							{
								for(var m:int = 0; m <= iTeller; m++)
								{
									var iv:int = tdTurn.rij + _arrDirs[k][0] * m;
									var iw:int = tdTurn.kol + _arrDirs[k][1] * m;
									
									var tdFlip:TileData = tiles[iv][iw] as TileData;
									
									tdFlip.state = tdTurn.state;
								}
								
								break;
							}
							else
								break;
						}
					}
				}
			}
		}
		
		public function isEnd(teller:int, passPlayer1:Boolean, passPlayer2:Boolean):Boolean
		{
			// Logger.log("isEnd (teller: " + teller + ", pP1: " + passPlayer1 + ", pP2: " + passPlayer2 + ")");
			
			if(teller == 60)
				return true;
			else if(passPlayer1 && passPlayer2)
				return true;
			else
				return false;
		}
		
		public function getScore(tiles:Array):int
		{
			var iScorePlayer1:int = -32;
			
			for(var i:int = 0; i < tiles.length; i++)
			{
				var arrTiles:Array = tiles[i] as Array;
				
				for(var j:int = 0; j < arrTiles.length; j++)
				{
					var td:TileData = tiles[i][j] as TileData;
				
					if(td.state == PlayerColours.PLAYER1)
						iScorePlayer1++;
				}
			}
			
			// Logger.log("Get Score (" + iScorePlayer1 + ")");
			
			return iScorePlayer1;
		}
		
		//***************************************************************************************************************//
		
		private var _iSearchDepthOptimalTurn:int;
		private var _iBaseTeller:int;
		
		public function getOptimalTurn(tiles:Array, spelTeller:int, searchTeller:int):TileData
		{			
			var arrLegalTurns:Array = copyTurnsArray(_arrCurrentLegalTurns);
			var arrValues:Array = [];
			var iDepthOptimalTurn:int = 0;
			
			_iSearchDepthOptimalTurn = searchTeller;
			_iBaseTeller = spelTeller;
			
			// Logger.isVerbose = false;
			
			for(var i:int = 0; i < arrLegalTurns.length; i++)
			{
				var tdLegal:TileData = arrLegalTurns[i] as TileData;
					
				iDepthOptimalTurn = 1;
				
				if(arrLegalTurns.length <= 2 || isCornerTurn(tdLegal))
					_iSearchDepthOptimalTurn = searchTeller + 1;
				else
					_iSearchDepthOptimalTurn = searchTeller;
				
				var arrTilesCopy:Array = copyTilesArray(tiles);
				var tdCopy:TileData = copyTile(tdLegal);
				
				tdCopy.state = PlayerColours.PLAYER1;
				
				flipTiles(arrTilesCopy, tdCopy);
				
				arrValues.push(getMinValue(arrTilesCopy, iDepthOptimalTurn, arrLegalTurns.length, int.MIN_VALUE, int.MAX_VALUE, false, false));
			}
			
			var iMaxValue:int = arrValues[0];
			var iMaxValueIndex:int = 0;
			
			for(var j:int = 0; j < arrValues.length; j++)
			{
				if(arrValues[j] > iMaxValue)
				{
					iMaxValue = arrValues[j];
					iMaxValueIndex = j;
				}
			}
			
			Logger.isVerbose = true;
			
			var tdChosen:TileData = arrLegalTurns[iMaxValueIndex] as TileData;
			
			Logger.log("Optimal Turn Max Value: " + iMaxValue + " (" + arrValues + ")");
			
			return tdChosen;
		}
		
		/**
		 * getMaxValue
		 */
		private function getMaxValue(tiles:Array, diepte:int, legalTurns:int, alpha:int, beta:int, passPlayer1:Boolean, passPlayer2:Boolean):int
		{
			if(isEnd(_iBaseTeller + diepte, passPlayer1, passPlayer2))
				return getScore(tiles);
			
			if(diepte >= _iSearchDepthOptimalTurn)
				return evaluateTurn(tiles, legalTurns, PlayerColours.PLAYER2);
			
			diepte++; 
				
			var arrLegalTurns:Array = legalActionPossible(tiles, PlayerColours.PLAYER1);
			
			passPlayer1 = arrLegalTurns.length == 0 ? true : false;
			
			sortLegalTurns(arrLegalTurns);
			
			var iValue:int = passPlayer1 ? beta : int.MIN_VALUE;
			
			for(var i:int = 0; i < arrLegalTurns.length; i++)
			{
				var arrTilesCopy:Array = copyTilesArray(tiles);
				var tdTurn:TileData = copyTile(arrLegalTurns[i]);
				
				tdTurn.state = PlayerColours.PLAYER1;
				
				flipTiles(arrTilesCopy, tdTurn);
				
				iValue = Math.max(iValue, getMinValue(arrTilesCopy, diepte, arrLegalTurns.length, alpha, beta, passPlayer1, passPlayer2));
				
				if(iValue >= beta)
					break;
					
				alpha = Math.max(alpha, iValue);
			}
			
			return iValue;
		}
		
		/**
		 * getMinValue
		 */
		private function getMinValue(tiles:Array, diepte:int, legalTurns:int, alpha:int, beta:int, passPlayer1:Boolean, passPlayer2:Boolean):int
		{
			if(isEnd(_iBaseTeller + diepte, passPlayer1, passPlayer2))
				return getScore(tiles);
			
			if(diepte >= _iSearchDepthOptimalTurn)
				return evaluateTurn(tiles, legalTurns, PlayerColours.PLAYER1);
				
			diepte++;
				
			var arrLegalTurns:Array = legalActionPossible(tiles, PlayerColours.PLAYER2);
			
			passPlayer2 = arrLegalTurns.length == 0 ? true : false;
				
			sortLegalTurns(arrLegalTurns, -1);
			
			var iValue:int = passPlayer2 ? alpha : int.MAX_VALUE;
			
			for(var i:int = 0; i < arrLegalTurns.length; i++)
			{
				var arrTilesCopy:Array = copyTilesArray(tiles);
				var tdTurn:TileData = copyTile(arrLegalTurns[i] as TileData);
				
				tdTurn.state = PlayerColours.PLAYER2;
				
				flipTiles(arrTilesCopy, tdTurn);
				
				iValue = Math.min(iValue, getMaxValue(arrTilesCopy, diepte, arrLegalTurns.length, alpha, beta, passPlayer1, passPlayer2));
				
				if(iValue <= alpha)
					break;
					
				beta = Math.min(beta, iValue);
			}
			
			return iValue;
		}
		
		private function isCornerTurn(td:TileData):Boolean
		{
			return false;
		}
		
		private function sortLegalTurns(arrTurns:Array, sortDirection:int = 1):void
		{
			arrTurns.sort(compareSortValues);
			
			function compareSortValues(a:TileData, b:TileData):Boolean
			{
				return _arrSort[a.rij][a.kol] * sortDirection > _arrSort[b.rij][b.kol] * sortDirection; 
			}
		}
		
		private function evaluateTurn(tiles:Array, legalTurns:int, pColour:Number):int
		{		
			var iValue:int = 0;

			iValue += getMobDiff(tiles, legalTurns, pColour) * getWeight(WEIGHT_MOB); // MOBILITY			
			iValue += getDiffInTurns(tiles) * getWeight(WEIGHT_DIFF); // DIFF TILES
			iValue += getPotMobDiff(tiles) * getWeight(WEIGHT_POT_MOB); // POTENTIOL MOBILITY
			iValue += getCornerDiff(tiles) * getWeight(WEIGHT_CORNERS); // CORNERS
			iValue += getDiagDiff(tiles) * getWeight(WEIGHT_DIAG_CORNERS); // DIAGONAL CORNERS
			
			// Logger.log("Evaluate Turn (" + iValue + ")");
			
			return iValue;
		}
		
		private function getDiagDiff(tiles:Array):int
		{
			var iDiagDiffScore:int = 0;
			
			for(var i:int = 2; i < tiles.length; i += 5)
			{
				var arrTiles:Array = tiles[i] as Array;
				
				for(var j:int = 2; j < arrTiles.length; j += 5)
				{
					var td:TileData = tiles[i][j] as TileData;
					
					if(td.state == PlayerColours.PLAYER1)
						iDiagDiffScore++;
					else if(td.state == PlayerColours.PLAYER2)
						iDiagDiffScore--;
				}
			}
			
			// Logger.log("getDiagDiff " + iDiagDiffScore);
			
			return iDiagDiffScore;
		}
		
		private function getCornerDiff(tiles:Array):int
		{
			var iCornerDiffScore:int = 0;
			
			for(var i:int = 1; i < tiles.length; i += 7)
			{
				var arrTiles:Array = tiles[i] as Array;
				
				for(var j:int = 1; j < arrTiles.length; j += 7)
				{
					var td:TileData = tiles[i][j] as TileData;
					
					if(td.state == PlayerColours.PLAYER1)
						iCornerDiffScore++;
					else if(td.state == PlayerColours.PLAYER2)
						iCornerDiffScore--;
				}
			}
			
			// Logger.log("getCornerDiff " + iCornerDiffScore);
			
			return iCornerDiffScore;
		}
		
		private function getMobDiff(tiles:Array, legalTurns:int, pColour:int):int
		{
			var iLegalTurnsOpponent:int = legalActionPossible(tiles, States.ZET - pColour).length;
			var iMobDiff:int = legalTurns - iLegalTurnsOpponent;
			
			iMobDiff = iMobDiff * (pColour == PlayerColours.PLAYER2 ? -1 : 1)
			
			// Logger.log("getMobDiff " + iMobDiff);
			
			return iMobDiff;
		}
		
		private function getPotMobDiff(tiles:Array):int
		{
			var iPotMobDiffScore:int = 0;
			
			for(var i:int = 0; i < tiles.length; i++)
			{
				var arrTiles:Array = tiles[i] as Array;
				
				for(var j:int = 0; j < arrTiles.length; j++)
				{
					var td:TileData = tiles[i][j] as TileData;
					
					if(td.state == States.ZET)
					{
						for(var k:int = 0; k < _arrDirs.length; k++)
						{
							var arrStp:Array = _arrDirs[k] as Array;
							
							var ix:int = td.rij + _arrDirs[k][0];
							var iy:int = td.kol + _arrDirs[k][1];								
								
							var tdTest:TileData = tiles[ix][iy] as TileData;
								
							if(tdTest.state == PlayerColours.PLAYER1)
								iPotMobDiffScore--;
							else if(tdTest.state == PlayerColours.PLAYER2)
								iPotMobDiffScore++;
						}
					}
				}
			}
			
			// Logger.log("getPotMobDiff " + iPotMobDiffScore);
			
			return iPotMobDiffScore;
		}
		
		private function getDiffInTurns(tiles:Array):int
		{
			var iDiffScore:int;
			
			for(var i:int = 0; i < tiles.length; i++)
			{
				var arrTiles:Array = tiles[i] as Array;
				
				for(var j:int = 0; j < arrTiles.length; j++)
				{
					var td:TileData = tiles[i][j] as TileData;
				
					if(td.state == PlayerColours.PLAYER1)
						iDiffScore++;
					else if(td.state == States.ZET - PlayerColours.PLAYER1)
						iDiffScore--;
				}
			}
			
			// Logger.log("getDiffInTurns " + iDiffScore);
			
			return iDiffScore;
		}
		
		private function getWeight(type:String):int
		{
			switch(type)
			{
				case WEIGHT_MOB:
				
					if(_iBaseTeller > 0 && _iBaseTeller <= 20)
						return 6;
					else if(_iBaseTeller > 20 && _iBaseTeller <= 50)
						return 3;
				
					break;
					
				case WEIGHT_DIFF:
				
					if(_iBaseTeller > 0 && _iBaseTeller <= 20)
						return 0;
					else if(_iBaseTeller > 20 && _iBaseTeller <= 50)
						return 3;
						
					break;
					
				case WEIGHT_POT_MOB:
				
					if(_iBaseTeller > 0 && _iBaseTeller <= 20)
						return 4;
					else if(_iBaseTeller > 20 && _iBaseTeller <= 50)
						return 2;
						
					break;
					
				case WEIGHT_CORNERS:
				
					if(_iBaseTeller > 0 && _iBaseTeller <= 20)
						return 35;
					else if(_iBaseTeller > 20 && _iBaseTeller <= 50)
						return 35;
						
					break;
					
				case WEIGHT_DIAG_CORNERS:
				
					if(_iBaseTeller > 0 && _iBaseTeller <= 20)
						return -8;
					else if(_iBaseTeller > 20 && _iBaseTeller <= 50)
						return -8;
						
					break;
			}
			
			return 1;
		}
		
		private function copyTilesArray(tiles:Array):Array
		{
			var arrCopied:Array = [];
			
			for(var i:int = 0; i < tiles.length; i++)
			{
				var arrTiles:Array = tiles[i] as Array;
				
				arrCopied[i] = copyTurnsArray(arrTiles);			
			}
			
			return arrCopied;
		}
		
		private function copyTurnsArray(turns:Array):Array
		{
			var arrCopied:Array = [];
			
			for(var i:int = 0; i < turns.length; i++)
			{
				var td:TileData = turns[i] as TileData;
				
				arrCopied[i] = copyTile(td);
			}
			
			return arrCopied;
			
			// return turns.concat();
		}
		
		private function copyTile(td:TileData):TileData
		{
			var tdNew:TileData = new TileData(td.rij, td.kol);
				
			tdNew.state = td.state;
			
			return tdNew;
		}
		
		//***************************************************************************************************************//
		
		public function get currentLegalTurns():Array
		{
			return _arrCurrentLegalTurns;
		}
	}
}