import axios from 'axios'
import { API_URL } from '../Constants'

class SearchAPI
{
	executeSearchAPIService(title)
	{
		return axios.get(`${API_URL}/bookstore/books/searchByTitle/${title}`)
	}
	
	executeBookDetailsAPIService(id)
	{
		return axios.get(`${API_URL}/bookstore/books/getBookDetails/${id}`)
	}
	
	executeSearchByIdAPIService(id)
	{
		return axios.get(`${API_URL}/bookstore/books/searchById/${id}`)
	}
	
	executeBrowseByCategoryAPIService(id)
	{
		return axios.get(`${API_URL}/bookstore/books/getBooksByCategory/${id}`)
	}
}

export default new SearchAPI();