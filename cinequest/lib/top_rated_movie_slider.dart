import 'package:cinequest/constants.dart';
import 'package:cinequest/movie_model.dart';
import 'package:cinequest/movie_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinequest/movie.dart'; 
class TopRatedMoviesSlider extends StatelessWidget {
  final String? userEmail;
  const TopRatedMoviesSlider({Key? key, this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesListModel = Provider.of<MovieModel>(context);
    final topRatedMovies = moviesListModel.get_all_top_rated_movies;

    return topRatedMovies.isNotEmpty
        ? SizedBox(
            height: 250,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // apply scroll effects
              physics: const BouncingScrollPhysics(),
              itemCount: topRatedMovies.length, // show 10 movies
              itemBuilder: (context, index) {
                final top_rated_movie = topRatedMovies[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoviePage(
                            movie_image_path: top_rated_movie.movie_image_path,
                            movie_title: top_rated_movie.movie_title,
                            movie_synopsis: top_rated_movie.movie_synopsis,
                            movie_release_date: top_rated_movie.movie_release_date,
                            movie_vote_avg: top_rated_movie.movie_vote_avg,
                            movieId: top_rated_movie.id,
                            movie_original_title: top_rated_movie.movie_original_title,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 250,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage('${Constants.image_path}${top_rated_movie.movie_image_path}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: FavoriteIcon(top_rated_movie), // Pass the Movie object here
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}

class FavoriteIcon extends StatefulWidget {
  final Movie movie;

  FavoriteIcon(this.movie);

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    final moviesListModel = Provider.of<MovieModel>(context);
    final saved_movies = moviesListModel.get_savedMovies;

    bool isFavorite = false;
    if (saved_movies.isNotEmpty && saved_movies.indexWhere((movie) => movie.id == widget.movie.id) >= 0) {
      isFavorite = true;
    } else {
      isFavorite = false;
    }

    return GestureDetector(
      onTap: () {
        Provider.of<MovieModel>(context, listen: false).toggleFavorite(context, widget.movie);
      },
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.white,
        size: 24,
      ),
    );
  }
}

