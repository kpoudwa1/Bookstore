import axios from 'axios'

class HelloWorldService
{
	executeHelloWorldService()
	{
		console.log('Service executed')
		return axios.get('http://localhost:8080/bookstore/books/')
	}
}

export default new HelloWorldService();