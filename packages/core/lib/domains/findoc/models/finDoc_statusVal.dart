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
/// acting role within the system.
class FinDocStatusVal {
  final String _name;
  const FinDocStatusVal._(this._name);

  @override
  String toString() {
    return _name;
  }

  static const FinDocStatusVal InPreparation = FinDocStatusVal._('FinDocPrep');
  static const FinDocStatusVal Created = FinDocStatusVal._('FinDocCreated');
  static const FinDocStatusVal Approved = FinDocStatusVal._('FinDocApproved');
  static const FinDocStatusVal Completed = FinDocStatusVal._('FinDocCompleted');
  static const FinDocStatusVal Cancelled = FinDocStatusVal._('FinDocCancelled');

  static FinDocStatusVal? tryParse(String val) {
    switch (val) {
      case 'FinDocPrep':
        return InPreparation;
      case 'FinDocCreated':
        return Created;
      case 'FinDocApproved':
        return Approved;
      case 'FinDocCompleted':
        return Completed;
      case 'FinDocCancelled':
        return Cancelled;
    }
  }

  static FinDocStatusVal? nextStatus(FinDocStatusVal currentStatus) {
    switch (currentStatus) {
      case InPreparation:
        return Created;
      case Created:
        return Approved;
      case Approved:
        return Completed;
    }
  }

  static bool? statusFixed(FinDocStatusVal currentStatus) {
    switch (currentStatus) {
      case InPreparation:
        return false;
      case Created:
        return false;
      case Approved:
        return true;
      case Completed:
        return true;
      case Cancelled:
        return true;
    }
  }
}
