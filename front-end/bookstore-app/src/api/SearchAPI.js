import axios from 'axios'

class SearchAPI
{
	executeSearchAPIService(title)
	{
		console.log('Service executed')
		return axios.get(`http://localhost:8080/bookstore/books/${title}`)
	}
	
	executeBookDetailsAPIService(id)
	{
		console.log('executeBookDetailsAPIService executed for ' + id)
		return axios.get(`http://localhost:8080/bookstore/booksDetails/${id}`)
	}
	
	executeSearchByIdAPIService(id)
	{
		console.log('executeSearchByIdAPIService')
		return axios.get(`http://localhost:8080/bookstore/book/${id}`)
	}
	
	executeBrowseByCategoryAPIService(id)
	{
		console.log('executeBrowseByCategoryAPIService')
		return axios.get(`http://localhost:8080/bookstore/booksByCategory/${id}`)
	}
}

export default new SearchAPI();