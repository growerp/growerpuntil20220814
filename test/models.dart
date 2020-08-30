import 'package:master/models/@models.dart';
import 'data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('user', () {
    String json1 = userToJson(user);
    User newObj = userFromJson(json1);
    expect(userToJson(newObj), userToJson(user));
    String json2 = usersToJson(users);
    List<User> newObjs = usersFromJson(json2);
    expect(usersToJson(newObjs), usersToJson(users));
  });

  test('category', () {
    String json1 = categoryToJson(category);
    Category newObj = categoryFromJson(json1);
    expect(categoryToJson(newObj), categoryToJson(category));
    String json2 = categoriesToJson(categories);
    List<Category> newObjs = categoriesFromJson(json2);
    expect(categoriesToJson(newObjs), categoriesToJson(categories));
  });

  test('product', () {
    String json1 = productToJson(product);
    Product newObj = productFromJson(json1);
    expect(productToJson(newObj), productToJson(product));
    String json2 = productsToJson(products);
    List<Product> newObjs = productsFromJson(json2);
    expect(productsToJson(newObjs), productsToJson(products));
  });

  test('catalog', () {
    String json1 = catalogToJson(catalog);
    Catalog newObj = catalogFromJson(json1);
    expect(catalogToJson(newObj), catalogToJson(catalog));
  });

  test('company', () {
    String json1 = companyToJson(company);
    Company newObj = companyFromJson(json1);
    expect(companyToJson(newObj), companyToJson(company));
    String json2 = companiesToJson(companies);
    List<Company> newObjs = companiesFromJson(json2);
    expect(companiesToJson(newObjs), companiesToJson(companies));
  });

  test('authenticate', () {
    String json1 = authenticateToJson(authenticate);
    Authenticate newAuth = authenticateFromJson(json1);
    expect(authenticateToJson(newAuth), authenticateToJson(authenticate));
  });
}
