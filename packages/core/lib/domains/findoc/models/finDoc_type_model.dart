/*
 * This software is in the public domain under CC0 1.0 Universal plus a
 * Grant of Patent License.
 * 
 * To the extent possible under law, the author(s) have dedicated all
 * copyright and related and neighboring rights to this software to the
 * public domain worldwide. This software is distributed without any
 * warranty.
 * 
 * You should have received a copy of the CC0 Public Domain Dedication
 * along with this software (see the LICENSE.md file). If not, see
 * <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

// a replacement for enum:
// https://medium.com/@ra9r/overcoming-the-limitations-of-dart-enum-8866df8a1c47

/// financial document (FinDoc) types
class FinDocType {
  final String _name;
  const FinDocType._(this._name);

  @override
  String toString() {
    return _name;
  }

  static const FinDocType order = FinDocType._('Order');
  static const FinDocType invoice = FinDocType._('Invoice');
  static const FinDocType payment = FinDocType._('Payment');
  static const FinDocType shipment = FinDocType._('Shipment');
  static const FinDocType transaction = FinDocType._('Transaction');
  static const FinDocType unknown = FinDocType._('??');

  static FinDocType tryParse(String val) {
    switch (val.toLowerCase()) {
      case 'order':
        return order;
      case 'invoice':
        return invoice;
      case 'payment':
        return payment;
      case 'shipment':
        return shipment;
      case 'transaction':
        return transaction;
      default:
        return unknown;
    }
  }
}
