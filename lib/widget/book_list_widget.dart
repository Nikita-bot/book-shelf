import 'package:book_shelf/model/book.dart';
import 'package:flutter/material.dart';

class BookListWidget extends StatelessWidget {
  const BookListWidget({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      author: book.authors,
      title: book.title,
      thumbnail: book.thumbnailUrl,
      rating: book.averageRating,
      category: book.categories,
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    this.thumbnail,
    required this.title,
    required this.rating,
    this.author,
    required this.category,
  });

  final String? thumbnail;
  final String? title;
  final double? rating;
  final String? author;
  final String? category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 5,
        child: Container(
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 0.0, bottom: 8.0),
                child: Container(
                  width: 100,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: thumbnail != null
                        ? Image.network(
                      thumbnail!,
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                    )
                        : const FlutterLogo(),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 24.0, 2.0, 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        ('by ' + (author ?? 'Not available')),
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        title ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.yellow[700],
                          ),
                          const SizedBox(width: 5),
                          Text(
                            rating?.toString() ?? 'unrated',
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey[600],
                            ),
                          )
                        ],
                      ),
                      Container(
                        //width: 80,
                        height: 20,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.3,
                        ),
                        decoration: BoxDecoration(
                            color: const Color(0xffABDEFF),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            category ?? 'Not available',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10.0,
                              color: Color(0xff46A4FF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}