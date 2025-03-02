import "dart:convert";

import "package:http/http.dart" as http;

import "../Models/model.dart";
import "../utils/urls.dart";


class ProductController {
  List<Data> product = [];

  Future<void> fetchProduct() async {
    final response = await http.get(Uri.parse(Urls.readProduct));
    // print(response.body);
    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      Model model = Model.fromJson(data);

      product = model.data ?? []; // jodi data ase data pass hobe nahole empty list show hobe

      // product=data["data"]; // api data ar data parameter ar length
    }
    print(product);
  }

  Future<void> createProduct(
      String name, img, int qty, totalPrice, price) async {
    final response = await http.post(Uri.parse(Urls.createProduct),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ProductName": name,
          "ProductCode": DateTime.now().millisecondsSinceEpoch,
          "Img": img,
          "Qty": qty,
          "UnitPrice": price,
          "TotalPrice": totalPrice
        }));

    if (response.statusCode == 201) {
      fetchProduct();
    }
  }

  Future<void> updateProduct(
      String id, name, img, int qty, totalPrice, price) async {
    final response = await http.post(Uri.parse(Urls.updateProduct(id)),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ProductName": name,
          "ProductCode": DateTime.now().microsecondsSinceEpoch,
          "Img": img,
          "Qty": qty,
          "UnitPrice": price,
          "TotalPrice": totalPrice
        }));

    if (response.statusCode == 201) {
      fetchProduct();
    }
  }

  Future<bool> deleteProduct(String id) async {

    final response = await http.get(Uri.parse(Urls.deleteProduct(id)));

    if (response.statusCode == 200) {
      return true;
    }else{
      return false;
    }
  }

}
