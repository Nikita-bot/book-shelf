import 'dart:async';

import 'package:book_shelf/model/book.dart';
import 'package:book_shelf/service/google_books_provider.dart';
import 'package:book_shelf/widget/book_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/spacer.dart';


//Виджет остается Statefull, чтобы был доступ к глобальному контексту
class BookFinderPage extends StatefulWidget {
  const BookFinderPage({Key? key}) : super(key: key);

  @override
  _BookFinderPageState createState() => _BookFinderPageState();
}

class _BookFinderPageState extends State<BookFinderPage> {
  final textController = TextEditingController();
  Timer? searchOnStoppedTyping;
  final ScrollController _sc = ScrollController();

  void _onChangeHandler(String value) {
    const duration = Duration(milliseconds: 500);
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping!.cancel();
    }
    searchOnStoppedTyping = Timer(duration, () => _search(value));
  }

  //Переписал функцию, теперь она работает только с провайдером
  void _search(String value) {

    final googleBooksProvider = context.read<GoogleBooksProvider>();
    googleBooksProvider.getResults(value);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        controller: _sc,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 50, bottom: 16),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search for books...',
                    ),
                    onChanged: _onChangeHandler,
                  ),
                ),
              ),
            ),
            const VerticalSpace(h: 10),
            //Переписал виджет, теперь он в зависимости от состояния показывает экран загрузки
            //Или экран с книгами
            SizedBox(
              child: Consumer<GoogleBooksProvider>(
                builder: (context, gBookProvider, _) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: gBookProvider.isLoading
                        ? _buildLoadingWidget()
                        : _buildListView(gBookProvider.bookItem),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.grey[400]!,
          child: ListTile(
            title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.red,
              ),
              height: 130.0,
              width: 50.0,
            ),
          ),
        );
      },
    );
  }

  //Экран с книгами генерируется на основе данных из провайдера
  Widget _buildListView(List<Book> books) {
    return ListView.builder(
      controller: _sc,
      shrinkWrap: true,
      itemCount: books.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/detail', arguments: {'book': books[index]}),
          child: BookListWidget(
            book: books[index],
          ),
        );
      },
    );
  }
}