//+------------------------------------------------------------------+
//|                 EA31337 - multi-strategy advanced trading robot. |
//|                            Copyright 2016, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/*
    This file is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// Properties.
#property strict

//+------------------------------------------------------------------+
//| Declaration of constants
//+------------------------------------------------------------------+

#ifdef __MQL5__
#define DOUBLE_VALUE 0
#define FLOAT_VALUE 1
#define LONG_VALUE INT_VALUE
// --
#define CHART_BAR 0
#define CHART_CANDLE 1
// --
#define MODE_ASCEND 0
#define MODE_DESCEND 1
// --
#define MODE_LOW 1
#define MODE_HIGH 2
#define MODE_TIME 5
#define MODE_BID 9
#define MODE_ASK 10
#define MODE_POINT 11
#define MODE_DIGITS 12
#define MODE_SPREAD 13
#define MODE_STOPLEVEL 14
#define MODE_LOTSIZE 15
#define MODE_TICKVALUE 16
#define MODE_TICKSIZE 17
#define MODE_SWAPLONG 18
#define MODE_SWAPSHORT 19
#define MODE_STARTING 20
#define MODE_EXPIRATION 21
#define MODE_TRADEALLOWED 22
#define MODE_MINLOT 23
#define MODE_LOTSTEP 24
#define MODE_MAXLOT 25
#define MODE_SWAPTYPE 26
#define MODE_PROFITCALCMODE 27
#define MODE_MARGINCALCMODE 28
#define MODE_MARGININIT 29
#define MODE_MARGINMAINTENANCE 30
#define MODE_MARGINHEDGED 31
#define MODE_MARGINREQUIRED 32
#define MODE_FREEZELEVEL 33
#endif

// Some of standard MQL4 constants are absent in MQL5, therefore they should be declared as below.
#define OP_BUY 0           // Buy
#define OP_SELL 1          // Sell
#define OP_BUYLIMIT 2      // Pending order of BUY LIMIT type
#define OP_SELLLIMIT 3     // Pending order of SELL LIMIT type
#define OP_BUYSTOP 4       // Pending order of BUY STOP type
#define OP_SELLSTOP 5      // Pending order of SELL STOP type
//---
#define MODE_OPEN 0
#define MODE_CLOSE 3
#define MODE_VOLUME 4
#define MODE_REAL_VOLUME 5
#define MODE_TRADES 0
#define MODE_HISTORY 1
#define SELECT_BY_POS 0
#define SELECT_BY_TICKET 1
//---
#define DOUBLE_VALUE 0
#define FLOAT_VALUE 1
#define LONG_VALUE INT_VALUE
//---
#define CHART_BAR 0
#define CHART_CANDLE 1
//---
#define MODE_ASCEND 0
#define MODE_DESCEND 1
//---
#define MODE_LOW 1
#define MODE_HIGH 2
#define MODE_TIME 5
#define MODE_BID 9
#define MODE_ASK 10
#define MODE_POINT 11
#define MODE_DIGITS 12
#define MODE_SPREAD 13
#define MODE_STOPLEVEL 14
#define MODE_LOTSIZE 15
#define MODE_TICKVALUE 16
#define MODE_TICKSIZE 17
#define MODE_SWAPLONG 18
#define MODE_SWAPSHORT 19
#define MODE_STARTING 20
#define MODE_EXPIRATION 21
#define MODE_TRADEALLOWED 22
#define MODE_MINLOT 23
#define MODE_LOTSTEP 24
#define MODE_MAXLOT 25
#define MODE_SWAPTYPE 26
#define MODE_PROFITCALCMODE 27
#define MODE_MARGINCALCMODE 28
#define MODE_MARGININIT 29
#define MODE_MARGINMAINTENANCE 30
#define MODE_MARGINHEDGED 31
#define MODE_MARGINREQUIRED 32
#define MODE_FREEZELEVEL 33
//---
#define EMPTY -1

//+------------------------------------------------------------------+
//| Chart Periods
//+------------------------------------------------------------------+

/*
 * Function to convert MQL4 time periods.
 * As in MQL5 chart period constants changed, and some new time periods (M2, M3, M4, M6, M10, M12, H2, H3, H6, H8, H12) were added.
 *
 * It should be noted, that in MQL5 the numerical values of chart timeframe constants (from H1) are not equal to the number of minutes of a bar
 * (for example, in MQL5, the numerical value of constant  PERIOD_H1=16385, but in MQL4 PERIOD_H1=60).
 * You should take it into account when converting to MQL5, if numerical values of MQL4 constants are used in MQL4 programs.
 * To determine the number of minutes of the specified time period of the chart, divide the value, returned by function PeriodSeconds by 60.
 *
 * See: https://www.mql5.com/en/articles/81
 */
