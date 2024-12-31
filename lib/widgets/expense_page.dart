import 'package:expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final List<Expense> _registeredExpenses = [
    Expense (title: 'Flutter Course',amount: 19.99,date: DateTime.now(), category: Category.work,),
    Expense (title: 'Cinema',amount: 15.69,date: DateTime.now(), category: Category.leisure,)
  ];

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }
  
  void _removeExpense(Expense expense){
    final expenseIndex=_registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Expense deleted"),duration: Duration(seconds: 3),action: SnackBarAction(label: 'undo', onPressed: () {
      setState(() {
      _registeredExpenses.insert(expenseIndex, expense);
      });
    },),));
  }

  void _openAddExtendedOverlay(){
    showModalBottomSheet(isScrollControlled: true,context: context, builder: (ctx) => NewExpense(onAddExpense: _addExpense,));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(child: Text("No Expenses found start adding some"),);
    if(_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter ExpenseTracker"),
        actions: [
          IconButton(onPressed: _openAddExtendedOverlay, icon: const Icon(Icons.add),)
        ],
      ),
      body: Column(
        children: [
          const Text("The Chart"),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
