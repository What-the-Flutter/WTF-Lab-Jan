part of 'journal_page.dart';

class InputField extends StatefulWidget {
  final journalInd;

  InputField(this.journalInd);

  @override
  _InputFieldState createState() => _InputFieldState(journalInd);
}

class _InputFieldState extends State<InputField> {
  final journalInd;

  _InputFieldState(this.journalInd);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    JournalsBloc bloc = BlocProvider.of<JournalsBloc>(context);

    return BlocBuilder<JournalsBloc, JournalsState>(
      builder: (context, state) {
        return Container(
          height: 60,
          child: Container(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: Icon(Icons.add_outlined),
                ),
                Container(
                  child: Flexible(
                    child: Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: TextField(
                          controller: state.controller,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: GestureDetector(
                    onTap: () {
                      String text = state.controller.value.text;
                      if(text!=""){
                        bloc.add(SendPressed(journalInd));
                      }
                    },
                    child: Icon(
                      Icons.send_outlined,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