ENUM_TIMEFRAMES TFMigrate(int tf) {
  switch(tf) {
    case 0: return(PERIOD_CURRENT);
    case 1: return(PERIOD_M1);
    case 5: return(PERIOD_M5);
    case 15: return(PERIOD_M15);
    case 30: return(PERIOD_M30);
    case 60: return(PERIOD_H1);
    case 240: return(PERIOD_H4);
    case 1440: return(PERIOD_D1);
    case 10080: return(PERIOD_W1);
    case 43200: return(PERIOD_MN1);
    case 2: return(PERIOD_M2);
    case 3: return(PERIOD_M3);
    case 4: return(PERIOD_M4);
    case 6: return(PERIOD_M6);
    case 10: return(PERIOD_M10);
    case 12: return(PERIOD_M12);
    case 16385: return(PERIOD_H1);
    case 16386: return(PERIOD_H2);
    case 16387: return(PERIOD_H3);
    case 16388: return(PERIOD_H4);
    case 16390: return(PERIOD_H6);
    case 16392: return(PERIOD_H8);
    case 16396: return(PERIOD_H12);
    case 16408: return(PERIOD_D1);
    case 32769: return(PERIOD_W1);
    case 49153: return(PERIOD_MN1);
    default: return(PERIOD_CURRENT);
  }
}

//+------------------------------------------------------------------+
//| Technical Indicators
//+------------------------------------------------------------------+

ENUM_MA_METHOD MethodMigrate (int method) {
  switch(method) {
    case 0: return(MODE_SMA);
    case 1: return(MODE_EMA);
    case 2: return(MODE_SMMA);
    case 3: return(MODE_LWMA);
    default: return(MODE_SMA);
  }
}

ENUM_APPLIED_PRICE PriceMigrate (int price) {
  switch (price) {
    case  1: return (PRICE_CLOSE);
    case  2: return (PRICE_OPEN);
    case  3: return (PRICE_HIGH);
    case  4: return (PRICE_LOW);
    case  5: return (PRICE_MEDIAN);
    case  6: return (PRICE_TYPICAL);
    case  7: return (PRICE_WEIGHTED);
    default: return (PRICE_CLOSE);
  }
}

ENUM_STO_PRICE StoFieldMigrate (int field) {
  switch (field) {
    case  0: return (STO_LOWHIGH);
    case  1: return (STO_CLOSECLOSE);
    default: return (STO_LOWHIGH);
  }
}

//+------------------------------------------------------------------+
enum ALLIGATOR_MODE  { MODE_GATORJAW=1,   MODE_GATORTEETH, MODE_GATORLIPS };
enum ADX_MODE        { MODE_MAIN,         MODE_PLUSDI, MODE_MINUSDI };
enum UP_LOW_MODE     { MODE_BASE,         MODE_UPPER,      MODE_LOWER };
enum ICHIMOKU_MODE   { MODE_TENKANSEN=1,  MODE_KIJUNSEN, MODE_SENKOUSPANA, MODE_SENKOUSPANB, MODE_CHINKOUSPAN };
enum MAIN_SIGNAL_MODE{ MODE_MAIN,         MODE_SIGNAL };

/*
 * MQL4 wrapper to work in MQL5.
 */
class MQL4 {

  public:

    /**
     * Returns text string with the specified numerical value converted into a specified precision format.
     *
     * @see http://docs.mql4.com/convert/doubletostr
     */
    string  DoubleToStr (
        double  value,     // value
        int     digits     // precision
        ) {
      return DoubleToString (value, digits);

      // Overriding DoubleToStr function.
#define DoubleToStr DoubleToStrMQL4
    }

    /**
     * Returns the string copy with changed character in the specified position.
     *
     * @see https://www.mql5.com/en/articles/81
     */
    string StringSetChar (string text, int pos, int value) {
      string copy = text;

      StringSetCharacter (copy, pos, (ushort)value);

      return copy;
    }

    /**
     * Returns Open price value for the bar of specified symbol with timeframe and shift.
     *
     * @see http://docs.mql4.com/series/iopen
     */
    double iOpen (
        string           symbol,          // symbol
        int              tf,              // timeframe
        int              index            // shift
        ) {
      if (index < 0)
        return -1;

      double Arr[];

      ENUM_TIMEFRAMES timeframe = TFMigrate (tf);

      if (CopyOpen (symbol, timeframe, index, 1, Arr) > 0)
        return Arr[0];
      else
        return -1;
    }

