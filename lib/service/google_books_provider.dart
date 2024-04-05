  import 'package:book_shelf/service/google_books_service.dart';
  import 'package:book_shelf/model/book.dart';
  import 'package:flutter/material.dart';


  class GoogleBooksProvider with ChangeNotifier {
    GoogleBooksService? googleBooksService;

    List<Book> _item = [];
    List<Book> get bookItem => _item;

    bool _isLoading = true;
    bool get isLoading => _isLoading;

    GoogleBooksProvider(String url) {
      googleBooksService = GoogleBooksService();
      getResults(url);
    }

    void getResults(String url) async {
      // Если отправить пустую строку, то ничего не найдет, поэтому если ничего не введено, заменяю на пробел
      url = url == "" ? " ":url;
      setLoading(true);
      List<Book> result = await googleBooksService!
          .getBooks(url);
      _item = result;
      setLoading(false);
    }

    void setLoading(bool b) {
      _isLoading = b;
      notifyListeners();
    }

  }
