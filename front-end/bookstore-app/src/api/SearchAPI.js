import axios from 'axios'

class SearchAPI
{
	executeSearchAPIService(title)
	{
		console.log('Service executed')
		return axios.get(`http://localhost:8080/bookstore/books/${title}`)
	}
	
	executeBookDetailsAPIService(title)
	{
		console.log('executeBookDetailsAPIService executed')
		return axios.get(`http://localhost:8080/bookstore/books/${title}`)
	}
}

export default new SearchAPI();