    /**
     * Returns Close price value for the bar of specified symbol with timeframe and shift.
     *
     * @see http://docs.mql4.com/series/iclose
     */
    double iClose (
        string           symbol,          // symbol
        int              tf,              // timeframe
        int              index            // shift
        ) {
      if(index < 0)
        return -1;

      double Arr[];

      ENUM_TIMEFRAMES timeframe = TFMigrate (tf);

      if (CopyClose (symbol, timeframe, index, 1, Arr) > 0)
        return Arr[0];
      else
        return -1;
    }

    /**
     * Refreshing of data in pre-defined variables and series arrays.
     *
     * @see http://docs.mql4.com/series/refreshrates
     */
    bool RefreshRates () {
      return true;
    }

    /**
     * The latest known seller's price (ask price) for the current symbol.
     * The RefreshRates() function must be used to update.
     *
     * @see http://docs.mql4.com/predefined/ask
     */
    double Ask () {
      MqlTick last_tick;

      SymbolInfoTick(_Symbol,last_tick);

      return last_tick.ask;

      // Overriding Ask variable to become a function call.
#define Ask AskMT4()
    }

    /**
     * The latest known buyer's price (offer price, bid price) of the current symbol.
     * The RefreshRates() function must be used to update.
     *
     * @see http://docs.mql4.com/predefined/bid
     */
    double Bid () {
      MqlTick last_tick;

      SymbolInfoTick(_Symbol,last_tick);

      return last_tick.bid;

      // Overriding Bid variable to become a function call.
#define Bid BidMT4()

    }

    double CopyBufferMQL4 (int handle, int index, int shift) {
      double buf[];
      switch (index) {
        case 0: if (CopyBuffer(handle, 0,shift, 1, buf) > 0) return (buf[0]); break;
        case 1: if (CopyBuffer(handle, 1,shift, 1, buf) > 0) return (buf[0]); break;
        case 2: if (CopyBuffer(handle, 2,shift, 1, buf) > 0) return (buf[0]); break;
        case 3: if (CopyBuffer(handle, 3,shift, 1, buf) > 0) return (buf[0]); break;
        case 4: if (CopyBuffer(handle, 4,shift, 1, buf) > 0) return (buf[0]); break;
        default: break;
      }
      return(EMPTY_VALUE);
    }

    /**
     * Calculates the Money Flow Index indicator and returns its value.
     *
     * @see http://docs.mql4.com/indicators/imfi
     */
    double iMFI(string symbol,
        int tf,
        int period,
        int shift) {
      ENUM_TIMEFRAMES timeframe = TFMigrate (tf);

      int handle = (int) iMFI (symbol, timeframe, period, VOLUME_TICK);

      if (handle < 0)
      {
        Print ("The iMFI object is not created: Error", GetLastError ());
        return -1;
      }
      else {
        return CopyBuffer(handle, 0, shift);
      }

      // Overriding iMFI function.
#define iMFI iMFIMQL4
    }

    /**
     * Calculates the  Larry Williams' Percent Range and returns its value.
     *
     * @see http://docs.mql4.com/indicators/iwpr
     */
    double iWPR(string symbol,
        int tf,
        int period,
        int shift) {
      ENUM_TIMEFRAMES timeframe = TFMigrate (tf);

      int handle = iWPR (symbol, timeframe, period);

      if (handle < 0) {
        Print ("The iWPR object is not created: Error", GetLastError ());
        return -1;
      }
      else
        return CopyBuffer(handle, 0, shift);

      // Overriding iMPR function.
#define iWPR iWPRMQL4
    }

    /**
     * Calculates the Stochastic Oscillator and returns its value.
     *
     * @see http://docs.mql4.com/indicators/istochastic
     */
    double iStochastic(string symbol,
        int tf,
        int Kperiod,
        int Dperiod,
        int slowing,
        int method,
        int field,
        int mode,
        int shift) {
      ENUM_TIMEFRAMES timeframe   = TFMigrate (tf);
      ENUM_MA_METHOD  ma_method   = MethodMigrate (method);
      ENUM_STO_PRICE  price_field = StoFieldMigrate (field);

      int handle = iStochastic (symbol, timeframe, Kperiod, Dperiod, slowing, ma_method, price_field);

      if (handle < 0) {
        Print ("The iStochastic object is not created: Error", GetLastError ());
        return -1;
      } else {
        return CopyBuffer(handle, mode, shift);
      }
    }


