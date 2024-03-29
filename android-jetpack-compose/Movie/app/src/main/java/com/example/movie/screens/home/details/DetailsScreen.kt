package com.example.movie.screens.home.details

import android.annotation.SuppressLint
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import coil.compose.rememberImagePainter
import com.example.movie.model.Movie
import com.example.movie.model.getMovies
import com.example.movie.widgets.MovieRow

@SuppressLint("UnusedMaterialScaffoldPaddingParameter")
@Composable
fun DetailsScreen(navController: NavController, movieID: String?) {
    val movie = getMovies().first { it.id == movieID }
    Scaffold(topBar = {
        TopAppBar(backgroundColor = Color.Transparent,
            elevation = 5.dp
        ) {
            Row(horizontalArrangement = Arrangement.Start) {
                Icon(imageVector = Icons.Default.ArrowBack, contentDescription = "Arrow back", modifier = Modifier.clickable {
                    navController.popBackStack()
                })
                Spacer(modifier = Modifier.width(100.dp))
                Text(text = "Movies")

            }

        }
    }) {
        Surface(modifier = Modifier
            .fillMaxHeight()
            .fillMaxWidth()) {
                Column(horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center) {

                    MovieRow(movie = movie, expandedInitial = true)

                    Spacer(modifier = Modifier.height(8.dp))
                    Divider()
                    Text(text = "Movie Images")
                    HorizontalScrollableImageView(movie)
            }
        }
    }

}

@Composable
private fun HorizontalScrollableImageView(movie: Movie) {
    LazyRow {
        items(movie.images) { image ->
            Card(
                modifier = Modifier
                    .padding(12.dp)
                    .size(240.dp), elevation = 5.dp
            ) {
                Image(
                    painter = rememberImagePainter(data = image),
                    contentDescription = "Movie poster"
                )
            }
        }
    }
}