/*
 * This GrowERP software is in the public domain under CC0 1.0 Universal plus a
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

class UserGroup {
  String userGroupId;
  String description;
  bool companyEmployee; // employee of the current company

  UserGroup({
    required this.userGroupId,
    required this.description,
    required this.companyEmployee,
  });
}

List<UserGroup> userGroups = [
  UserGroup(
      userGroupId: 'GROWERP_M_ADMIN',
      description: 'Admin',
      companyEmployee: true),
  UserGroup(
      userGroupId: 'GROWERP_M_CUSTOMER',
      description: 'Customer',
      companyEmployee: false),
  UserGroup(
      userGroupId: 'GROWERP_M_EMPLOYEE',
      description: 'Employee',
      companyEmployee: true),
  UserGroup(
      userGroupId: 'GROWERP_M_LEAD',
      description: 'Lead',
      companyEmployee: false),
  UserGroup(
      userGroupId: 'GROWERP_M_SUPPLIER',
      description: 'Supplier',
      companyEmployee: false)
];
