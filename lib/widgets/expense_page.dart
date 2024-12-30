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

  void _openAddExtendedOverlay(){
    showModalBottomSheet(isScrollControlled: true,context: context, builder: (ctx) => const NewExpense());
  }

  @override
  Widget build(BuildContext context) {
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
          Expanded(child: ExpensesList(expenses: _registeredExpenses)),
        ],
      ),
    );
  }
}
