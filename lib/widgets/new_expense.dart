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
    final _pickedDate= await showDatePicker(context: context, initialDate: now,firstDate: firstDate, lastDate: now);
    setState(() {
    _selectedDate=_pickedDate;
    });
    print(_selectedDate);
  }

  void _submitExpenseData(){
    final enteredAmount=double.tryParse(_amountController.text);
    final amountIsInvalid= enteredAmount==null || enteredAmount<=0;
    if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate==null){
      showDialog(context: context, builder: (ctx) {
        return AlertDialog(title: Text("Invalid input"),content: Text("please make sure date,amount and title in proper format"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(ctx);
          }, child: Text("Okay"))
        ],);
      },);
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
    return Scaffold(
      body: Padding(padding: const EdgeInsets.fromLTRB(16,48,16,16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            onChanged: _saveTitleInput,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text("Title")
            ),
          ),
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
              }, child: Text("Cancel")),
              ElevatedButton(onPressed: _submitExpenseData, child: const Text("Save Expense"))
            ],
          )
        ],
      ),),
    );
  }
}
