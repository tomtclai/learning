package com.example.movie.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.example.movie.screens.MovieScreens
import com.example.movie.screens.home.HomeScreen
import com.example.movie.screens.home.details.DetailsScreen

@Composable
fun MovieNavigation() {
    val navController = rememberNavController()
    NavHost(navController = navController,
        startDestination = MovieScreens.HomeScreen.name) {
        composable(MovieScreens.HomeScreen.name) {
            // pass where it should lead
             HomeScreen(navController = navController)
        }
        // detail-screen/id=34
        composable(MovieScreens.DetailsScreen.name+"/{movie}",
        arguments = listOf(navArgument(name = "movie") {type= NavType.StringType})) {
            backStackEntry ->

            DetailsScreen(navController = navController,
                backStackEntry.arguments?.getString("movie"))
        }
    }
}