import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sharedbill/providers/settingsState.dart';
import 'package:sharedbill/providers/suggestionsState.dart';
import 'package:sharedbill/controllers/tabsController.dart';
import 'package:sharedbill/services/contacts.dart';
import 'package:sharedbill/models/tab.dart';

class NewTab extends StatefulWidget {
  static const String id = "create";

  @override
  _CreateFormState createState() => _CreateFormState();
}

mixin KeyboardVisibilityMixin<T extends StatefulWidget> on State<T> {
  // ... existing code ...
}

class _CreateFormState extends State<NewTab> with KeyboardVisibilityMixin {
  final _formKey = GlobalKey<FormState>();
  String? name;
  double? amount;
  String? description;
  bool userOwesFriend = true;

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _pageViewController = PageController();
  final _textControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  final _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    super.initState();
    Contacts.checkPermission();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount.';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number.';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name.';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (name != null && amount != null && description != null) {
        await TabsController.createTab(
          name: name!,
          amount: amount!,
          description: description!,
          userOwesFriend: userOwesFriend,
        );

        // Update suggestions
        Provider.of<SuggestionsState>(context, listen: false)
            .addSuggestion(name!);
        Provider.of<SuggestionsState>(context, listen: false)
            .addSuggestion(description!);

        Navigator.pop(context);
      }
    }
  }

  Widget _buildNamePage(BuildContext context) {
    return buildPage(
      pageIndex: 0,
      title: "Name",
      description:
          "Enter the name of the person who you're making this tab for.",
      textField: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: validateName,
            onSaved: (value) => name = value,
          ),
        ],
      ),
      suggestions: Provider.of<SuggestionsState>(context).suggestions["names"] as List<String>?,
      suggestionsState: Provider.of<SuggestionsState>(context),
    );
  }

  Widget _buildAmountPage(BuildContext context) {
    return buildPage(
      pageIndex: 1,
      title: "Amount",
      description: userOwesFriend
          ? "Why does ${_textControllers[0].text} owe you ${Provider.of<SettingsState>(context).selectedCurrency ?? ''}${_textControllers[1].text}?"
          : "Why does ${_textControllers[0].text} owe ${_textControllers[1].text} ${Provider.of<SettingsState>(context).selectedCurrency ?? ''}?",
      textField: TextFormField(
        controller: _amountController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
        ],
        decoration: const InputDecoration(labelText: 'Amount'),
        validator: validateAmount,
        onSaved: (value) => amount = double.tryParse(value ?? ''),
      ),
      suggestions: Provider.of<SuggestionsState>(context).suggestions["amounts"] as List<String>?,
      suggestionsState: Provider.of<SuggestionsState>(context),
    );
  }

  Widget _buildDescriptionPage(BuildContext context) {
    return buildPage(
      pageIndex: 2,
      title: "What's this for?",
      description: userOwesFriend
          ? "Enter a description for the tab."
          : "Enter a description for the debt.",
      textField: TextFormField(
        controller: _descriptionController,
        decoration: const InputDecoration(labelText: 'Description'),
        validator: (value) => value == null || value.isEmpty ? 'Please enter a description.' : null,
        onSaved: (value) => description = value,
      ),
      suggestions: Provider.of<SuggestionsState>(context).suggestions["descriptions"] as List<String>?,
      suggestionsState: Provider.of<SuggestionsState>(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suggestionsState = Provider.of<SuggestionsState>(context);
    final settingsState = Provider.of<SettingsState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Tab'),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageViewController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildNamePage(context),
            _buildAmountPage(context),
            _buildDescriptionPage(context),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
} 