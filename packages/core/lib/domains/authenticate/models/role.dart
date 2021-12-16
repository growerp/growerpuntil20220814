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
class Role {
  final String _name;
  const Role._(this._name);

  @override
  String toString() {
    return _name;
  }

  /// special employee all access within the owner company
  static const Role Admin = Role._('GROWERP_M_ADMIN');

  /// employee limited access within the owner company:
  /// 1. no accounting
  /// 2. no editing of company level data
  static const Role Employee =
      Role._('GROWERP_M_EMPLOYEE'); // employee of owner company
  static const Role Customer = Role._('GROWERP_M_CUSTOMER');
  static const Role Lead = Role._('GROWERP_M_LEAD');
  static const Role Supplier = Role._('GROWERP_M_SUPPLIER');

  static Role? tryParse(String val) {
    switch (val.toLowerCase()) {
      case 'admin':
        return Admin;
      case 'employee':
        return Employee;
      case 'customer':
        return Customer;
      case 'lead':
        return Lead;
      case 'supplier':
        return Supplier;
    }
  }
}