    /**
     * Calculates the Standard Deviation indicator and returns its value.
     *
     * @see http://docs.mql4.com/indicators/istddev
     */
    double iStdDev (string symbol,
        int tf,
        int ma_period,
        int ma_shift,
        int method,
        int price,
        int shift) {
      ENUM_TIMEFRAMES    timeframe     = TFMigrate (tf);
      ENUM_MA_METHOD     ma_method     = MethodMigrate (method);
      ENUM_APPLIED_PRICE applied_price = PriceMigrate (price);

      int handle = iStdDev (symbol, timeframe, ma_period, ma_shift, ma_method, applied_price);

      if (handle < 0) {
        Print ("The iStdDev object is not created: Error", GetLastError ());
        return -1;
      }
      else {
        return CopyBuffer(handle, 0, shift);
      }
    }

    /**
     * Search for a bar by its time. The function returns the index of the bar which covers the specified time.
     *
     * @see http://docs.mql4.com/series/ibarshift
     */
    int iBarShift (string symbol,
        int tf,
        datetime time,
        bool exact = false) {
      if (time < 0) {
        return -1;
      }

      ENUM_TIMEFRAMES timeframe = TFMigrate (tf);

      datetime Arr[], time1;

      CopyTime (symbol, timeframe, 0, 1, Arr);

      time1 = Arr[0];

      if (CopyTime (symbol, timeframe, time, time1, Arr) > 0) {
        if (ArraySize (Arr) > 2)
          return ArraySize (Arr) - 1;

        if (time < time1)
          return 1;
        else
          return 0;
      }
      else {
        return -1;
      }
    }


