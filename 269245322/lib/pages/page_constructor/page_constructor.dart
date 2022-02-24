import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../main.dart';
import 'page_cubit.dart';
import 'page_state.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter/cupertino.dart';

class PageConstructor extends StatefulWidget {
  late final PageCubit pageCubit;
  PageConstructor({Key? key}) : super(key: key);

  static const routeName = '/pageConstructor';

  @override
  _PageConstructorState createState() => _PageConstructorState();
}

class _PageConstructorState extends State<PageConstructor> {
  bool idkHowToDoAnotherWay = false;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (idkHowToDoAnotherWay != true) {
      widget.pageCubit =
          (ModalRoute.of(context)!.settings.arguments as PageCubit);
      if (widget.pageCubit.state.createNewPageChecker == false) {
        _controller.text = widget.pageCubit.state.pageToEdit!.title;
      }
      idkHowToDoAnotherWay = true;
    }
    return BlocBuilder<PageCubit, PageState>(
      bloc: widget.pageCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('New page..'),
          ),
          body: _body(_controller, widget.pageCubit, state, context),
          backgroundColor: Theme.of(context).backgroundColor,
        );
      },
    );
  }
}

Padding _body(
  TextEditingController _controller,
  PageCubit pageCubit,
  PageState state,
  BuildContext context,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'enter page title',
                speed: const Duration(milliseconds: 150),
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
            isRepeatingAnimation: false,
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            controller: _controller,
            maxLines: 1,
            maxLength: 50,
            decoration: const InputDecoration(
              hintText: 'new node',
              fillColor: Colors.black12,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ),
        const Divider(
          height: 50.0,
          thickness: 1.0,
          indent: 10.0,
          endIndent: 10.0,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50.0,
              vertical: 0.0,
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
              ),
              itemCount: pageIcons.length,
              itemBuilder: (context, index) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).iconTheme.color,
                      key: UniqueKey(),
                      child: Icon(
                        pageIcons[index],
                        color: Colors.black,
                        size: 35.0,
                      ),
                    ),
                    Positioned(
                      top: 30.0,
                      left: 30.0,
                      child: Radio<int>(
                        value: index,
                        groupValue: state.selectedIcon,
                        onChanged: (value) {
                          pageCubit.setNewSelectesIconValue(value!);
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          alignment: Alignment.centerRight,
          child: AnimatedButton(
            width: 100.0,
            height: 40.0,
            child: Text(
              state.createNewPageChecker! ? 'create' : 'edit',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              state.createNewPageChecker!
                  ? pageCubit.addNewPage(_controller.text)
                  : pageCubit.editExistingPage(_controller);

              Navigator.pop(context);
            },
            enabled: true,
            shadowDegree: ShadowDegree.light,
          ),
        ),
      ],
    ),
  );
}
