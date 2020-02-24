//+------------------------------------------------------------------+
//|                                                EA31337 framework |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/*
 * This file is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

// Includes.
#include "../Indicator.mqh"

// Structs.
struct AOEntry : IndicatorEntry {
  double value;
  string ToString(int _mode = EMPTY) {
    return StringFormat("%g", value);
  }
  bool IsValid() { return value != WRONG_VALUE && value != EMPTY_VALUE; }
};

/**
 * Implements the Awesome oscillator.
 */
class Indi_AO : public Indicator<AOEntry> {

 public:

  /**
   * Class constructor.
   */
  Indi_AO(IndicatorParams &_iparams, ChartParams &_cparams)
    : Indicator(_iparams, _cparams) { Init(); }
  Indi_AO(ENUM_TIMEFRAMES _tf = PERIOD_CURRENT)
    : Indicator(INDI_AO, _tf) { Init(); }

  /**
   * Initialize parameters.
   */
  void Init() {
    iparams.SetDataType(TYPE_DOUBLE);
    iparams.SetMaxModes(1);
  }

  /**
    * Returns the indicator value.
    *
    * @docs
    * - https://docs.mql4.com/indicators/iao
    * - https://www.mql5.com/en/docs/indicators/iao
    */
  static double iAO(
      string _symbol = NULL,
      ENUM_TIMEFRAMES _tf = PERIOD_CURRENT,
      int _shift = 0,
      Indicator<AOEntry> *_obj = NULL
      ) {
#ifdef __MQL4__
    return ::iAO(_symbol, _tf, _shift);
#else // __MQL5__
    int _handle = Object::IsValid(_obj) ? _obj.GetState().GetHandle() : NULL;
    double _res[];
    if (_handle == NULL || _handle == INVALID_HANDLE) {
      if ((_handle = ::iAO(_symbol, _tf)) == INVALID_HANDLE) {
        SetUserError(ERR_USER_INVALID_HANDLE);
        return EMPTY_VALUE;
      }
      else if (Object::IsValid(_obj)) {
        _obj.SetHandle(_handle);
      }
    }
    int _bars_calc = BarsCalculated(_handle);
    if (_bars_calc < 2) {
      SetUserError(ERR_USER_INVALID_BUFF_NUM);
      return EMPTY_VALUE;
    }
    if (CopyBuffer(_handle, 0, -_shift, 1, _res) < 0) {
      return EMPTY_VALUE;
    }
    return _res[0];
#endif
  }

  /**
    * Returns the indicator's value.
    */
  double GetValue(int _shift = 0) {
    double _value = Indi_AO::iAO(GetSymbol(), GetTf(), _shift);
    istate.is_ready = _LastError == ERR_NO_ERROR;
    istate.is_changed = false;
    return _value;
  }

  /**
    * Returns the indicator's struct value.
    */
  AOEntry GetEntry(int _shift = 0) {
    AOEntry _entry;
    _entry.timestamp = GetBarTime(_shift);
    _entry.value = GetValue(_shift);
    if (_entry.IsValid()) { _entry.AddFlags(INDI_ENTRY_FLAG_IS_VALID); }
    return _entry;
  }

  /**
   * Returns the indicator's entry value.
   */
  MqlParam GetEntryValue(int _shift = 0, int _mode = 0) {
    MqlParam _param = {TYPE_DOUBLE};
    _param.double_value = GetEntry(_shift).value;
    return _param;
  }

  /* Printer methods */

  /**
   * Returns the indicator's value in plain format.
   */
  string ToString(int _shift = 0, int _mode = EMPTY) {
    return GetEntry(_shift).ToString(_mode);
  }

};