	double MarketInfo(string symbol,
												int type) {
		switch(type) {
			case MODE_LOW:
				return(SymbolInfoDouble(symbol,SYMBOL_LASTLOW));
			case MODE_HIGH:
				return(SymbolInfoDouble(symbol,SYMBOL_LASTHIGH));
			case MODE_TIME:
				return(SymbolInfoInteger(symbol,SYMBOL_TIME));
			case MODE_BID:
				//return(Bid);
			case MODE_ASK:
				//return(Ask);
			case MODE_POINT:
				return(SymbolInfoDouble(symbol,SYMBOL_POINT));
			case MODE_DIGITS:
				return(SymbolInfoInteger(symbol,SYMBOL_DIGITS));
			case MODE_SPREAD:
				return(SymbolInfoInteger(symbol,SYMBOL_SPREAD));
			case MODE_STOPLEVEL:
				return(SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL));
			case MODE_LOTSIZE:
				return(SymbolInfoDouble(symbol,SYMBOL_TRADE_CONTRACT_SIZE));
			case MODE_TICKVALUE:
				return(SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE));
			case MODE_TICKSIZE:
				return(SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE));
			case MODE_SWAPLONG:
				return(SymbolInfoDouble(symbol,SYMBOL_SWAP_LONG));
			case MODE_SWAPSHORT:
				return(SymbolInfoDouble(symbol,SYMBOL_SWAP_SHORT));
			case MODE_STARTING:
				return(0);
			case MODE_EXPIRATION:
				return(0);
			case MODE_TRADEALLOWED:
				return(0);
			case MODE_MINLOT:
				return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN));
			case MODE_LOTSTEP:
				return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP));
			case MODE_MAXLOT:
				return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX));
			case MODE_SWAPTYPE:
				return(SymbolInfoInteger(symbol,SYMBOL_SWAP_MODE));
			case MODE_PROFITCALCMODE:
				return(SymbolInfoInteger(symbol,SYMBOL_TRADE_CALC_MODE));
			case MODE_MARGINCALCMODE:
				return(0);
			case MODE_MARGININIT:
				return(0);
			case MODE_MARGINMAINTENANCE:
				return(0);
			case MODE_MARGINHEDGED:
				return(0);
			case MODE_MARGINREQUIRED:
				return(0);
			case MODE_FREEZELEVEL:
				return(SymbolInfoInteger(symbol,SYMBOL_TRADE_FREEZE_LEVEL));

			default: return(0);
		}
		return(0);
	}

	double AccountBalance() {
		return AccountInfoDouble(ACCOUNT_BALANCE);
	}
	double AccountCredit() {
		return AccountInfoDouble(ACCOUNT_CREDIT);
	}

	/*
	* Returns the brokerage company name where the current account was registered.
	*/
	string GetAccountCompany() {
		AccountInfoString(ACCOUNT_COMPANY);
	}

	string AccountCurrency() {
		return AccountInfoString(ACCOUNT_CURRENCY);
	}

	double AccountEquity() {
		AccountInfoDouble(ACCOUNT_EQUITY);
	}

	double AccountFreeMargin() {
		AccountInfoDouble(ACCOUNT_FREEMARGIN);
	}

	/*
	* Returns the brokerage company name where the current account was registered.
	*/
	string AccountLeverage() {
		return AccountInfoInteger(ACCOUNT_LEVERAGE);
	}

	double AccountMargin() {
		return AccountInfoDouble(ACCOUNT_MARGIN);
	}

	string AccountName() {
		return AccountInfoString(ACCOUNT_NAME);
	}

	int AccountNumber() {
		return AccountInfoInteger(ACCOUNT_LOGIN);
	}

	double AccountProfit() {
		return AccountInfoDouble(ACCOUNT_PROFIT);
	}

	string AccountServer() {
		return AccountInfoString(ACCOUNT_SERVER);
	}
	double AccountStopoutLevel() {
		return AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);
	}
	int AccountStopoutMode() {
		return AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);
	}

	bool IsDemo() {
		ENUM_ACCOUNT_TRADE_MODE tradeMode = (ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
		if(tradeMode == ACCOUNT_TRADE_MODE_DEMO) return (true);
		// tradeMode is ACCOUNT_TRADE_MODE_CONTEST or ACCOUNT_TRADE_MODE_REAL
		return(false);
	}

	bool IsDllsAllowed() {
		return (bool)MQL5InfoInteger(MQL5_DLLS_ALLOWED;
	}

	bool IsLibrariesAllowed() {
		return (bool)MQL5InfoInteger(MQL5_DLLS_ALLOWED);
	}

	bool IsOptimization() {
		return (bool)MQL5InfoInteger(MQL5_OPTIMIZATION);
	}

	bool IsTesting() {
		return (bool)MQL5InfoInteger(MQL5_TESTING);
	}

	bool IsTradeAllowed() {
		return (bool)MQL5InfoInteger(MQL5_TRADE_ALLOWED) && (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);
	}

	bool IsExpertEnabled() {
		return (bool)TerminalInfoInteger(TERMINAL_EXPERTS_ENABLED);
	}

	bool IsTradeContextBusy() {
		return (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED); // ?
	}

	bool IsVisualMode() {
		return (bool)MQL5InfoInteger(MQL5_VISUAL_MODE);
	}

	string TerminalCompany() {
		return TerminalInfoString(TERMINAL_COMPANY)
	}

	string TerminalName() {
		return TerminalInfoString(TERMINAL_NAME);
	}

	string TerminalPath() {
		// TerminalInfoString(TERMINAL_DATA_PATH)
		// TerminalInfoString(TERMINAL_COMMONDATA_PATH)
		return TerminalInfoString(TERMINAL_PATH);
	}

	int Day() {
		MqlDateTime tm;
		TimeCurrent(tm);
		return tm.day;
	}

	int DayOfWeek() {
		MqlDateTime tm;
		TimeCurrent(tm);
		return tm.day_of_week;
	}

	int DayOfYear() {
		MqlDateTime tm;
		TimeCurrent(tm);
		return DayOfYear=tm.day_of_year;
	}

	int Month() {
		MqlDateTime tm;
		TimeCurrent(tm);
		return tm.month;
	}

	int Year() {
		MqlDateTime tm;
		TimeCurrent(tm);
		return tm.year;
	}

	int Hour() {
		MqlDateTime tm;
		TimeCurrent(tm);
		return Hour=tm.hour;
	}

	int Minute() {
		MqlDateTime tm;
		TimeCurrent(tm);
		return Minute=tm.min;
	}

	int Seconds() {
		MqlDateTime tm;
		TimeCurrent(tm);
		return tm.sec;
	}

	datetime TimeDay() {
		MqlDateTime tm;
		TimeToStruct(TargetTime,tm);
		return tm.day;
	}

	datetime TimeDayOfWeek() {
		MqlDateTime tm;
		TimeToStruct(TargetTime,tm);
		return tm.day_of_week;
	}

	datetime TimeDayOfYear() {
		MqlDateTime tm;
		TimeToStruct(TargetTime,tm);
		return tm.day_of_year;
	}

	datetime TimeMonth() {
		MqlDateTime tm;
		TimeToStruct(TargetTime,tm);
		return tm.month;
	}

	datetime TimeYear()	{
		MqlDateTime tm;
		TimeToStruct(TargetTime,tm);
		return tm.year;
	}

	datetime TimeHour() {
		MqlDateTime tm;
		TimeToStruct(TargetTime,tm);
		return tm.hour;
	}

	datetime TimeMinute() {
		MqlDateTime tm;
		TimeToStruct(TargetTime,tm);
		return tm.min;
	}

	datetime TimeSeconds() {
		MqlDateTime tm;
		TimeToStruct(TargetTime,tm);
		return tm.sec;
	}

};
