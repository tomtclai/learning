import axios from "axios";

export default axios.create({
  baseURL: 'https://api.yelp.com/v3/businesses',
  headers: {
    Authorization: 'Bearer ' + 'yQI1tv0e-iQG0rhjtutRp'+'4bXfO2WcXyUvB5fOE27m4rHkgk40g41looggMGsBRzIHi_FSW10EPT9an1pwjqmRUUnRpYibZHhny109OlXVFM47uUOyDxAY3xkdP7uYXYx'
  }
})

