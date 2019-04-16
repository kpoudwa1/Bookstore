import axios from 'axios'
var crypto = require('crypto'); 

class UserAPI
{
	executeCreateUserAPIService(stateData)
	{
		console.log('Service executed')
		let salt = crypto.randomBytes(16).toString('hex'); 
		console.log('Salt: ' + salt);
		console.log(stateData)
		stateData.salt = salt;
		console.log(stateData)
		stateData.password = crypto.pbkdf2Sync(stateData.password, stateData.email, 1000, 64, `sha512`).toString(`hex`)
		console.log(crypto.pbkdf2Sync(stateData.password, stateData.email, 1000, 64, `sha512`).toString(`hex`))
		
		
		console.log(stateData)
		return axios.post(`http://localhost:8080/user/create/`, stateData)
	}
	
	executeAuthenticateUserAPIService(user)
	{
		console.log('executeAuthenticateUserAPIService')
		console.log(user)
		user.password = crypto.pbkdf2Sync(user.password, user.email, 1000, 64, `sha512`).toString(`hex`)
		console.log(user)
		
		return axios.post(`http://localhost:8080/user/authenticate/`, user)
	}
}

export default new UserAPI();