package com.example.movie.widgets

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.CornerSize
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountBox
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.rememberAsyncImagePainter
import coil.compose.rememberImagePainter
import coil.transform.CircleCropTransformation
import com.example.movie.model.Movie
import com.example.movie.model.getMovies

@Preview
@Composable
fun MovieRow(
    movie: Movie = getMovies().first(),
    expandedInitial: Boolean = false,
    onItemClick: (String) -> Unit = {}) {

    var expanded by remember {
        mutableStateOf(expandedInitial)
    }
    Card(
        modifier = Modifier
            .padding(4.dp)
            .fillMaxWidth()
            .clickable {
                onItemClick(movie.id)
            },
        shape = RoundedCornerShape(corner = CornerSize(16.dp)),
        elevation = 6.dp
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Start
        ) {
            Surface(
                modifier = Modifier
                    .padding(12.dp)
                    .size(100.dp),
                shape = RectangleShape,
                elevation = 4.dp
            ) {
                Image(painter = rememberImagePainter(data = movie.images[0], builder = {
                    crossfade(true)
                    transformations(CircleCropTransformation())
                }), contentDescription = "Movie picture")
            }
                Column(modifier = Modifier.padding(4.dp)) {
                    Text(text = movie.title, style = MaterialTheme.typography.h6)
                    Text(text = "Director: ${movie.director}", style = MaterialTheme.typography.caption)
                    Text(text = "Released: ${movie.year}", style = MaterialTheme.typography.caption)
                    AnimatedVisibility(visible = expanded) {
                        Column {
                            Text(buildAnnotatedString {
                                withStyle(style = SpanStyle(color = Color.DarkGray, fontSize = 13.sp)) {
                                    append("Plot: ")
                                }
                                withStyle(style = SpanStyle(color = Color.DarkGray, fontSize = 13.sp, fontWeight = FontWeight.Bold)) {
                                    append(movie.plot)
                                }
                            })
                            
                            Divider(modifier = Modifier.padding(3.dp))
                            Text(text = "Director: ${movie.director}", modifier = Modifier.padding(6.dp), style = MaterialTheme.typography.caption)
                            Text(text = "Actors: ${movie.actors}", modifier = Modifier.padding(6.dp), style = MaterialTheme.typography.caption)
                            Text(text = "Rating: ${movie.rating}", modifier = Modifier.padding(6.dp), style = MaterialTheme.typography.caption)
                        }
                    }
                    Icon(imageVector = if(expanded) Icons.Filled.KeyboardArrowUp else Icons.Filled.KeyboardArrowDown, contentDescription = if (expanded) "Down Arrow" else "Up Arrow",
                        modifier = Modifier
                            .size(25.dp)
                            .clickable {
                                expanded = !expanded
                            },
                        tint = Color.DarkGray)
                }
                }






    }

}