
class FavoriteProduct {
  String id = '';
  String userId = '';
  String productId = '';
  //String userId, String productId, String id טענת כניסה : פעולה שמקבלת
  //טענת יציאה : הפעולה יוצרת מוצר אהוב חדש
  FavoriteProduct(String userId, String productId, String id) {
    this.id = id;
    this.productId = productId;
    this.userId = userId;
  }
}
