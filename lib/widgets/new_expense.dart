import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key,required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  String _enterTitle='';
  void _saveTitleInput(String inputValue){
    _enterTitle=inputValue;
  }

  final _titleController=TextEditingController();
  final _amountController=TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory=Category.leisure;


  void _presentDatePicker() async{
    final now =DateTime.now();
    final firstDate=DateTime(now.year - 1,now.month,now.day);
    final pickedDate= await showDatePicker(context: context, initialDate: now,firstDate: firstDate, lastDate: now);
    setState(() {
    _selectedDate=pickedDate;
    });
    debugPrint("${_selectedDate}");
  }

  void _showDialog(){
    if(Platform.isIOS){
      showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(
        title: const Text("Invalid input"),content: const Text("please make sure date,amount and title in proper format"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(ctx);
          }, child: const Text("Okay"))
        ],
      ),);
    }
    else{
      showDialog(context: context, builder: (ctx) {
        return AlertDialog(title: const Text("Invalid input"),content: const Text("please make sure date,amount and title in proper format"),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(ctx);
            }, child: const Text("Okay"))
          ],);
      },);
    }
  }

  void _submitExpenseData(){
    final enteredAmount=double.tryParse(_amountController.text);
    final amountIsInvalid= enteredAmount==null || enteredAmount<=0;
    if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate==null){
      _showDialog();
      return;
    }
    widget.onAddExpense(Expense(amount: enteredAmount, date: _selectedDate!, title: _titleController.text, category: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSize=MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        debugPrint("minHeight ${constraints.minHeight}");
        debugPrint("maxHeight ${constraints.maxHeight}");
        debugPrint("minWidth ${constraints.minWidth}");
        debugPrint("maxWidth ${constraints.maxWidth}");
        final width=constraints.maxWidth; // depends on the width of the parent widget
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(padding: EdgeInsets.fromLTRB(16,16,16,keyBoardSize + 16),
              child: Column(
                children: [
                  if(width>=600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            onChanged: _saveTitleInput,
                            maxLength: 50,
                            decoration: const InputDecoration(
                                label: Text("Title")
                            ),
                          ),
                        ),
                        const SizedBox(width: 24,),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                prefixText: '\$ ',
                                label: Text("Amount")
                            ),
                          ),
                        ),
                      ],
                      )
                  else
                    TextField(
                      controller: _titleController,
                      onChanged: _saveTitleInput,
                      maxLength: 50,
                      decoration: const InputDecoration(
                      label: Text("Title")
                    ),
                  ),
                  if(width>=600)
                    Row(
                      children: [
                        DropdownButton(value: _selectedCategory,items: Category.values.map((category) => DropdownMenuItem(value: category,child: Text(category.name.toUpperCase()))).toList(), onChanged: (value) {
                          // setState(() {
                          // _selectedCategory=value!;
                          // });
                          if(value==null){
                            return;
                          }
                          setState(() {
                            _selectedCategory=value;
                          });
                        },),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_selectedDate !=null ? formatter.format(_selectedDate!): 'No date selected'),
                              IconButton(onPressed: _presentDatePicker, icon: const Icon(Icons.calendar_month))
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text("Amount")
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate !=null ? formatter.format(_selectedDate!): 'No date selected'),
                            IconButton(onPressed: _presentDatePicker, icon: const Icon(Icons.calendar_month))
                          ],
                        ),
                      )
                    ],
                  ),
                  if(width>=600)
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: const Text("Cancel")),
                        ElevatedButton(onPressed: _submitExpenseData, child: const Text("Save Expense"))
                      ],
                    )
                  else
                  Row(
                    children: [
                      const SizedBox(height: 16,),
                      DropdownButton(value: _selectedCategory,items: Category.values.map((category) => DropdownMenuItem(value: category,child: Text(category.name.toUpperCase()))).toList(), onChanged: (value) {
                        // setState(() {
                        // _selectedCategory=value!;
                        // });
                        if(value==null){
                          return;
                        }
                        setState(() {
                          _selectedCategory=value;
                        });
                      },),
                      const Spacer(),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: const Text("Cancel")),
                      ElevatedButton(onPressed: _submitExpenseData, child: const Text("Save Expense"))
                    ],
                  )
                ],
              ),),
          ),
        );
      },)
    );
  }
}
