import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../backend/database_helper.dart';
import '../backend/debts.dart';


class AddDebtPage extends StatefulWidget {
  final Debt? existingDebt;

  const AddDebtPage({Key? key, this.existingDebt}) : super(key: key);

  @override
  _AddDebtPageState createState() => _AddDebtPageState();
}

class _AddDebtPageState extends State<AddDebtPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  String? _description;
  late String _accountName;
  late double _amount;
  late DateTime _date;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.existingDebt != null) {
      _name = widget.existingDebt!.name;
      _description = widget.existingDebt!.description;
      _accountName = widget.existingDebt!.accountName;
      _amount = widget.existingDebt!.amount;
      _date = widget.existingDebt!.date;
      _dueDate = widget.existingDebt!.dueDate;
    } else {
      _name = '';
      _accountName = '';
      _amount = 0.0;
      _date = DateTime.now();
      _dueDate = DateTime.now().add(const Duration(days: 30));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingDebt == null
            ? 'Add New Debt'
            : 'Edit Debt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Debt Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a debt name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Account',
                  border: OutlineInputBorder(),
                ),
                value: _accountName.isNotEmpty ? _accountName : null,
                items: Provider.of<FinanceState>(context)
                    .accounts
                    .map((account) => DropdownMenuItem(
                  value: account.name,
                  child: Text(account.name),
                ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select an account';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _accountName = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _amount.toString(),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onSaved: (value) => _amount = double.parse(value!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InputDatePickerFormField(
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDate: _date,
                      fieldLabelText: 'Debt Date',
                      onDateSaved: (date) => _date = date!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InputDatePickerFormField(
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDate: _dueDate,
                      fieldLabelText: 'Due Date',
                      onDateSaved: (date) => _dueDate = date!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveDebt,
                child: Text(widget.existingDebt == null
                    ? 'Add Debt'
                    : 'Update Debt'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveDebt() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final debtToSave = Debt(
        id: widget.existingDebt?.id,
        name: _name,
        description: _description,
        accountName: _accountName,
        amount: _amount,
        date: _date,
        dueDate: _dueDate,
      );

      if (widget.existingDebt == null) {
        Provider.of<FinanceState>(context, listen: false).addDebt(debtToSave);
      } else {
        Provider.of<FinanceState>(context, listen: false).updateDebt(debtToSave);
      }

      Navigator.of(context).pop();
    }
  }
}