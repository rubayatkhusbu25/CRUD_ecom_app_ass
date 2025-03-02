import 'package:flutter/material.dart';

import '../../../data/controller/product_controller.dart';
import '../widgets/textfield_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final ProductController productController = ProductController();

  Future<void> fetchData() async {
    await productController.fetchProduct();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ecommerce CRUD with API"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange.withOpacity(.5),
      ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange.withOpacity(.5),
          onPressed: () => productDialog(),
          child: Icon(Icons.add),
        ),

      body: productController.product.isEmpty?
          Center(
            child: CircularProgressIndicator(),
          )
          :Column(
            children: [
              SizedBox(height: 5,),

              Expanded(
                child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5
                
                        ),
                itemCount: productController.product.length,
                itemBuilder: (context, index) {
                  var productC = productController.product[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      color: Colors.deepOrange.withOpacity(.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.blueAccent.shade700,

                        )
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Image.network(
                                  productC.img.toString(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(productC.productName.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                            Text("Price: \$${productC.unitPrice} | Qty: ${productC.qty}"),

                            Row(

                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min, // otherwise the row will not showed in the trailing
                              children: [
                                IconButton(
                                  onPressed: () => productDialog(
                                      id: productC.sId,
                                      name: productC.productName,
                                      qty: productC.qty,
                                      img: productC.img,
                                      price: productC.unitPrice,
                                      totalPrice: productC.totalPrice),
                                  icon: Icon(Icons.edit),
                                ),
                                SizedBox(width: 60,),
                                IconButton(
                                  onPressed: () {
                                    productController.deleteProduct(productC.sId.toString()).then((value){
                                      if(value){

                                        setState(() {
                                          fetchData();
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Product Delete"),
                                              duration: Duration(seconds: 2),
                                            )

                                        );
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Something wrong"),
                                              duration: Duration(seconds: 2),
                                            ));
                                      }



                                    });

                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                  );
                
                
                
                }),
              ),
            ],
          )


    );
  }

  void productDialog({
    String? id,
    name,
    img,
    int? qty,
    price,
    totalPrice,
  }) {
    TextEditingController nameController = TextEditingController();
    // TextEditingController codeController=TextEditingController();
    TextEditingController qtyController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController imageController = TextEditingController();
    TextEditingController tpController = TextEditingController();

    //initialize controller with parameters value

    nameController.text = name ?? "";
    qtyController.text = qty != null?  qty.toString(): "0";
    priceController.text = price.toString() ?? "";
    imageController.text = img ?? "";
    tpController.text = totalPrice !=null? totalPrice.toString() : "0";

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(id == null ? "Add Product" : "Update Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextfieldWidget(textEditingController:nameController ,label: "Product Name",),
              TextfieldWidget(textEditingController: imageController, label: "Product image"),
              TextfieldWidget(textEditingController: priceController, label: "Product price"),
              TextfieldWidget(textEditingController: qtyController, label: 'Product Qty'),
              TextfieldWidget(textEditingController: tpController, label: 'Product Total Price'),


              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel",style: TextStyle(color: Colors.white),)),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await productController.createProduct(
                              nameController.text,
                              imageController.text,
                              int.parse(qtyController.text),
                              int.parse(tpController.text),
                              int.parse(priceController.text));
                        } else {
                          await productController.updateProduct(
                              id,
                              nameController.text,
                              imageController.text,
                              int.parse(qtyController.text),
                              int.parse(tpController.text),
                              int.parse(priceController.text));
                        }

                        await fetchData();
                        Navigator.pop(context);
                        setState(() {

                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.deepOrange.withOpacity(.5),)
                      ),
                      child: Text(
                          id == null ? "Add Product" : "Update Product",style: TextStyle(color: Colors.white),))
                ],
              )
            ],
          ),
        ));
  }

}
