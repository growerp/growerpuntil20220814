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

  static const FinDocType Order = FinDocType._('order');
  static const FinDocType Invoice = FinDocType._('invoice');
  static const FinDocType Payment = FinDocType._('payment');
  static const FinDocType Shipment = FinDocType._('shipment');
  static const FinDocType Transaction = FinDocType._('transaction');
  static const FinDocType Unknown = FinDocType._('??');

  static FinDocType tryParse(String val) {
    switch (val.toLowerCase()) {
      case 'order':
        return Order;
      case 'invoice':
        return Invoice;
      case 'payment':
        return Payment;
      case 'shipment':
        return Shipment;
      case 'transaction':
        return Transaction;
      default:
        return Unknown;
    }
  }
}
