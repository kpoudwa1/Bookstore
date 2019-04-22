import axios from 'axios'
var crypto = require('crypto'); 

class UserAPI
{
	registerLogin(firstName)
	{
		sessionStorage.setItem('authenicatedUser', firstName);
	}
	
	registerLogout()
	{
		sessionStorage.removeItem('authenicatedUser');
	}
	
	isUserLoggedIn()
	{
		let user = sessionStorage.getItem('authenicatedUser');
		
		if(user === null)
			return false
		else
			return true
	}
	
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
	
	executeGetUserDetailsAPIService(email)
	{
		console.log('executeGetUserDetailsAPIService')
		console.log(email)
		let data = {email : email}
		
		console.log(data);
		
		return axios.post(`http://localhost:8080/user/userDetails/`, email.toString())
	}
	
	executeGetPreviousPurchasesAPIService(userId)
	{
		console.log('executeGetPreviousPurchasesAPIService');
		console.log(userId);
		let axiosConfig = {
		headers: {
          'Content-Type': 'application/json;charset=UTF-8'
      }
    };
		
		return axios.post(`http://localhost:8080/user/previouspurchase/`, userId, axiosConfig)
	}
}

export default new UserAPI();