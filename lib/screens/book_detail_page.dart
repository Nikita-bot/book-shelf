import 'package:book_shelf/model/book.dart';
import 'package:book_shelf/widget/preview_button_widget.dart';
import 'package:book_shelf/utils/spacer.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';


class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({Key? key, required this.book, this.fav})
      : super(key: key);
  final Book book;
  final String? fav;

  @override
  Widget build(BuildContext context) {
    String dateString = book.publishedDate!;
    String date;
    if (dateString.length == 4) {
      date = dateString;
    } else if (dateString.length == 7) {
      DateTime d = DateFormat("yyyy-mm").parse(dateString);
      date = DateFormat("MMMM yyyy").format(d);
    } else {
      DateTime d = DateFormat("yyyy-mm-dd").parse(dateString);
      date = DateFormat("d MMMM yyyy").format(d);
    }

    return Scaffold(
      body: _Details(
        item: book,
        date: date,
        fav: false,
        docId: null,
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({
    Key? key,
    required this.item,
    required this.date,
    required this.fav,
    required this.docId,
  }) : super(key: key);

  final Book item;
  final String date;
  final bool fav;
  final String? docId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * .35,
            flexibleSpace: SizedBox(
              height: MediaQuery.of(context).size.height * .45,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        controller: TabController(length: 2, vsync: Scaffold.of(context)),
                        children: [
                          item.thumbnailUrl != null
                              ? Image.network(item.thumbnailUrl!)
                              : const FlutterLogo(),
                          Center(
                            child: Text(
                              (item.pageCount != 'null'
                                  ? (item.pageCount! + ' pages\n\n')
                                  : '') +
                                  (item.publishedDate != null
                                      ? 'Published ' + date
                                      : '') +
                                  (item.publisher != null
                                      ? '\nby ' + item.publisher!
                                      : '') +
                                  (item.isbn13 != null
                                      ? '\n\nISBN: ' + item.isbn13!
                                      : ''),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          2,
                              (index) {
                            final _color = index == 0 ? Colors.white : Colors.grey;
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(
                                Icons.circle,
                                size: 10,
                                color: _color,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: 250,
                      child: Text(
                        item.title ?? '',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ('by ' + (item.authors ?? 'Not available')),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14.0,
                        //color: Colors.black,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                      child: Divider(
                        color: Colors.grey,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  5,
                                      (int index) {
                                    if (item.averageRating != null) {
                                      return item.averageRating is double &&
                                          index !=
                                              item.averageRating!.toInt()
                                          ? Icon(
                                        Icons.star,
                                        size: 16,
                                        color: index <
                                            item.averageRating!
                                                .toInt()
                                            ? Colors.orange[800]
                                            : Colors.grey[300],
                                      )
                                          : HalfFilledIcon(
                                        icon: Icons.star,
                                        color: Colors.orange[800]!,
                                        size: 16,
                                      );
                                    } else {
                                      return Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.grey[300],
                                      );
                                    }
                                  },
                                )),
                            const SizedBox(width: 8),
                            Text(
                              item.averageRating?.toString() ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          ((item.ratingCount?.toString() ?? '0 ') +
                              ' ratings '),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                      child: Divider(
                        color: Colors.grey,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ),
                    item.embeddable!
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PreviewButtonWidget(
                          volumeId: item.isbn13!,
                          availability: true,
                          title: item.title,
                          previewLink: item.previewLink,
                        ),
                      ],
                    )
                        : Container(),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                      child: Divider(
                        color: Colors.grey,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ),
                    const VerticalSpace(
                      h: 15,
                    ),
                    item.description != null
                        ? Column(
                      children: [
                        Text(
                          'BOOK DESCRIPTION',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          indent: 135,
                          endIndent: 135,
                        ),
                      ],
                    )
                        : Container(),
                    Container(
                      //height: MediaQuery.of(context).size.height * .2,
                      padding: const EdgeInsets.all(16.0),
                      child: ReadMoreText(
                        item.description ?? '',
                        trimLines: 10,
                        colorClickableText: Colors.deepOrange,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'read more',
                        trimExpandedText: 'read less',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HalfFilledIcon extends StatelessWidget {
  const HalfFilledIcon(
      {Key? key, required this.icon, required this.size, required this.color})
      : super(key: key);

  final IconData icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect rect) {
        return LinearGradient(
          stops: const [0, 0.5, 0.5],
          colors: [color, color, color.withOpacity(0)],
        ).createShader(rect);
      },
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(icon, size: size, color: Colors.grey[300]),
      ),
    );
  }
}