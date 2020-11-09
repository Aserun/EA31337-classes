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

// Prevents processing this includes file for the second time.
#ifndef JSON_SERIALIZER_MQH
#define JSON_SERIALIZER_MQH

// Includes.
#include "DictBase.mqh"
#include "SerializerConverter.mqh"
#include "SerializerNodeIterator.mqh"
#include "SerializerNode.mqh"
#include "SerializerNodeParam.mqh"
#include "Serializer.enum.h"
#include "Log.mqh"

enum ENUM_SERIALIZER_FLAGS {
  SERIALIZER_FLAG_HIDE_FIELD = 1
};

class Serializer {
 protected:
  SerializerNode* _node;
  SerializerNode* _root;
  SerializerMode _mode;
  bool _root_node_ownership;

  Ref<Log> _logger;

 public:
  /**
   * Constructor.
   */
  Serializer(SerializerNode* node, SerializerMode mode) : _node(node), _mode(mode) {
    _root = node;
    _logger = new Log();
    _root_node_ownership = true;
  }

  /**
   * Destructor.
   */
  ~Serializer() {
    if (_root_node_ownership && _root != NULL) delete _root;
  }
  
  /**
   * Returns logger object.
   */
  Log* Logger() { return _logger.Ptr(); }

  template <typename X>
  SerializerIterator<X> Begin() {
    SerializerIterator<X> iter(&this, _node);
    return iter;
  }
  
  void FreeRootNodeOwnership() {
    _root_node_ownership = false;
  }

  /**
   * Enters object or array for a given key or just iterates over objects/array during unserializing.
   */
  void Enter(SerializerEnterMode mode, string key = "") {
    if (IsWriting()) {
      SerializerNodeParam* nameParam = (key != NULL && key != "") ? SerializerNodeParam::FromString(key) : NULL;

      // When writing, we need to make parent->child structure. It is not
      // required when reading, because structure is full done by parsing the
      // string.
      _node = new SerializerNode(mode == SerializerEnterObject ? SerializerNodeObject : SerializerNodeArray, _node, nameParam);

      if (_node.GetParent() != NULL) _node.GetParent().AddChild(_node);

      if (_root == NULL) _root = _node;
    } else {
      SerializerNode* child;

      if (key != "") {
        // We need to enter object that matches given key.
        for (unsigned int i = 0; i < _node.NumChildren(); ++i) {
          child = _node.GetChild(i);
          if (child.GetKeyParam().AsString(false, false) == key) {
            _node = child;
            return;
          }
        }
      } else if (key == "") {
        child = _node.GetNextChild();

        if (!child)
          Print("End of objects during JSON deserialization! There were only ", _node.NumChildren(), " nodes!");

        _node = child;
      }
    }
  }

  /**
   * Leaves current object/array. Used in custom Serialize() method.
   */
  void Leave() { _node = _node.GetParent(); }

  /**
   * Checks whether we are in serialization process. Used in custom Serialize() method.
   */
  bool IsWriting() { return _mode == Serialize; }

  /**
   * Checks whether we are in unserialization process. Used in custom Serialize() method.
   */
  bool IsReading() { return _mode == Unserialize; }

  /**
   * Checks whether current node is an array. Used in custom Serialize() method.
   */
  bool IsArray() { return _mode == Unserialize && _node != NULL && _node.GetType() == SerializerNodeArray; }

  /**
   * Checks whether current node is an object. Used in custom Serialize() method.
   */
  bool IsObject() { return _mode == Unserialize && _node != NULL && _node.GetType() == SerializerNodeObject; }

  /**
   * Returns number of child nodes.
   */
  unsigned int NumChildren() { return _node ? _node.NumChildren() : 0; }

  /**
   * Returns root node or NULL. Could be used after unserialization.
   */
  SerializerNode* GetRoot() { return _root; }

  /**
   * Returns child node for a given index or NULL.
   */
  SerializerNode* GetChild(unsigned int index) { return _node ? _node.GetChild(index) : NULL; }

  /**
   * Serializes or unserializes object.
   */
  template <typename T, typename V>
  void PassObject(T& self, string name, V& value) {
    PassStruct(self, name, value);
  }

  /**
   * Serializes or unserializes structure.
   */
  template <typename T, typename V>
  void PassStruct(T& self, string name, V& value, unsigned int flags = 0) {
    Enter(SerializerEnterObject, name);
    
    _node.SetFlags(flags);
    
    SerializerNodeType newType = value.Serialize(this);

    if (newType != SerializerNodeUnknown) _node.SetType(newType);

    Leave();
  }

  /**
   * Serializes or unserializes enum value (stores it as integer).
   */
  template <typename T, typename V>
  void PassEnum(T& self, string name, V& value, unsigned int flags = 0) {
    int enumValue;
    if (_mode == Serialize) {
      enumValue = (int)value;
      Pass(self, name, enumValue, flags);
    } else {
      Pass(self, name, enumValue, flags);
      value = (V)enumValue;
    }
  }

