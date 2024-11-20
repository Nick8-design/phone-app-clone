import 'package:clonephone/common/sizebox.dart';
import 'package:flutter/material.dart';


class DialPadScreen extends StatefulWidget {
  const DialPadScreen({super.key});

  @override
  State<DialPadScreen>  createState() => _DialPadScreenState();
}




class _DialPadScreenState extends State<DialPadScreen> {


  late final TextEditingController phoneController;



  String _typedNumber = '';




  @override
  void initState() {
    // TODO: implement initState

    phoneController =  TextEditingController(text: '');
    super.initState();
  }

  void _onKeyPressed(String value) {
    setState(() {
      _typedNumber += value;
      phoneController.text= _typedNumber;
    });
  }

  void _onDelete() {
    setState(() {
      if (phoneController.text.isNotEmpty) {
        _typedNumber = _typedNumber.substring(0, _typedNumber.length - 1);
        phoneController.text=phoneController.text.substring(0,phoneController.text.length-1);
      }
    });
  }

  void _onCall() {
    // Add call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling $_typedNumber...')),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Column(
       // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0),

          child: Row(
            children: [

              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,

                          ),
                          autofocus: true,
                          textInputAction: TextInputAction.none,
                          onSubmitted: (value) {
                            //     startSearch(searchTextController.text);
                          },
                          controller: phoneController,


                         // focusNode: textFieldFocusNode,
                          onChanged: (value){
                            if(value.isEmpty) {
                              setState(() {
                         //       typyping=false;
                                phoneController.text= _typedNumber;

                              });
                            }else{
                              setState(() {
                                phoneController.text= _typedNumber;
                         //       typyping=true;
                              });
                            }
                          },
                          keyboardType:TextInputType.none ,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 36,
                        //    color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),


                        )
                    ),

                    //searchWidgets(),
                    IconButton(
            onPressed: _onDelete,
    icon: const Icon(Icons.backspace_outlined, color: Colors.white),
    iconSize: 24,
                    ),



                  ],
                ),
              ),
            ],
          ),

          ),
const Divider(),

          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 buttons per row
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 1.9
              ),
              padding: const EdgeInsets.only(left: 20,right: 20),
              itemCount: 12, // 0-9, *, and #
              itemBuilder: (context, index) {
                if (index == 9) {
                  return _buildDialButton('*');
                } else if (index == 10) {
                  return _buildDialButton('0');
                } else if (index == 11) {
                  return _buildDialButton('#');
                } else {
                  return _buildDialButton((index + 1).toString());
                }
              },
            ),
          ),
          // Call and delete buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Call button
                ElevatedButton.icon(
                  onPressed: _typedNumber.isNotEmpty ? _onCall : null,
                  icon: const Icon(Icons.call, color: Colors.white),
                  label: const Text('Call', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                // Delete button

              ],
            ),
          ),
        ],

    );
  }

  Widget _buildDialButton(String value) {
    return GestureDetector(
      onTap: () => _onKeyPressed(value),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(30))
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              if ('0123456789'.contains(value)) ...[
                const SizedBox(height: 2),
                Text(
                  _getKeypadLetters(value),
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  String _getKeypadLetters(String value) {
    switch (value) {
      case '2':
        return 'ABC';
      case '3':
        return 'DEF';
      case '4':
        return 'GHI';
      case '5':
        return 'JKL';
      case '6':
        return 'MNO';
      case '7':
        return 'PQRS';
      case '8':
        return 'TUV';
      case '9':
        return 'WXYZ';
      default:
        return '';
    }
  }
}