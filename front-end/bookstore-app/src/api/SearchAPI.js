import axios from 'axios'
import { API_URL } from '../Constants'

class SearchAPI
{
	executeSearchAPIService(title)
	{
		console.log('Service executed')
		return axios.get(`${API_URL}/bookstore/books/searchByTitle/${title}`)
	}
	
	executeBookDetailsAPIService(id)
	{
		console.log('executeBookDetailsAPIService executed for ' + id)
		return axios.get(`${API_URL}/bookstore/books/getBookDetails/${id}`)
	}
	
	executeSearchByIdAPIService(id)
	{
		console.log('executeSearchByIdAPIService')
		return axios.get(`${API_URL}/bookstore/books/searchById/${id}`)
	}
	
	executeBrowseByCategoryAPIService(id)
	{
		console.log('executeBrowseByCategoryAPIService')
		return axios.get(`${API_URL}/bookstore/books/getBooksByCategory/${id}`)
	}
}

export default new SearchAPI();