  /**
   * Serializes or unserializes pointer to object.
   */
  template <typename T, typename V>
  void Pass(T& self, string name, V*& value, unsigned int flags = 0) {
    if (_mode == JsonSerialize) {
      PassObject(self, name, value, flags);
    } else {
      V* newborn = new V();

      PassObject(self, name, newborn, flags);

      value = newborn;
    }
  }

  /**
   * Serializes or unserializes simple value.
   */
  template <typename T, typename V>
  void Pass(T& self, string name, V& value, unsigned int flags = 0) {
    if (_mode == Serialize) {
      SerializerNodeParam* key = name != "" ? SerializerNodeParam::FromString(name) : NULL;
      SerializerNodeParam* val = SerializerNodeParam::FromValue(value);
      _node.AddChild(new SerializerNode(SerializerNodeObjectProperty, _node, key, val, flags));
    } else {
      for (unsigned int i = 0; i < _node.NumChildren(); ++i) {
        SerializerNode* child = _node.GetChild(i);
        if (child.GetKeyParam().AsString(false, false) == name) {
          SerializerNodeParamType paramType = child.GetValueParam().GetType();

          switch (paramType) {
            case SerializerNodeParamBool:
              value = (V)child.GetValueParam()._integral._bool;
              break;
            case SerializerNodeParamLong:
              value = (V)child.GetValueParam()._integral._long;
              break;
            case SerializerNodeParamDouble:
              value = (V)child.GetValueParam()._integral._double;
              break;
            case SerializerNodeParamString:
              value = (V)child.GetValueParam()._string;
              break;
          }

          return;
        }
      }
    }
  }
  
  static string ValueToString(datetime value, bool includeQuotes = false, bool escape = true) {
#ifdef __MQL5__
    return (includeQuotes ? "\"" : "") + TimeToString(value) + (includeQuotes ? "\"" : "");
#else
    return (includeQuotes ? "\"" : "") + TimeToStr(value) + (includeQuotes ? "\"" : "");
#endif
  }

  static string ValueToString(bool value, bool includeQuotes = false, bool escape = true) {
    return (includeQuotes ? "\"" : "") + (value ? "true" : "false") + (includeQuotes ? "\"" : "");
  }

  static string ValueToString(int value, bool includeQuotes = false, bool escape = true) {
    return (includeQuotes ? "\"" : "") + IntegerToString(value) + (includeQuotes ? "\"" : "");
  }

  static string ValueToString(long value, bool includeQuotes = false, bool escape = true) {
    return (includeQuotes ? "\"" : "") + IntegerToString(value) + (includeQuotes ? "\"" : "");
  }

  static string ValueToString(string value, bool includeQuotes = false, bool escape = true) {
    string output = includeQuotes ? "\"" : "";
    unsigned short _char;

    for (unsigned short i = 0; i < StringLen(value); ++i) {
#ifdef __MQL5__
      _char = StringGetCharacter(value, i);
#else
      _char = StringGetChar(value, i);
#endif
      if (escape)
      {
        switch (_char) {
          case '"':          
            output += "\\\"";
            continue;
          case '/':
            output += "\\/";
            continue;
          case '\n':
            if (escape)
            output += "\\n";
            continue;
          case '\r':
            if (escape)
            output += "\\r";
            continue;
          case '\t':
            if (escape)
            output += "\\t";
            continue;
          case '\\':
            if (escape)
            output += "\\\\";
            continue;
        }
      }
      
#ifdef __MQL5__
      output += ShortToString(StringGetCharacter(value, i));
#else
      output += ShortToString(StringGetChar(value, i));
#endif
    }

    return output + (includeQuotes ? "\"" : "");
  }

  static string ValueToString(float value, bool includeQuotes = false, bool escape = true) {
    return (includeQuotes ? "\"" : "") + StringFormat("%.6f", value) + (includeQuotes ? "\"" : "");
  }

  static string ValueToString(double value, bool includeQuotes = false, bool escape = true) {
    return (includeQuotes ? "\"" : "") + StringFormat("%.8f", value) + (includeQuotes ? "\"" : "");
  }

  static string ValueToString(Object* _obj, bool includeQuotes = false, bool escape = true) {
    return (includeQuotes ? "\"" : "") + ((Object*)_obj).ToString() + (includeQuotes ? "\"" : "");
  }
  template <typename T>
  static string ValueToString(T value, bool includeQuotes = false, bool escape = true) {
    return StringFormat("%s%s%s", (includeQuotes ? "\"" : ""), value, (includeQuotes ? "\"" : ""));
  }

  #define SERIALIZER_EMPTY_STUB \
    template <> \
    void SerializeStub(int _n1 = 1, int _n2 = 1, int _n3 = 1,int _n4 = 1, int _n5 = 1) { \
    }
  
  template<typename X>
  static SerializerConverter MakeStubObject(int _n1 = 1, int _n2 = 1, int _n3 = 1,int _n4 = 1, int _n5 = 1) {
    X stub;
    stub.SerializeStub(_n1, _n2, _n3, _n4, _n5);
    return SerializerConverter::FromObject(stub);
  }
};

#endif // End: JSON_SERIALIZER_MQH