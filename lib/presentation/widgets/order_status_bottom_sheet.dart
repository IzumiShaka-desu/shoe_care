import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shoe_care/app/enum/order_status.dart';

// bottom sheet statefull that can select status and payment status with button update
class OrderStatusBottomSheet extends StatefulWidget {
  const OrderStatusBottomSheet({
    Key? key,
    this.initialStatus = OrderStatus.preparing,
    this.initialPaymentStatus = "unpaid",
    required this.onUpdateStatus,
  }) : super(key: key);
  final OrderStatus initialStatus;
  final String initialPaymentStatus;
  final Function(OrderStatus, String) onUpdateStatus;

  @override
  _OrderStatusBottomSheetState createState() => _OrderStatusBottomSheetState();
}

class _OrderStatusBottomSheetState extends State<OrderStatusBottomSheet> {
  String? _status;
  String? _paymentStatus;

  @override
  void initState() {
    _status = widget.initialStatus.name;
    _paymentStatus = widget.initialPaymentStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // dropdown status
          DropdownButtonFormField<OrderStatus>(
            items: OrderStatus.values
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.asName),
                  ),
                )
                .toList(),
            hint: const Text("Pilih status"),
            onChanged: (value) {
              setState(() {
                if (value == null) {
                  _status = null;
                  return;
                }
                _status = value.name;
              });
            },
          ),
          // dropdown payment status
          DropdownButtonFormField<String>(
            items: ["unpaid", "paid"]
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            hint: const Text("Pilih status pembayaran"),
            onChanged: (value) {
              setState(() {
                _paymentStatus = value;
              });
            },
          ),
          // button update
          Row(
            children: [
              // button cancel
              ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onUpdateStatus(
                    orderStatusFromStr(_status!),
                    _paymentStatus!,
                  );
                  context.pop();
                },
                child: const Text("Update"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
