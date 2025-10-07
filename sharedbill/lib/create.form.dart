import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:sharedbill/controllers/tabsController.dart';
import 'package:sharedbill/providers/suggestionsState.dart';
import 'package:sharedbill/services/contacts.dart';
import 'package:sharedbill/providers/settingsState.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

mixin KeyboardVisibilityMixin<T extends StatefulWidget> on State<T> {
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkKeyboardVisibility();
    });
  }

  void _checkKeyboardVisibility() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  @override
  void didChangeMetrics() {
    _checkKeyboardVisibility();
  }
}

// TODO: refactor this monstrosity of a class

class CreateForm extends StatefulWidget {
  const CreateForm({Key? key}) : super(key: key);

  @override
  _CreateFormState createState() => _CreateFormState();
}

Widget _buildPage({
  required int pageIndex,
  required String title,
  required String description,
  required Widget textField,
  Widget? option,
  List<String>? suggestions,
  Suggestions? suggestionsState,
  required BuildContext context,
}) {
  List<Widget> generateSuggestions() {
    if (suggestions == null || suggestions.isEmpty) return [];
    List<Widget> chips = [];
    bool suggestionsRemovable = Provider.of<_CreateFormState>(context, listen: false).suggestionsRemovable;
    for (String suggestion in suggestions) {
      chips.add(Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: suggestionsRemovable
            ? Chip(
                label: Text(suggestion),
                backgroundColor: Colors.white,
                deleteIconColor: Colors.red,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                onDeleted: () {
                  if (pageIndex == 0)
                    suggestionsState?.removeName(suggestion);
                  else if (pageIndex == 2)
                    suggestionsState?.removeDescription(suggestion);
                },
              )
            : ActionChip(
                label: Text(suggestion),
                backgroundColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                onPressed: () {
                  Provider.of<_CreateFormState>(context, listen: false)._textControllers[pageIndex].text = suggestion;
                },
              ),
      ));
    }
    return chips;
  }

  int currentPageIndex = Provider.of<_CreateFormState>(context, listen: false)._pageIndex;
  void goBack() => Provider.of<_CreateFormState>(context, listen: false).goBack();
  void goNext() => Provider.of<_CreateFormState>(context, listen: false).goNext();
  void submitTab() => Provider.of<_CreateFormState>(context, listen: false)._submitTab();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 24),
        if (suggestions != null && suggestions.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: AnimationLimiter(
                  child: Container(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: AnimationConfiguration.toStaggeredList(
                        delay: Duration(milliseconds: 150),
                        duration: Duration(milliseconds: 200),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 70.0,
                          child: FadeInAnimation(
                            duration: Duration(milliseconds: 300),
                            child: widget,
                          ),
                        ),
                        children: generateSuggestions(),
                      ),
                    ),
                  ),
                ),
              ),
              if (pageIndex != 1)
                IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(
                        Provider.of<_CreateFormState>(context, listen: false).suggestionsRemovable ? Icons.done_all : Icons.edit),
                    onPressed: () {
                       Provider.of<_CreateFormState>(context, listen: false).setState(() { Provider.of<_CreateFormState>(context, listen: false).suggestionsRemovable = !Provider.of<_CreateFormState>(context, listen: false).suggestionsRemovable;});
                    }),
            ],
          ),
        suggestions != null && suggestions.isNotEmpty
            ? SizedBox(height: 12)
            : SizedBox(height: 42),
        Row(
          children: <Widget>[
            Flexible(child: textField),
            if (option != null) option,
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPageIndex > 0)
                  TextButton(
                    onPressed: goBack,
                    child: Text('Back'),
                  ),
                ElevatedButton(
                  onPressed: currentPageIndex == 2 ? submitTab : goNext,
                  child: Text(currentPageIndex == 2 ? 'Create' : 'Next'),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _CreateFormState extends State<CreateForm> with KeyboardVisibilityMixin {
  final _formKey = GlobalKey<FormState>();
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
  int _pageIndex = 0;
  double _formProgress = 0.15;
  bool userOwesFriend = false;
  bool suggestionsRemovable = false;
  Suggestions? suggestionsState;
  SettingsState? settingsState;
  List<String> _nameSuggestions = [];
  bool _showNameSuggestions = false;

  @override
  void initState() {
    super.initState();
    Contacts.checkPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    suggestionsState = Provider.of<Suggestions>(context);
    settingsState = Provider.of<SettingsState>(context);
  }

  @override
  void dispose() {
    // Clean up the focus nodes when the Form is disposed.
    _focusNodes.forEach((element) {
      element.dispose();
    });
    _textControllers.forEach((controller) {
      controller.dispose();
    });
    _pageViewController.dispose();
    super.dispose();
  }

  void _submitTab() {
    if (_formKey.currentState?.validate() ?? false) {
      TabsController.createTab(
        name: _textControllers[0].text,
        amount: double.tryParse(_textControllers[1].text) ?? 0.0,
        description: _textControllers[2].text,
        userOwesFriend: userOwesFriend,
      );
      Navigator.pop(context);
    }
  }

  void goBack() {
    setState(() {
      _formProgress -= 1 / 3;
      _focusNodes[--_pageIndex].requestFocus();
      suggestionsRemovable = false;
    });
    _pageViewController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  void goNext() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _formProgress += 1 / 3;
        _focusNodes[++_pageIndex].requestFocus();
        suggestionsRemovable = false;
      });
      _pageViewController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  Future<void> _updateNameSuggestions(String pattern) async {
    if (pattern.isEmpty) {
      setState(() {
        _nameSuggestions = [];
        _showNameSuggestions = false;
      });
      return;
    }
    final results = await Contacts.queryContacts(pattern);
    setState(() {
      _nameSuggestions = results;
      _showNameSuggestions = results.isNotEmpty;
    });
  }

  Widget _buildNamePage() {
    return _buildPage(
      context: context,
      pageIndex: 0,
      title: "Name",
      description:
          "Enter the name of the person who you're making this tab for.",
      textField: Column(
        children: [
          TextFormField(
            controller: _textControllers[0],
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            focusNode: _focusNodes[0],
            decoration: InputDecoration(prefixIcon: Icon(Icons.person)),
            onChanged: (value) {
              _updateNameSuggestions(value);
            },
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please provide a name';
              return null;
            },
          ),
          if (_showNameSuggestions)
            Container(
              constraints: BoxConstraints(maxHeight: 150),
              child: Card(
                margin: EdgeInsets.only(top: 4),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _nameSuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _nameSuggestions[index];
                    return ListTile(
                      title: Text(suggestion),
                      onTap: () {
                        setState(() {
                          _textControllers[0].text = suggestion;
                          _showNameSuggestions = false;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      suggestions: suggestionsState?.suggestions["names"] as List<String>?,
      suggestionsState: suggestionsState,
    );
  }

  Widget _buildAmountPage() {
    return _buildPage(
      context: context,
      pageIndex: 1,
      title: "Amount",
      description: userOwesFriend
          ? "Why does ${_textControllers[0].text} owe you ${settingsState?.selectedCurrency ?? ''}${_textControllers[1].text}?"
          : "Why does ${_textControllers[0].text} owe you ${settingsState?.selectedCurrency ?? ''}${_textControllers[1].text}?",
      option: IconButton(
        color: userOwesFriend ? Colors.red : Theme.of(context).primaryColor,
        icon: Icon(Icons.swap_horiz),
        visualDensity: VisualDensity.comfortable,
        enableFeedback: true,
        tooltip: "Tap to change who owes who",
        onPressed: () {
          setState(() {
            userOwesFriend = !userOwesFriend;
          });
        },
      ),
      textField: TextFormField(
        controller: _textControllers[1],
        focusNode: _focusNodes[1],
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(prefixIcon: Icon(Icons.card_giftcard)),
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Please enter the amount owed';
          if (double.tryParse(value!) == null)
            return "Please enter a valid number";
          return null;
        },
      ),
      suggestions: suggestionsState?.suggestions["amounts"] as List<String>?,
      suggestionsState: suggestionsState,
    );
  }

  Widget _buildDescriptionPage() {
    return _buildPage(
      context: context,
      pageIndex: 2,
      title: "What's this for?",
      description: userOwesFriend
          ? "Why do you owe ${_textControllers[0].text} ${settingsState?.selectedCurrency ?? ''}${_textControllers[1].text}?"
          : "Why does ${_textControllers[0].text} owe you ${settingsState?.selectedCurrency ?? ''}${_textControllers[1].text}?",
      textField: TextFormField(
        controller: _textControllers[2],
        focusNode: _focusNodes[2],
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.message),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Please enter a reason';
          if (value!.length > 21)
            return 'Surpassed character limit. ${value.length}/21';
          return null;
        },
      ),
      suggestions: suggestionsState?.suggestions["descriptions"] as List<String>?,
      suggestionsState: suggestionsState,
    );
  }

  @override
  Widget build(BuildContext context) {
    suggestionsState = Provider.of<Suggestions>(context);
    settingsState = Provider.of<SettingsState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Tab'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: _formProgress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageViewController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildNamePage(),
            _buildAmountPage(),
            _buildDescriptionPage(),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
