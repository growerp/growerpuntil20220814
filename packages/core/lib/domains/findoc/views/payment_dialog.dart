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

import 'package:core/widgets/dialogCloseButton.dart';
import 'package:core/domains/domains.dart';
import 'package:decimal/decimal.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../api_repository.dart';
import '../../../services/api_result.dart';
import '../../common/functions/helper_functions.dart';

class PaymentDialog extends StatefulWidget {
  final FinDoc finDoc;
  final PaymentMethod? paymentMethod;
  PaymentDialog(this.finDoc, {this.paymentMethod});
  @override
  _PaymentState createState() => _PaymentState(finDoc);
}

class _PaymentState extends State<PaymentDialog> {
  final FinDoc finDoc; // incoming finDoc
  late APIRepository repos;
  late FinDoc finDocUpdated;
  User? _selectedUser;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late bool isPhone;
  PaymentInstrument paymentInstrument = PaymentInstrument.other;
  final _userSearchBoxController = TextEditingController();
  final _amountController = TextEditingController();
  _PaymentState(this.finDoc);

  @override
  void initState() {
    super.initState();
    repos = context.read<APIRepository>();
    finDocUpdated = finDoc;
    _selectedUser = finDocUpdated.otherUser;
    _amountController.text =
        finDoc.grandTotal == null ? '' : finDoc.grandTotal.toString();
  }

  @override
  Widget build(BuildContext context) {
    isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    return BlocListener<FinDocBloc, FinDocState>(
      listener: (context, state) {
        if (state.status == FinDocStatus.success) Navigator.of(context).pop();
        if (state.status == FinDocStatus.failure)
          HelperFunctions.showMessage(context, '${state.message}', Colors.red);
      },
      child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: ScaffoldMessenger(
              key: scaffoldMessengerKey,
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: GestureDetector(
                      onTap: () {},
                      child: Dialog(
                          key: Key(
                              "PaymentDialog${finDoc.sales ? 'Sales' : 'Purchase'}"),
                          insetPadding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(clipBehavior: Clip.none, children: [
                            Container(
                                width: 400, height: 800, child: paymentForm()),
                            Positioned(
                                top: -10,
                                right: -10,
                                child: DialogCloseButton())
                          ])))))),
    );
  }

  Widget paymentForm() {
    FinDocBloc finDocBloc = BlocProvider.of<FinDocBloc>(context);
    AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          SizedBox(height: 20),
          Center(
              child: Text(
                  "${finDoc.sales ? 'Sales/incoming' : 'Purchase/outgoing'} "
                  "Payment# ${finDoc.paymentId ?? 'new'}",
                  style: TextStyle(
                      fontSize: isPhone ? 10 : 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold))),
          SizedBox(height: 30),
          DropdownSearch<User>(
            dialogMaxWidth: 300,
            searchFieldProps: TextFieldProps(
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0)),
              ),
              controller: _userSearchBoxController,
            ),
            selectedItem: _selectedUser,
            popupShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            dropdownSearchDecoration: InputDecoration(
              labelText: finDocUpdated.sales ? 'Customer' : 'Supplier',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
            ),
            showSearchBox: true,
            isFilteredOnline: true,
            key: Key(finDocUpdated.sales ? 'customer' : 'supplier'),
            itemAsString: (User? u) =>
                "${u!.companyName},\n${u.firstName} ${u.lastName}",
            onFind: (String? filter) async {
              ApiResult<List<User>> result = await repos.getUser(
                  userGroups: [UserGroup.Customer, UserGroup.Supplier],
                  filter: _userSearchBoxController.text);
              return result.when(
                  success: (data) => data,
                  failure: (_) => [User(lastName: 'get data error!')]);
            },
            onChanged: (User? newValue) {
              setState(() {
                _selectedUser = newValue;
              });
            },
            validator: (value) => value == null
                ? "Select ${finDocUpdated.sales ? 'Customer' : 'Supplier'}!"
                : null,
          ),
          SizedBox(height: 20),
          TextFormField(
            key: Key('amount'),
            decoration: InputDecoration(
                contentPadding:
                    new EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0),
                labelText: 'Amount'),
            controller: _amountController,
          ),
          SizedBox(height: 20),
          Container(
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'PaymentMethods',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  Visibility(
                      visible: (finDoc.sales == true &&
                              _selectedUser
                                      ?.companyPaymentMethod?.ccDescription !=
                                  null) ||
                          (finDoc.sales == false &&
                              authBloc.state.authenticate?.company
                                      ?.paymentMethod?.ccDescription !=
                                  null),
                      child: Row(children: [
                        Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: paymentInstrument ==
                                PaymentInstrument.creditcard,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true)
                                  paymentInstrument =
                                      PaymentInstrument.creditcard;
                              });
                            }),
                        Expanded(
                            child: Text("Credit Card " +
                                (finDoc.sales == false
                                    ? "${authBloc.state.authenticate?.company?.paymentMethod?.ccDescription}"
                                    : "${_selectedUser?.companyPaymentMethod?.ccDescription}"))),
                      ])),
                  Row(children: [
                    Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: paymentInstrument == PaymentInstrument.cash,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true)
                              paymentInstrument = PaymentInstrument.cash;
                          });
                        }),
                    Expanded(
                        child: Text(
                      "Cash",
                    )),
                  ]),
                  Row(children: [
                    Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: paymentInstrument == PaymentInstrument.check,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true)
                              paymentInstrument = PaymentInstrument.check;
                          });
                        }),
                    Expanded(
                        child: Text(
                      "Check",
                    )),
                  ]),
                  Row(children: [
                    Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: paymentInstrument == PaymentInstrument.bank,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true)
                              paymentInstrument = PaymentInstrument.bank;
                          });
                        }),
                    Expanded(
                        child: Text(
                      "Bank ${finDoc.otherUser?.companyPaymentMethod?.creditCardNumber ?? ''}",
                    )),
                  ]),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              key: Key('update'),
              child: Text((finDoc.idIsNull() ? 'Create ' : 'Update ') +
                  '${finDocUpdated.docType}'),
              onPressed: () {
                finDocBloc.add(FinDocUpdate(finDocUpdated.copyWith(
                  otherUser: _selectedUser,
                  grandTotal: Decimal.parse(_amountController.text),
                  paymentInstrument: paymentInstrument,
                )));
              }),
        ]));
  }
}
