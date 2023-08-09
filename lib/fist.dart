import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class first extends StatefulWidget {
  const first({super.key});

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  final CollectionReference _products =
  FirebaseFirestore.instance.collection('products');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
    }
    await showBottomSheet(context: context, builder: (BuildContext ctx) {
      return Padding(padding: EdgeInsets.only(
          top: 20, left: 20, right: 20, bottom: MediaQuery
          .of(ctx)
          .viewInsets
          .bottom + 20), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),),
          TextField(controller: _priceController,
            decoration: InputDecoration(labelText: 'Price'),),
          ElevatedButton(onPressed: ()async{
            final String name =_nameController.text;
            final double?price=double.tryParse(_priceController.text);
            if(price!=null){
              await _products
                  .doc(documentSnapshot!.id)
                  .update({"name":name,"price":price});
              _nameController.text="";
              _priceController.text="";
            }
          }, child: Text("Update"))
        ],
      ),
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      margin: EdgeInsets.all(10),
                      child: Column(

                        children: [
                          ListTile(
                            title: Text(documentSnapshot['name']),
                            subtitle: Text(
                                documentSnapshot['price'].toString()),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit), onPressed: () {
                                    _update(documentSnapshot);
                                  })
                                ],
                              ),
                            ),
                          ),

                          ListTile(
                            title: Text(documentSnapshot['namea']),
                            subtitle: Text(
                                documentSnapshot['pricee'].toString()),
                          ),
                          Container(
                              height: 200,
                              width: 200,
                              child: FadeInImage.assetNetwork(
                                  placeholder: "asset/amalie-steiness (1).gif",
                                  image: documentSnapshot['img']
                              )
                            // Image.network(documentSnapshot['img'],)
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
