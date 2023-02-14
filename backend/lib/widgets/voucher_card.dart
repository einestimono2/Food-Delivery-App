import 'package:backend/constants/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';
import 'widgets.dart';

class VoucherCard extends StatefulWidget {
  const VoucherCard({
    Key? key,
    this.voucher,
  }) : super(key: key);

  final Voucher? voucher;

  @override
  State<VoucherCard> createState() => _VoucherCardState();
}

class _VoucherCardState extends State<VoucherCard> {
  late TextEditingController _codeController;
  late TextEditingController _valueController;

  bool loading = false;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.voucher?.code);
    _valueController = TextEditingController(
      text: widget.voucher?.value.toString(),
    );
  }

  _showError(String error) => showSnackBar(
        context,
        error,
        backgroundColor: Colors.black87,
      );

  _addVoucher() {
    if (double.tryParse(_valueController.text) == null) {
      return _showError('Value invalid!');
    }

    Voucher voucher = Voucher(
      code: _codeController.text,
      value: double.parse(_valueController.text),
    );

    BlocProvider.of<VoucherBloc>(context).add(AddVoucher(voucher: voucher));
  }

  _updateVoucher() {
    if (double.tryParse(_valueController.text) == null) {
      return _showError('Value invalid!');
    }

    Voucher voucher = Voucher(
      id: widget.voucher!.id!,
      code: _codeController.text,
      value: double.parse(_valueController.text),
    );

    BlocProvider.of<VoucherBloc>(context).add(
      UpdateVoucher(voucher: voucher),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocListener<VoucherBloc, VoucherState>(
        listener: (context, state) {
          if (state is VoucherLoading) {
            setState(() {
              loading = true;
            });
          }

          if (state is VoucherLoaded) {
            setState(() {
              loading = false;
            });

            if (!error) {
              _showError(
                widget.voucher == null
                    ? "Added the voucher!"
                    : "Updated the voucher!",
              );
              Navigator.pop(context);
            } else {
              setState(() {
                error = false;
              });
            }
          }

          if (state is VoucherError) {
            setState(() {
              loading = false;
              error = true;
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.height / 2.7,
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  InputField(
                    title: "Code",
                    hintText: "Enter voucher code",
                    controller: _codeController,
                  ),
                  InputField(
                    title: "Value",
                    hintText: "Enter voucher value",
                    controller: _valueController,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                      onPressed: () => widget.voucher == null
                          ? _addVoucher()
                          : _updateVoucher(),
                      child: Text(widget.voucher == null ? "ADD" : "UPDATE"),
                    ),
                  ),
                ],
              ),
              loading
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const CustomLoading(),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
