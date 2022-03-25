import { useEffect, useState } from 'react';
import yelp from '../api/yelp';
export default () => {


    const [error, setError] = useState('');
    const [results, setResults] = useState([]);
    const searchApi = async (searchTerm) => {
        console.log("hi")
        const response = await yelp.get('/search', {
            params: {
                limit: 50,
                searchTerm,
                location: 'san jose'
            }
        }).catch((error) => {
            console.log(error)
            setError(error)
        })
        setResults(response.data.businesses)
    };

    useEffect(() => { searchApi('pasta') }, [])

    return [searchApi, results, error]

}