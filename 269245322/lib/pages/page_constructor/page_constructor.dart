import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../main.dart';
import 'page_cubit.dart';
import 'page_state.dart';

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
          appBar: AppBar(),
          body: _body(_controller, widget.pageCubit, state, context),
        );
      },
    );
  }
}

Padding _body(TextEditingController _controller, PageCubit pageCubit,
    PageState state, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
    child: Column(
      children: [
        const Text(
          'Create a new page',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
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
          thickness: 2.0,
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
                      backgroundColor: Colors.blue,
                      key: UniqueKey(),
                      child: Icon(
                        pageIcons[index],
                        color: Colors.black,
                        size: 35.0,
                      ),
                    ),
                    Positioned(
                      top: 35.0,
                      left: 30.0,
                      child: Radio<int>(
                        value: index,
                        groupValue: state.selectedIcon,
                        onChanged: (value) {
                          pageCubit.setNewSelectesIconValue(value!);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              state.createNewPageChecker!
                  ? pageCubit.addNewPage(_controller.text)
                  : pageCubit.editExistingPage(_controller);

              Navigator.pop(context);
            },
            child: Text(state.createNewPageChecker! ? 'create' : 'edit'),
          ),
        ),
      ],
    ),
  );
}
