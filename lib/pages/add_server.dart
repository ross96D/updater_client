import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:updater_client/database.dart';
import 'package:updater_client/models/base.dart';
import 'package:updater_client/models/server.dart';
import 'package:updater_client/widgets/button.dart';

class AddServer extends StatefulWidget {
  const AddServer({super.key, this.server});
  final Server? server;

  @override
  State<StatefulWidget> createState() => _AddServer();
}

class _AddServer extends State<AddServer> {
  final _key = GlobalKey<FormState>();
  late Server _state;
  late final TextEditingController nameCtrl;
  late final TextEditingController addressCtrl;
  late final TextEditingController usernameCtrl;
  late final TextEditingController passwordCtrl;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    _state = widget.server ?? Server.emtpy();
    nameCtrl = TextEditingController(text: _state.name.value);
    nameCtrl.addListener(() {
      setState(() {
        _state = _state.copyWith(name: NonEmptyString.dirty(nameCtrl.text));
      });
    });

    addressCtrl = TextEditingController(text: _state.address.value);
    addressCtrl.addListener(() {
      setState(() {
        _state = _state.copyWith(address: Address.dirty(addressCtrl.text));
      });
    });

    usernameCtrl = TextEditingController(text: _state.username.value);
    usernameCtrl.addListener(() {
      setState(() {
        _state = _state.copyWith(username: NonEmptyString.dirty(usernameCtrl.text));
      });
    });

    passwordCtrl = TextEditingController(text: _state.password.value);
    passwordCtrl.addListener(() {
      setState(() {
        _state = _state.copyWith(password: NonEmptyString.dirty(passwordCtrl.text));
      });
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    addressCtrl.dispose();
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            TextFormField(
              key: const Key('AddServer_Name'),
              controller: nameCtrl,
              decoration: const InputDecoration(
                icon: Icon(Icons.computer_rounded),
                labelText: "server display name",
              ),
              validator: (value) => _state.name.validator(value ?? "")?.text(),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            TextFormField(
              key: const Key('AddServer_Address'),
              controller: addressCtrl,
              decoration: const InputDecoration(
                icon: Icon(Icons.insert_link),
                labelText: "server address",
              ),
              validator: (value) => _state.address.validator(value ?? "")?.text(),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
            ),
            TextFormField(
              key: const Key('AddServer_Username'),
              controller: usernameCtrl,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: "username",
              ),
              validator: (value) => _state.username.validator(value ?? "")?.text(),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    key: const Key('AddServer_Password'),
                    controller: passwordCtrl,
                    obscureText: !showPassword,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: "password",
                    ),
                    validator: (value) => _state.password.validator(value ?? "")?.text(),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 5),
                SizedOverflowBox(
                  size: const Size(35, 50),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SmallIconButton(
                      icon: const Icon(Icons.remove_red_eye, size: 25),
                      onTap: () => setState(() => showPassword = !showPassword),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(children: [
                ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      final store = GetIt.instance.get<ServerRepository>();
                      store.add(_state);
                      context.pop();
                    }
                  },
                  child: const Text('Submit'),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
