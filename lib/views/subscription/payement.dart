// ignore_for_file: avoid_print, use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medsos/views/Patient_part/call/CallMeet/waitingCall.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medsos/service/user_provider.dart';
import 'package:uuid/uuid.dart';

class PaymentPage extends StatefulWidget {
  final int amount;
  final String type;
  const PaymentPage({super.key, required this.amount, required this.type});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedMethod = 'Orange';
  bool hasFunds = false;
  bool _isLoading = false;

  final phoneController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  String? cardType;
  final paymentImageMap = {
    'Orange': 'assets/images/orange.jpeg',
    'MTN': 'assets/images/mtn.jpg',
    'MASTER-CARD': 'assets/images/master.jpg',
  };
  final _formKey = GlobalKey<FormState>();

  TextInputFormatter cameroonPhoneFormatter = TextInputFormatter.withFunction((
    oldValue,
    newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 9) return oldValue;
    var formatted = '';
    for (var i = 0; i < digits.length; i++) {
      formatted += digits[i];
      if (i == 2 || i == 5) formatted += '-';
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  });

  void _detectCardType(String input) {
    final number = input.replaceAll(' ', '');
    setState(() {
      if (number.startsWith('4')) {
        cardType = 'Visa';
      } else if (number.startsWith('5'))
        cardType = 'MasterCard';
      else if (number.startsWith('6'))
        cardType = 'Discover';
      else
        cardType = null;
    });
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final user = context.read<UserProvider>().user!;
    final now = DateTime.now();
    final roomCode = const Uuid().v4();

    // Create call session
    await FirebaseFirestore.instance
        .collection('call_sessions')
        .doc(roomCode)
        .set({
          'caller': user.fullName,
          'callerPhone': user.phone,
          'status': 'pending',
          'createdAt': now.toIso8601String(),
          'type': widget.type,
          'roomCode': roomCode,
          'callee': null,
          'isNewForUser': true,
        });

    setState(() => _isLoading = false);
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => WaitingForDoctorPage(
              roomCode: roomCode,
              phone: user.phone,
              type: widget.type, // 👈 pass type of call
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentMethods = paymentImageMap.keys.toList();
    final isCard = selectedMethod == 'MASTER-CARD';

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Paiement Mobile'),
            backgroundColor: Colors.green,
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Type d'appel choisi:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${widget.type} – ${widget.amount} FCFA",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Pays *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("Cameroun"),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Mode de paiement *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children:
                        paymentMethods.map((method) {
                          return Expanded(
                            child: GestureDetector(
                              onTap:
                                  () => setState(() => selectedMethod = method),
                              child: Container(
                                height: 60,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        selectedMethod == method
                                            ? Colors.green
                                            : Colors.grey,
                                    width: selectedMethod == method ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  paymentImageMap[method]!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 20),
                  if (!isCard) ...[
                    const Text(
                      "Numéro de téléphone *",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: const Text("237"),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: phoneController,
                            inputFormatters: [cameroonPhoneFormatter],
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: '698-123-456',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Champ requis';
                              }
                              final digits = value.replaceAll(
                                RegExp(r'\D'),
                                '',
                              );
                              if (digits.length != 9 ||
                                  !digits.startsWith('6')) {
                                return 'Numéro invalide';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const Text(
                      "Numéro de carte *",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: cardNumberController,
                      keyboardType: TextInputType.number,
                      onChanged: _detectCardType,
                      decoration: InputDecoration(
                        hintText: '1234 5678 9012 3456',
                        border: const OutlineInputBorder(),
                        suffixIcon:
                            cardType != null
                                ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    cardType!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                : null,
                      ),
                      validator: (value) {
                        final digits =
                            value?.replaceAll(RegExp(r'\D'), '') ?? '';
                        if (digits.length < 16) return 'Carte invalide';
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Date d'expiration *",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: expiryController,
                                keyboardType: TextInputType.datetime,
                                decoration: const InputDecoration(
                                  hintText: 'MM/AA',
                                  border: OutlineInputBorder(),
                                ),
                                validator:
                                    (value) =>
                                        value == null ||
                                                !RegExp(
                                                  r'^\d{2}/\d{2}\$',
                                                ).hasMatch(value)
                                            ? 'Format invalide'
                                            : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "CVV *",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: cvvController,
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                decoration: const InputDecoration(
                                  hintText: '123',
                                  border: OutlineInputBorder(),
                                  counterText: '',
                                ),
                                validator:
                                    (value) =>
                                        value == null || value.length != 3
                                            ? 'CVV invalide'
                                            : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      border: Border.all(color: const Color(0xFFFFEEBA)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Avant de continuer, assurez-vous de disposer des fonds nécessaires sur votre compte Mobile Money ou bancaire.",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 15),
                  CheckboxListTile(
                    value: hasFunds,
                    onChanged: (v) => setState(() => hasFunds = v ?? false),
                    title: const Text(
                      "J’ai les fonds nécessaires",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          hasFunds && !_isLoading ? _submitPayment : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      child: Text("Payer ${widget.amount} FCFA"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
