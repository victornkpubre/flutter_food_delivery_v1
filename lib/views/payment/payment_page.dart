import 'package:flutter/material.dart';
import 'package:flutterwave/core/flutterwave.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({ Key? key }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final Flutterwave flutterwave;


  _paymentInitialization() async { 
    // final style = FlutterwaveStyle(
    //   appBarText: "My Standard Blue", 
    //   buttonColor: Color(0xffd0ebff), 
    //   appBarIcon: Icon(Icons.message, color: Color(0xffd0ebff)),
    //   buttonTextStyle: TextStyle( 
    //       color: Colors.black, 
    //       fontWeight: FontWeight.bold, 
    //       fontSize: 18), 
    //   appBarColor: Color(0xffd0ebff), 
    //   dialogCancelTextStyle: TextStyle(
    //     color: Colors.redAccent, 
    //     fontSize: 18
    //     ),
    //   dialogContinueTextStyle: TextStyle(
    //       color: Colors.blue, 
    //       fontSize: 18
    //     ) 
    //   ); 

    // final Customer customer = Customer(
    //   name: "FLW Developer", 
    //   phoneNumber: "1234566677777", 
    //   email: "customer@customer.com"
    // );  
            
    // flutterwave = Flutterwave(
    //   context: context, 
    //   style: style, 
    //   publicKey: "FLWPUBK-41680494ad789bd4719484548f4cdea7-X", 
    //   currency: "NGN", 
    //   redirectUrl: "my_redirect_url" ,
    //   txRef: "unique_transaction_reference", 
    //   amount: "3000", 
    //   customer: customer, 
    //   paymentOptions: "ussd, card, barter, payattitude", 
    //   customization: Customization(title: "Test Payment"),
    //   isTestMode: true
    // ); 

    flutterwave = Flutterwave.forUIPayment(
      context: context, 
      publicKey: "FLWPUBK-41680494ad789bd4719484548f4cdea7-X", 
      encryptionKey: "2f317e67ec3e2503f602edc8", 
      currency: "NGN", 
      amount: "3000", 
      email: "victornkpubre@gmail.com", 
      fullName: "Victor Nkpubre", 
      txRef: "iujoidakpocjio", 
      isDebugMode: false, 
      phoneNumber: "08090659632",
      acceptAccountPayment: true,
      acceptBankTransfer: true,
      acceptCardPayment: true,
      acceptUSSDPayment: true

    );

  } 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _paymentInitialization();
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      child: Center(
        child: TextButton(
          child: Text("Chrage 3000"),
          onPressed: () async { 
             var response = await flutterwave.initializeForUiPayments(); 
            if (response != null) { 
              if(response.status == "success") { 
                print("success");
                print(response.data!.toJson()); 
              } else { 
                print("Failure"); 
              } 
            } else {
              print("Failure");
            }
          },
        )
      )
    );
  }
}