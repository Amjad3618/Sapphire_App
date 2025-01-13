import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.edit))],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        radius: 50,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text("Name"),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: IconButton(
                              onPressed: () {}, icon: Icon(Icons.delete)),
                          leading: CircleAvatar(
                              radius: 20,
                              child:
                                  Center(child: Text((index + 1).toString()))),
                          title: Text("cut off Date & time "),
                          subtitle: Text("turn on Date & time "),
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
